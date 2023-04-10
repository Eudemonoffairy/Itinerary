//
//  ZHEntertainmentViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/4.
//

#import "ZHEntertainmentViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZHEntertainCell.h"
#import "ZHEntertain.h"
@interface ZHEntertainmentViewController ()<AMapSearchDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
//  经度纬度
@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation ZHEntertainmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    [self startLocation];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    self.longitude = 113.349677;
    self.latitude = 23.092648;
    [self searchPoiByCenterCoordinate];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //  由于首页没有显示导航栏，这里要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.search = [[AMapSearchAPI alloc]init];
        self.search.delegate = self;
    }
    return self;
}

// MARK: - 懒加载
- (UITableView *)tableview{
    if(!_tableview){
        _tableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[ZHEntertainCell class] forCellReuseIdentifier:@"EntertainCell"];
        _tableview.rowHeight = 156;
//        _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.allowsSelection = NO;
        [self.view addSubview:_tableview];
    }
    return _tableview;
}


//  MARK: - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHEntertainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EntertainCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ZHEntertainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EntertainCell"];
    }
    
    ZHEntertain *entertain = self.dataArray[indexPath.item];
    if([entertain.imageUrl isEqualToString:@""]){
        [cell.cellImage setImage:[UIImage imageNamed:@"no_cover"]];
    }
    else{
        [cell.cellImage sd_setImageWithURL:[NSURL URLWithString:entertain.imageUrl] placeholderImage:[UIImage imageNamed:@"no_cover"]];
    }
    cell.cellTiitle.text = entertain.title;
    cell.typeLabel.text = entertain.type;
    cell.ratingLabel.text = entertain.rating;
    cell.locationLabel.text = entertain.location;
    cell.distanceLabel.text = entertain.distance;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 10;
    return self.dataArray.count;
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"出错啦：%@", error);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if (response.pois.count == 0)
    {
        return;
    }
    
    if(self.dataArray == nil){
        self.dataArray = [[NSMutableArray alloc]init];
        
    }else{
        [self.dataArray removeAllObjects];
    }
        
    //  将数据转换成 Model
    for( AMapPOI *poi in response.pois){
        ZHEntertain *entertain = [[ZHEntertain alloc]init];
        if(poi.images.count != 0){
            entertain.imageUrl = poi.images[0].url;
        }else{
            entertain.imageUrl = @"";
        }
        entertain.title = poi.name;
        
        entertain.type = [poi.type componentsSeparatedByString:@";"][0];
        entertain.rating = poi.businessData.rating;
        entertain.location = poi.address;
        entertain.distance = [NSString stringWithFormat:@"距离您 %ld 米", poi.distance];
        [self.dataArray addObject:entertain];
        
    }
    
    [self.tableview reloadData];
    
}

#pragma mark - Utility
/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
    request.keywords            = @"娱乐|餐饮";
    /* 按照距离排序. */
    request.sortrule            = 0;
    request.showFieldsType      = AMapPOISearchShowFieldsTypeAll;
    [self.search AMapPOIAroundSearch:request];
}

//  获取当前位置的地理位置
- (void)startLocation {
    //判断定位是否允许
    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [_locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    } else {
        //如果没有授权定位，提示开启
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"需要使用定位信息" message:@"获取周边娱乐餐饮信息需要您打开定位信息" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ensure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertVC addAction:ensure];
        [alertVC addAction:cancel];
        [self.navigationController presentViewController:alertVC animated:YES completion:nil];
    }
}

#pragma mark - CLLocationManagerDelegate
//更新用户位置
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    //当前所在城市的坐标值
    CLLocation *currLocation = [locations lastObject];
    self.longitude = currLocation.coordinate.longitude;
    self.latitude = currLocation.coordinate.latitude;
    NSLog(@"经度：%lf, 纬度：%lf", self.longitude, self.latitude);
    //经度：113.349677, 纬度：23.092648
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLErrorDenied) {
        //访问被拒绝
        NSLog(@"位置访问被拒绝");
    } else if (error.code == kCLErrorLocationUnknown) {
        NSLog(@"无法获取用户信息");
    }
}


-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
