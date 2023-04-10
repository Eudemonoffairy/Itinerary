//
//  ZHMapViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/16.
//

#import "ZHMapViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>


#import "ZHMapUtil.h"

#import "ZHSchemeViewController.h"
#import "ZHRouteInfoViewController.h"



@interface ZHMapViewController ()<MAMapViewDelegate, AMapSearchDelegate>
/* 路径规划类型 */
@property (nonatomic, strong) MAMapView *mapView;

//@property (nonatomic, strong) ZHRouteInfoViewController *routeInfoVC;

@property(nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) ZHPositionButtonBar *positionBar;
@property (nonatomic, strong) ZHSchemeViewController *schemeViewController;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) AMapRoute *routes;
@property (nonatomic, strong) MAPolyline *commonPolyline;

@end

@implementation ZHMapViewController

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.search= [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.mapView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(48);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.mapView.mas_bottom);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(48);
    }];
    [self.positionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.leftButton.mas_bottom);
        make.height.mas_equalTo(64);
    }];
    
    

    [self.schemeViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.positionBar.mas_bottom);
    }];
    
    [self leftAction];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(updateMapRoutes:) name:MAP_ROUTES object:nil];
    [center addObserver:self selector:@selector(showInMap:) name:SHOW_IN_MAP object:nil];
    
}

- (void)viewDidAppear:(BOOL)animated{
    NSMutableArray *annotationArr = [NSMutableArray array];
    for(int i = 0; i < self.placeArr.count; i++){
        MAPointAnnotation *aAnnotation = [[MAPointAnnotation alloc] init];
        aAnnotation.coordinate = CLLocationCoordinate2DMake(self.placeArr[i].latitude , self.placeArr[i].longitude);
        aAnnotation.title      = self.placeArr[i].placeName;

        [annotationArr addObject:aAnnotation];
    }
    [self.mapView addAnnotations:annotationArr];
    [self.mapView showAnnotations:annotationArr animated:YES];
    
    
}



#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    //  配置线路颜色
    if([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc]initWithPolyline:overlay];
        
        polylineRenderer.lineWidth = 8.f;
        polylineRenderer.strokeColor = [UIColor systemBlueColor];
        polylineRenderer.lineJoinType = kMALineJoinRound;
        polylineRenderer.lineCapType = kMALineCapRound;
        
        return polylineRenderer;
    }
    return nil;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}


-(void)updateMapRoutes :(NSNotification *)notification{
    self.routes = notification.userInfo[@"Routes"];
    
    if(self.positionBar.mode == 0){
        //  驾车
        NSInteger pathCount = [self.routes.paths count];
        NSMutableDictionary *sourceDic = [NSMutableDictionary dictionary];
        for(int i = 0; i < pathCount; i++){
            NSString *keyName = [NSString stringWithFormat:@"方案 %d",i];
            NSString *distance = [NSString stringWithFormat:@"距离: %ld 米", self.routes.paths[i].distance];
            NSString *duration = [NSString stringWithFormat:@"预计耗时: %ld 时 %ld 分 %ld 秒", self.routes.paths[i].duration/3600, (self.routes.paths[i].duration%3600)/60, (self.routes.paths[i].duration%3600)%60];
            NSArray *valueArr = @[distance, duration];
            [sourceDic setValue:valueArr forKey:keyName];
        }
        self.schemeViewController.sourceDic = [sourceDic copy];
//        self.schemeViewController.view.backgroundColor = [UIColor redColor];
        [self.schemeViewController initData];
        [self.schemeViewController.tableView reloadData ];
    }
    else{
        //  公交/步行
        
        
        
        
        
        
        
    }
    
    
//    AMapPath *path = self.routes.paths[0];
//    NSMutableArray *coordinateArr = [NSMutableArray array];
//    for(AMapStep *step in path.steps){
//        NSString *polyline = step.polyline;
//        [coordinateArr addObjectsFromArray:[ZHMapUtil coordinateArrayWithPolylineString:polyline]];
//    }
//    CLLocationCoordinate2D *runningCoords = (CLLocationCoordinate2D *)malloc(coordinateArr.count * sizeof(CLLocationCoordinate2D));
//        for(int i = 0; i < coordinateArr.count; i++){
//            CLLocationCoordinate2D coor = [ZHMapUtil coordinateWithString:coordinateArr[i]];
//            runningCoords[i] = coor;
//        }
//
//    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:runningCoords count:coordinateArr.count];
//    self.commonPolyline = commonPolyline;
//    [self.mapView addOverlay:commonPolyline];

    
    
}

-(void)showInMap:(NSNotification *)notification{
    NSNumber *routeIndex = notification.userInfo[@"routeIndex"];
    if(!self.commonPolyline){
        self.commonPolyline = [[MAPolyline alloc]init];
    }else{
        [self.mapView removeOverlay:self.commonPolyline];
    }
    AMapPath *path = self.routes.paths[routeIndex.integerValue];
    NSMutableArray *coordinateArr = [NSMutableArray array];
    for(AMapStep *step in path.steps){
        NSString *polyline = step.polyline;
        [coordinateArr addObjectsFromArray:[ZHMapUtil coordinateArrayWithPolylineString:polyline]];
    }
    CLLocationCoordinate2D *runningCoords = (CLLocationCoordinate2D *)malloc(coordinateArr.count * sizeof(CLLocationCoordinate2D));
        for(int i = 0; i < coordinateArr.count; i++){
            CLLocationCoordinate2D coor = [ZHMapUtil coordinateWithString:coordinateArr[i]];
            runningCoords[i] = coor;
        }
        
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:runningCoords count:coordinateArr.count];
    self.commonPolyline = commonPolyline;
    [self.mapView addOverlay:commonPolyline];
  
}


#pragma mark - 懒加载
- (MAMapView *)mapView{
    if(!_mapView){
        _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, 280)];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

///  驾车
- (UIButton *)leftButton{
    if(!_leftButton){
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"icon_map_left_0"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"icon_map_left_1"] forState:UIControlStateSelected];
        [_leftButton setBackgroundColor:[UIColor whiteColor]];
        [_leftButton setTitle:@"驾车" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateSelected];
        [_leftButton setTitleColor:[UIColor systemGray4Color] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_leftButton];
        [self.view layoutIfNeeded];
    }
    return _leftButton;
}

//  公交/步行
- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"icon_map_right_0"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"icon_map_right_1"] forState:UIControlStateSelected];
        [_rightButton setBackgroundColor:[UIColor whiteColor]];
        [_rightButton setTitle:@"公交/步行" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateSelected];
        [_rightButton setTitleColor:[UIColor systemGray4Color] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rightButton];
        [self.view layoutIfNeeded];
    }
    return _rightButton;
}


-(void)leftAction{
    
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    self.leftButton.backgroundColor = [UIColor whiteColor];
    self.rightButton.backgroundColor = [UIColor systemGray2Color];
    self.positionBar.mode = 0;


}
-(void)rightAction{
    
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    self.rightButton.backgroundColor = [UIColor whiteColor];
    self.leftButton.backgroundColor = [UIColor systemGray2Color];
    self.positionBar.mode = 1;

}


- (ZHPositionButtonBar *) positionBar{
    if(!_positionBar){
        _positionBar = [[ZHPositionButtonBar alloc]init];
        _positionBar.positionArr = self.placeArr;
        _positionBar.backgroundColor = [UIColor whiteColor];
        _positionBar.contentSize = _positionBar.frame.size;
        _positionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_positionBar];
        
    }
    return _positionBar;
}

- (ZHSchemeViewController *)schemeViewController{
    if(!_schemeViewController){
        _schemeViewController = [[ZHSchemeViewController alloc]init];
        [self addChildViewController:_schemeViewController];
        [self.view addSubview:_schemeViewController.view];
        [_schemeViewController didMoveToParentViewController:self];
    }
    return _schemeViewController;
}



@end
