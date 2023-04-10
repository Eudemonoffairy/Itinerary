//
//  ZHLocationUtils.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//

#import "ZHLocationUtils.h"
@interface ZHLocationUtils()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@end
@implementation ZHLocationUtils
static ZHLocationUtils *instance;

+(instancetype) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance){
            instance = [[ZHLocationUtils alloc]init];
        }
    });
    return instance;
}
-(void)startLocation{
    //  判断定位是否允许
    if([CLLocationManager locationServicesEnabled]){
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = 10.0f;
        [_locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
    }else{
        NSLog(@"嘎嘎-机械嘎嘎");
    }
}


//  MARK: - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    NSLog(@"%@", locations);
    //  当前所在城市的坐标值
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            if(placemarks.count > 0){
                CLPlacemark *placeMark = placemarks[0];
                NSLog(@"当前用户所在城市： %@", placeMark.locality);
            }else if(error){
                NSLog(@"定位错误：%@", error);
            }else if(error == nil && placemarks.count == 0){
                NSLog(@"未返回");
            }
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if(error.code == kCLErrorDenied){
        NSLog(@"访问被拒绝");
    }else if(error.code == kCLErrorLocationUnknown){
        NSLog(@"无法获取用户信息");
    }
}


@end
