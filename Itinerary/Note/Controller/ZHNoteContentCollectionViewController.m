//
//  ZHNoteContentCollectionViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/7.
//

#import "ZHNoteContentCollectionViewController.h"
#import <SDWebImageManager.h>
#import <MJRefresh/MJRefresh.h>
#import "ZHCollectionViewCell.h"
#import "ZHWaterfallFlowLayout.h"
#import "ZHNetworkingUtils.h"
#import "ZHTravels.h"
#import "ZHStrategyViewController.h"

#define ITEM_WIDTH (SCREEN_WIDTH / 2 - 36)

@interface ZHNoteContentCollectionViewController ()<WaterfallFlowLayoutDelegate>
@property (nonatomic, strong) ZHWaterfallFlowLayout *layout;
///  资源列表
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableDictionary *imageDic;
@property (nonatomic) dispatch_group_t group;
@end

@implementation ZHNoteContentCollectionViewController

static NSString * const reuseIdentifier = @"NoteCollectionViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[ZHCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    //  设置布局对象
    self.collectionView.collectionViewLayout = self.layout;
    
    //  集成刷新空间
    MJWeakSelf
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       //  TODO: 下拉刷新
        [weakSelf loadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [weakSelf.collectionView.mj_header beginRefreshing];
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        //  TODO:  上拉加载刷新
        [weakSelf loadMoreData];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}

//  MARK: 懒加载
- (NSMutableArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (NSMutableDictionary *)imageDic{
    if(!_imageDic){
        _imageDic = [[NSMutableDictionary alloc]init];
    }
    return _imageDic;
}

///  collectionView 布局对象
- (ZHWaterfallFlowLayout *)layout{
    if(!_layout){
        _layout = [[ZHWaterfallFlowLayout alloc]init];
        _layout.delegate = self;
    }
    return _layout;
}

//  MARK: 操作数据
///  下拉刷新
-(void) loadData{
    ///  清空资源列表
    [self.dataArr removeAllObjects];
    [self.imageDic removeAllObjects];
    ///  从服务器获取资源
    [self getResource];
}

///  上拉加载刷新
-(void) loadMoreData{
    ///  从服务器获取资源
    [self getResource];
}

/// 获取数据库资源
-(void)getResource{
    [ZHNetworkingUtils requestWithURL:@"/note/gettendata"
                               method:RequestMethodGET
                           parameters:nil needToken:NO
                              success:^(id  _Nonnull responseObject) {
        NSMutableArray *newData = [NSMutableArray array];
        newData = [[self dataToModel:responseObject[@"data"]] mutableCopy];
        [self.dataArr addObjectsFromArray:newData];
        [self getImageResource:newData];
      
    }
                              failure:^(NSError * _Nonnull error) {
        NSLog(@"请求失败 %@ ", error);
    }];
}

//  将所有新增数据的图片集成
-(void)getImageResource:(NSMutableArray *)newData{
    if(newData){
        //  创建 dispatch 组合
        if(self.group == nil)
        {
            dispatch_group_t group = dispatch_group_create();
                self.group = group;
        }
        
        for(ZHTravels * travel in newData){
            //  image 可能包含多个图片，以|分隔
            NSArray<NSString *> *result = [NSArray array];
            result = [travel.image componentsSeparatedByString:@"|"];
            NSURL *imgUrl = [NSURL URLWithString:result[0]];
            
            //  将每个图片加载任务添加到 group 中
            dispatch_group_enter(self.group);
            [[SDWebImageManager sharedManager]loadImageWithURL:imgUrl
                                                       options:SDImageCacheTypeNone
                                                      progress:nil
                                                     completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                if(image && finished){
                    [self.imageDic setObject:image forKey:[NSNumber numberWithInteger:travel.travelID]];
                    //  加载完成后移除任务
                    dispatch_group_leave(self.group);
                }
            }];
            }
        dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
            //  加载完全部图片后执行
            [self.collectionView reloadData];
        });
    }
}

-(NSArray *)dataToModel:(NSArray *)datas{
    NSMutableArray *resultArr = [NSMutableArray array];
    for(NSDictionary * data in datas){
        ZHTravels *travel = [[ZHTravels alloc]init];
        travel.travelID = [data[@"id"] integerValue] ;
        travel.userID = [data[@"userid"] integerValue] ;
        travel.image = (NSString *)data[@"image"];
        travel.title = (NSString *)data[@"title"];
        travel.content = (NSString *)data[@"content"];
        travel.time = (NSInteger)data[@"duration"];
        travel.money = (NSString *)data[@"expense"];
        [resultArr addObject:travel];
    }
    return [resultArr copy];
}

-(void)tapCell:(UITapGestureRecognizer *)tap{
    ZHStrategyViewController * strategyView = [[ZHStrategyViewController alloc]init];
    NSInteger travelId = tap.view.tag;
        //  根据 ID 获取对应的Travels
    NSDictionary *dict = @{
        @"id":[NSNumber numberWithLong:travelId]
    };
    [ZHNetworkingUtils requestWithURL:@"/note/getonenote" method:RequestMethodGET parameters:dict needToken:NO success:^(id  _Nonnull responseObject) {
        NSDictionary *noteDic = responseObject[@"data"][@"note"];
        NSDictionary *commentDic = responseObject[@"data"][@"comments"];
        strategyView.commentArr = [commentDic copy];
        strategyView.imgUrls = noteDic[@"image"];
        strategyView.strategyTitle.text = noteDic[@"title"];
        strategyView.contentStr = noteDic[@"content"];
        strategyView.placeids = noteDic[@"placeid"];
        
        [strategyView.dataDic setObject:noteDic[@"expense"] forKey:@"花销"];
        NSInteger time = [noteDic[@"duration"] integerValue];
        NSString *durationStr = [NSString stringWithFormat:@"%ld h %ld min", time/60, time%60];
        [strategyView.dataDic setObject:durationStr forKey:@"耗时"];
//        [strategyView.dataDic setObject:noteDic[@"expense"] forKey:@"评分"];
        
        ZHCollectionViewCell *cell = tap.view;
        strategyView.authorName.text = cell.authorName.text;
        [strategyView.authorAvatar setImage:cell.avatar.image];
        
        strategyView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:strategyView animated:YES];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求错误：%@", error);
    }];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (ZHCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZHCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    ZHTravels *aTravel = self.dataArr[indexPath.item];
    
    //  获取作者头像和名称
    //  根据用户 ID 获取用户
    NSDictionary *params = @{
        @"id":[NSNumber numberWithInteger:aTravel.userID]
    };
    [ZHNetworkingUtils requestWithURL:@"/user/getuserinfobyid" method:RequestMethodGET parameters:params needToken:YES success:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *responseData = responseObject[@"data"];
        NSInteger codes = [responseObject[@"code"] integerValue];
        if(codes == 200){
            NSString *name = responseData[@"name"];
            cell.authorName.text = name;
            
            NSString *img = responseData[@"image"];
            [cell.avatar sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"normal_avatar"]];
        }
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    UIImage *image = [self.imageDic objectForKey: [NSNumber numberWithInteger:aTravel.travelID]] ;
    [cell.cellImg setImage:image];
    cell.cellTitle.text = aTravel.title;
    cell.tag = aTravel.travelID;
    
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    cell.layer.borderColor = [[UIColor systemGray5Color] CGColor];
    cell.layer.borderWidth = 1;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}

///  返回每个 Cell 的高度
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)itemWidth{

    CGFloat height;
    
    ZHTravels *aTravel = self.dataArr[indexPath.item];
    UIImage *image = [[UIImage alloc]init];
    //  获取对应的图片
    image = [self.imageDic objectForKey: [NSNumber numberWithInteger:aTravel.travelID]];
    CGFloat scare = image.size.width / image.size.height;
    height = itemWidth / scare + 96;
    if(height < 192 + 96){
        height = 96 / 0.618 + 96;
    }
    return height;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
