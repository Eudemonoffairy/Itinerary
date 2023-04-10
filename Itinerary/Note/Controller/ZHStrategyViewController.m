//
//  ZHStrategyViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import "ZHStrategyViewController.h"
#import "ZHCarousel.h"
#import "ZHBigImageViewController.h"
#import "ZHStatisticBar.h"
#import "ZHCommentViewController.h"
#import "ZHScrollView.h"
#import "ZHCommentBar.h"
#import "ZHMapViewController.h"
#import "ZHPlace.h"
#import <AFNetworking.h>
#import "ZHNetworkingUtils.h"

//  TODO: 轮播图最左边和最右边不能滑动
//  TODO: 头像和作者名为死数据
//  TODO: 评论区为死数据

@interface ZHStrategyViewController ()<ZHCarouselDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) ZHStatisticBar *statisticBar;
@property (nonatomic, strong) ZHScrollView *scrollView;
@property (nonatomic, strong) ZHCommentViewController *commentVC;
@property (nonatomic, assign) BOOL canSlide;

@property (nonatomic, assign) CGFloat lastPositionY;
//  滑动临界范围值
@property (nonatomic, assign) CGFloat dragCriticalY;

@property (nonatomic) dispatch_group_t group;

@end

@implementation ZHStrategyViewController

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
   
    
    UIView *containerView = [[UIView alloc]init];
    [self.scrollView addSubview:containerView];
    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    __weak __typeof__(self) weekSelf = self;
    self.commentVC.slideDragBlock = ^{
        weekSelf.canSlide = YES;
        weekSelf.commentVC.canSlide = NO;
    };
    
    
   
    //  轮播图（手动）
    ZHCarousel *carousel = [[ZHCarousel alloc]init];
    [containerView addSubview:carousel];
    [carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(containerView.mas_top).mas_offset(0);
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.height.mas_offset(300);
    }];
    carousel.delegate = self;
    
    //  TODO: 图集
    NSArray *imgUrlArr = [self.imgUrls componentsSeparatedByString:@"|"];
    carousel.imageArr = [self urlToImage:imgUrlArr];
    carousel.currentPageColor = [UIColor themeColor];
    carousel.pageColor = [UIColor whiteColor];
    
    [containerView addSubview:self.strategyTitle];
    self.strategyTitle.font = [UIFont fontSize_h1];
    [self.strategyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(carousel.mas_bottom).mas_offset(8);
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        
    }];
    
    [self.authorAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.strategyTitle.mas_bottom).mas_offset(8);
            make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(12);
            make.width.height.mas_equalTo(32);
    }];
//    [self.authorAvatar setImage:[UIImage imageNamed:@"normal_avatar"]];
    self.authorAvatar.layer.cornerRadius = 16;
    self.authorAvatar.layer.masksToBounds = YES;
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.authorAvatar.mas_right).mas_offset(12);
            make.centerY.mas_equalTo(self.authorAvatar.mas_centerY);
    }];
//    self.authorName.text = @"作者名";
    
        
    self.statisticBar = [[ZHStatisticBar alloc]initWithDataDic:self.dataDic];
    [containerView addSubview:self.statisticBar];
    [self.statisticBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left).mas_offset(0);
        make.right.mas_equalTo(containerView.mas_right).mas_offset(-64);
        make.top.mas_equalTo(self.authorAvatar.mas_bottom).mas_offset(8);
        make.height.mas_offset(48);
    }];
    self.statisticBar.backgroundColor =[UIColor statisticBGColor];
//    self.statisticBar.layer.cornerRadius = 4 ;
//    self.statisticBar.layer.masksToBounds = YES;
    
    [containerView addSubview:self.showWayButton];
    [self.showWayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statisticBar.mas_top);
        make.left.mas_equalTo(self.statisticBar.mas_right).mas_offset(4);
        make.right.mas_equalTo(containerView.mas_right).mas_offset(-12);
        make.bottom.mas_equalTo(self.statisticBar.mas_bottom);
    }];
    [self.showWayButton setImage:[UIImage imageNamed:@"icon_map"] forState:UIControlStateNormal];
    self.showWayButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12);
    [self.showWayButton setBackgroundColor:[UIColor statisticBGColor]];
    self.showWayButton.layer.cornerRadius = 4;
    self.showWayButton.layer.masksToBounds = YES;
    
    
    [containerView addSubview:self.detailText];
    
    [self.detailText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(containerView.mas_left).mas_offset(12);
        make.right.mas_equalTo(containerView.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.statisticBar.mas_bottom).mas_offset(12);
    }];

    
    NSMutableAttributedString *attrivuteStr = [[NSMutableAttributedString alloc]initWithString:self.contentStr];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 6.0;//  设置行间距
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [attrivuteStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrivuteStr.length)];
    self.detailText.attributedText = attrivuteStr;
    [self.detailText sizeToFit];
    
    ZHCommentBar *commentBar = [[ZHCommentBar alloc]init];
    [self.view addSubview:commentBar];
    [commentBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.detailText.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(48);
    }];
    [self.view layoutIfNeeded];
    NSLog(@"%f", commentBar.frame.origin.y);
    
    _dragCriticalY =  commentBar.frame.origin.y + commentBar.frame.size.height + STATUS_BAR_HEIGHT;
    
    
    
    commentBar.layer.borderWidth = 1;
    commentBar.layer.borderColor = [[UIColor systemGray4Color] CGColor];
    commentBar.layer.masksToBounds = YES;

    
    [self addChildViewController:self.commentVC];
    [containerView addSubview:self.commentVC.view];
    [self.commentVC didMoveToParentViewController:self];
    
    [self.commentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentBar.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(containerView.mas_left);
        make.right.mas_equalTo(containerView.mas_right);
        make.height.mas_offset(SCREEN_HEIGHT);
//        make.bottom.mas_equalTo(containerView.mas_bottom);
    }];
    
    [self.view layoutIfNeeded];
    
    [self.commentVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        if(self.commentVC.tableView.contentSize.height < SCREEN_HEIGHT){
            make.height.mas_offset(self.commentVC.tableView.contentSize.height);
        }
    }];
    

    [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.commentVC.tableView);
    }];
}

- (void)carouselView:(ZHCarousel *)carouselView indexOfClickedImageButton:(NSUInteger)index{
    NSLog(@"点击了第%ld张图片", index);
}

- (void)carouselView:(ZHCarousel *)carouselView toBigimg:(UIImage *)image{    
    ZHBigImageViewController *imgViewController = [[ZHBigImageViewController alloc]initWithImage:image];
    imgViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:imgViewController animated:NO];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 懒加载
- (ZHInsetLabel *)strategyTitle{
    if(!_strategyTitle){
        _strategyTitle = [[ZHInsetLabel alloc]init];
        _strategyTitle.leftEdge = 12;
        _strategyTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _strategyTitle.numberOfLines = 3;
        _strategyTitle.textColor = [UIColor blackColor];
    }
    return _strategyTitle;
}

- (NSMutableDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [[NSMutableDictionary alloc]init];
    }
    return _dataDic;
}

- (UIImageView *)authorAvatar{
    if(!_authorAvatar){
        _authorAvatar = [[UIImageView alloc]init];
        [self.scrollView addSubview:_authorAvatar];
    }
    return _authorAvatar;
}

- (UILabel *)authorName{
    if(!_authorName){
        _authorName = [[UILabel alloc]init];
        [self.scrollView addSubview:_authorName];
    }
    return _authorName;
}

- (UILabel *)detailText{
    if(!_detailText){
        _detailText = [[UILabel alloc]init];
        _detailText.numberOfLines = 0;
        [_detailText adjustsFontSizeToFitWidth];
        _detailText.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _detailText;
}

- (UIButton *)showWayButton{
    if(!_showWayButton){
        _showWayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showWayButton addTarget:self action:@selector(showWayAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showWayButton;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat currentPostion = scrollView.contentOffset.y;
    /*
     当 底层滚动式图滚动到指定位置时，
     停止滚动，开始滚动子视图
     */
    if (currentPostion >= self.dragCriticalY) {
        scrollView.contentOffset = CGPointMake(0, self.dragCriticalY);
        if (self.canSlide) {
            self.canSlide = NO;
            self.commentVC.canSlide = YES;
        }
        else{
            if (_lastPositionY - currentPostion > 0){
                if (self.commentVC.tableView.contentOffset.y > 0) {
                    self.commentVC.canSlide = YES;
                    self.canSlide = NO;
                }
                else{
                    self.commentVC.canSlide = NO;
                    self.canSlide = YES;
                }
            }
        }
    }else{
        if (!self.canSlide && scrollView.contentOffset.y ==  self.dragCriticalY ) {
            scrollView.contentOffset = CGPointMake(0, self.dragCriticalY);
        }
        else{
            if (self.commentVC.canSlide &&
                self.commentVC.tableView.contentOffset.y != 0) {
                scrollView.contentOffset = CGPointMake(0, self.dragCriticalY);
            }
            else{
                
            }
        }
    }
    
    _lastPositionY = currentPostion;
}

- (ZHCommentViewController *)commentVC{
    if(!_commentVC ){
        _commentVC = [[ZHCommentViewController alloc]init];
        _commentVC.commentArr = [self.commentArr copy];
    }
    return _commentVC;
}

- (ZHScrollView *)scrollView{
    if (!_scrollView) {
            _scrollView = [[ZHScrollView alloc]init];
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.delegate = self;
      
    }
    return _scrollView;
}


-(void) showWayAction{
    if(self.group == nil){
        dispatch_group_t group = dispatch_group_create();
        self.group = group;
    }
    
    NSArray *placeIDArr = [self.placeids componentsSeparatedByString:@"&"];
    NSMutableDictionary *placeDic = [NSMutableDictionary dictionary];
    NSMutableArray *placeArr = [NSMutableArray array];
    for( NSString *placeid in placeIDArr){
        dispatch_group_enter(self.group);
        NSDictionary *params = @{
            @"id":placeid
        };
        [ZHNetworkingUtils requestWithURL:@"/place/getoneplace" method:RequestMethodGET parameters:params needToken:YES success:^(id  _Nonnull responseObject) {
            dispatch_group_leave(self.group);
            NSLog(@"%@", responseObject);
            ZHPlace *aPlace = [[ZHPlace alloc]init];
            NSMutableDictionary *data = responseObject[@"data"];
            aPlace.placeId = [data[@"id"] integerValue];
            aPlace.placeName = data[@"name"];
            aPlace.longitude = [data[@"longitude"] integerValue];
            aPlace.latitude = [data[@"latitude"] integerValue];
            aPlace.tip = data[@"tip"];
            aPlace.feature = data[@"feature"];
            aPlace.cPrice = [data[@"cprice"] floatValue] ;
            aPlace.oPrice = [data[@"oprice"] floatValue];
            aPlace.pPrice = [data[@"pprice"] floatValue];
            aPlace.guide = [data[@"guide"]integerValue];
            aPlace.imageUrls =  data[@"image"];
            aPlace.rangeTime = data[@"rangetime"];
            aPlace.openTime = data[@"opentime"];
            aPlace.introduce = data[@"introduce"];
            aPlace.cityid = [data[@"cityid"] integerValue];
            
            [placeDic setValue:aPlace forKey:[NSString stringWithFormat:@"%ld" ,aPlace.placeId]];
            
        } failure:^(NSError * _Nonnull error) {
            dispatch_group_leave(self.group);
        }];
    }
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        
        for(int i = 0; i < placeIDArr.count;i++){
            [placeArr addObject:placeDic[placeIDArr[i]]];
        }
        
        
        ZHMapViewController *mapVC = [[ZHMapViewController alloc]init];
        mapVC.placeArr = [placeArr copy];
        mapVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:mapVC animated:YES];
    });
   
    
    
    
    
    
//    ZHPlace *place_1 = [[ZHPlace alloc]init];
//    place_1.placeName = @"紫金县苏维埃政府旧址";
//    place_1.longitude =  115.351484;
//    place_1.latitude = 23.355034;
//
//
//    ZHPlace *place_2 = [[ZHPlace alloc]init];
//    place_2.placeName = @"德先楼";
//    place_2.longitude = 115.406503;
//    place_2.latitude = 23.308995;
//    ZHPlace *place_3 = [[ZHPlace alloc]init];
//    place_3.placeName = @"桂山石楼";
//    place_3.longitude =  115.270285;
//    place_3.latitude = 23.446798;
//
//    ZHPlace *place_4 = [[ZHPlace alloc]init];
//    place_4.placeName = @"刘尔崧纪念馆";
//    place_4.longitude = 115.179548;
//    place_4.latitude = 23.634456;
//
//
//
//    mapVC.placeArr = [[NSArray arrayWithObjects: place_1, place_2, place_3, place_4, nil] mutableCopy];
    
  
}


-(NSArray *)urlToImage:(NSArray *) urls{
    NSMutableArray *imgArr = [NSMutableArray array];
    for(NSString *url in urls){
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:url] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
//            [self.userBar.userAvatar setImage:image];
            [imgArr addObject:image];
        }];
    }
    return imgArr;
}


@end
