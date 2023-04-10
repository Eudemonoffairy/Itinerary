//
//  ZHCheckinSetViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import "ZHCheckinSetViewController.h"
#import "ZHCheckinSetCell.h"
#import "ZHNetworkingUtils.h"
static NSString * const reuseIdentifier = @"ZHCheckinSetCell";

@interface ZHCheckinSetViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

@implementation ZHCheckinSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self requestData];
    [self.collectionView registerClass:[ZHCheckinSetCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    
    
}

//  MARK: - 懒加载
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 16, 168);
//        _layout.minimumLineSpacing = 20;
//        _layout.minimumInteritemSpacing = 12;
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
    }
    return _layout;
}



//  MARK: - UICollectionViewDatasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataArray.count;
    return 12;
}

- (ZHCheckinSetCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ZHCheckinSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    [cell.cellImage setImage: [UIImage imageNamed:@"Test_10"]];
    cell.cellTitle.text = @"打卡测试测试测试测试";
    cell.isFinish = 0;
    
    return cell;
}

-(void)requestData{
    NSDictionary *params = @{
        @"cityid":[NSNumber numberWithInteger:1]
    };
    
    [ZHNetworkingUtils requestWithURL:@"/checkin/getonedata" method:RequestMethodPOST parameters:params needToken:YES
    success:^(id  _Nonnull responseObject) {
        NSLog(@"r");
        }
    failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
