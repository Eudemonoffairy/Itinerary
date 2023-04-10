//
//  ZHRoadMapViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/7.
//

#import "ZHRoadMapViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <MAMapKit/MAMapKit.h>

@interface ZHRoadMapViewController ()<MAMapViewDelegate>
//@property (strong, nonatomic) MAMapView* mapView;
@property (nonatomic, strong)MAMapView* mapView;
@end

@implementation ZHRoadMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //把地图添加至view
    
    [AMapServices sharedServices].enableHTTPS = YES;
    
//    self.mapView.showsIndoorMap = YES;        //设置显示室内地图
    self.mapView.zoomLevel = 18;            //设置缩放比例
    self.mapView.zoomEnabled = YES;            //NO表示禁用缩放手势，YES表示开启
    self.mapView.rotateEnabled = NO;        //NO表示禁用旋转手势，YES表示开启
    self.mapView.delegate = self;            //设置代理
//    [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    [self.view addSubview: self.mapView];
    self.mapView.backgroundColor = [UIColor orangeColor];
//    //是否显示用户的位置
//    self.mapView.showsUserLocation = YES;
//    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
//


}

- (void)viewDidAppear:(BOOL)animated{
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
        pointAnnotation.coordinate = CLLocationCoordinate2DMake(31.903477, 118.748333);
        pointAnnotation.title = @"牛首山文化旅游区";
        pointAnnotation.subtitle = @"元宵特惠|4A";

        [self.mapView addAnnotation:pointAnnotation];
    NSMutableArray *annotations = [NSMutableArray array];
    [annotations addObject:pointAnnotation];
    [self.mapView showAnnotations:annotations animated:YES];
    
}

- (MAMapView *)mapView{
    if(!_mapView){
        _mapView = [[MAMapView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 400)];
    }return _mapView;
}

- (void)mapViewRequireLocationAuth:(CLLocationManager *)locationManager
{
    [locationManager requestAlwaysAuthorization];
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

@end
