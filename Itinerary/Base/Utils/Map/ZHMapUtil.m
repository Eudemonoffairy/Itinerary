//
//  ZHMapUtil.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//

#import "ZHMapUtil.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "ZHAttraction.h"

@interface ZHMapUtil()<AMapSearchDelegate>
@property(nonatomic,strong) AMapSearchAPI *search;
@property (nonatomic) dispatch_group_t group;
@property (nonatomic, strong) NSMutableArray *attractionArr;
@end

@implementation ZHMapUtil

//  单例
static ZHMapUtil *instance;
+(instancetype) sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(!instance){
            instance = [[ZHMapUtil alloc]init];
        }
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.search = [[AMapSearchAPI alloc]init];
        self.search.delegate = self;
    }
    return self;
}

///  将坐标串分割为单个坐标字符串
+ (NSArray *)coordinateArrayWithPolylineString:(NSString *)string{
    return [string componentsSeparatedByString:@";"];
}

///  将单个坐标字符串转换为坐标
+ (CLLocationCoordinate2D)coordinateWithString:(NSString *)string{
    NSArray *coorArray = [string componentsSeparatedByString:@","];
    if(coorArray.count != 2){
        return kCLLocationCoordinate2DInvalid;
    }
    return CLLocationCoordinate2DMake([coorArray[1] doubleValue], [coorArray[0] doubleValue]);
}

///  获得两点之前的路线
-(void)getRoutesStart:(CLLocationCoordinate2D) startCoordinate destination:(CLLocationCoordinate2D) destinationCoordinate mode:(NSInteger)mode {
    
    if(!mode){
        //  驾车出行
        //  初始化搜索请求
        AMapDrivingCalRouteSearchRequest *navi = [[AMapDrivingCalRouteSearchRequest alloc]init];
        //  设置返回的拓展数据
        navi.showFieldType = AMapDrivingRouteShowFieldTypeCost|AMapDrivingRouteShowFieldTypeTmcs|AMapDrivingRouteShowFieldTypeNavi|AMapDrivingRouteShowFieldTypeCities|AMapDrivingRouteShowFieldTypePolyline;
        navi.strategy = 32;
        //  出发点
        navi.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude longitude:startCoordinate.longitude];
        navi.destination = [AMapGeoPoint locationWithLatitude:destinationCoordinate.latitude     longitude:destinationCoordinate.longitude];
        [self.search AMapDrivingV2RouteSearch:navi];
    }
    else{
        AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc]init];
        navi.showFieldsType = AMapTransitRouteShowFieldsTypeAll;
        navi.strategy = 0;
        navi.city = @"020";
        navi.destinationCity = @"020";
        navi.origin = [AMapGeoPoint locationWithLatitude:startCoordinate.latitude longitude:startCoordinate.longitude];
  
        navi.destination = [AMapGeoPoint locationWithLatitude:destinationCoordinate.latitude     longitude:destinationCoordinate.longitude];
        [self.search AMapTransitRouteSearch:navi];
    }
}

/* 路径规划搜索回调. */
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response
{
    //  方案数不为空
    if (response.route == nil)
    {
        return;
    }
    
    NSNotification *notice = [NSNotification notificationWithName:MAP_ROUTES object:nil userInfo:@{@"Routes":response.route}];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"--- Error: %@", error);
}




+ (MAMapRect)mapRectForOverlays:(NSArray *)overlays
{
    if (overlays.count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    MAMapRect mapRect;
    MAMapRect *buffer = (MAMapRect*)malloc(overlays.count * sizeof(MAMapRect));
    [overlays enumerateObjectsUsingBlock:^(id<MAOverlay> obj, NSUInteger idx, BOOL *stop) {
        buffer[idx] = [obj boundingMapRect];
    }];
    mapRect = [self mapRectUnion:buffer count:overlays.count];
    free(buffer), buffer = NULL;
    return mapRect;
}

+ (MAMapRect)mapRectUnion:(MAMapRect *)mapRects count:(NSUInteger)count
{
    if (mapRects == NULL || count == 0)
    {
        NSLog(@"%s: 无效的参数.", __func__);
        return MAMapRectZero;
    }
    
    MAMapRect unionMapRect = mapRects[0];
    for (int i = 1; i < count; i++)
    {
        unionMapRect = [self unionMapRect1:unionMapRect mapRect2:mapRects[i]];
    }
    return unionMapRect;
}

+ (MAMapRect)unionMapRect1:(MAMapRect)mapRect1 mapRect2:(MAMapRect)mapRect2
{
    CGRect rect1 = CGRectMake(mapRect1.origin.x, mapRect1.origin.y, mapRect1.size.width, mapRect1.size.height);
    CGRect rect2 = CGRectMake(mapRect2.origin.x, mapRect2.origin.y, mapRect2.size.width, mapRect2.size.height);
    CGRect unionRect = CGRectUnion(rect1, rect2);
    return MAMapRectMake(unionRect.origin.x, unionRect.origin.y, unionRect.size.width, unionRect.size.height);
}


//  搜索景点
-(void)searchPlace:(NSString *)POIID{
    [self searchPoiByID:POIID];
}

-(void)searchPOIs:(NSArray *)poiIDs{
    [self.attractionArr removeAllObjects];
    if(self.group == nil){
        dispatch_group_t group = dispatch_group_create();
        self.group = group;
    }
    for(int i = 0; i < poiIDs.count; i++){
        dispatch_group_enter(self.group);
        [self searchPoiByID:poiIDs[i]];
    }
    
    dispatch_group_notify(self.group, dispatch_get_main_queue(), ^{
        NSNotification *notice = [NSNotification notificationWithName:MAP_ATTRATION object:nil userInfo:@{@"attractions":[self.attractionArr copy]}];
          [[NSNotificationCenter defaultCenter] postNotification:notice];
    });
}


- (NSMutableArray *)attractionArr{
    if(!_attractionArr){
        _attractionArr = [[NSMutableArray alloc]init];
    }
    return _attractionArr;
}


#pragma mark - AMapSearchDelegate


/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    dispatch_group_leave(self.group);
    if (response.pois.count == 0)
    {
        return;
    }
    AMapPOI *poi = [response.pois firstObject];
    ZHAttraction *attration = [[ZHAttraction alloc]init];
    attration.placeCode = poi.uid;
    attration.name = poi.name;
    attration.address = poi.address;
    attration.latitude = poi.location.latitude;
    attration.longitude = poi.location.longitude;
    attration.tel = poi.tel;
    NSMutableArray *imageArr = [[NSMutableArray alloc]init];
    for (AMapImage *image in poi.images){
        [imageArr addObject:image.url];
    }
    attration.images = [imageArr copy];
    attration.opentime = poi.businessData.opentimeWeek;
    attration.cost = poi.businessData.cost;
    attration.rating = poi.businessData.rating;
    NSString *tagString = poi.businessData.tag;
    NSString *typeString = poi.type;
    NSMutableArray *tagArr = [[NSMutableArray alloc]init];
    [tagArr addObjectsFromArray:[typeString componentsSeparatedByString:@";"]];
    [tagArr addObjectsFromArray:[tagString componentsSeparatedByString:@","]];
    
    [self.attractionArr addObject:attration];
    
//
    
    
}

#pragma mark - Utility

/* 根据ID来搜索POI. */
- (void)searchPoiByID:(NSString *)poiId
{
    AMapPOIIDSearchRequest *request = [[AMapPOIIDSearchRequest alloc] init];
    
    request.uid                 = poiId;
    request.showFieldsType      = AMapPOISearchShowFieldsTypeAll;
    [self.search AMapPOIIDSearch:request];
    
}






@end
