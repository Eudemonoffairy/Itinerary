//
//  ZHMapUtil.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZHMapUtil : NSObject
+(instancetype) sharedInstance;
///  将坐标串分割为单个坐标字符串
+ (NSArray *)coordinateArrayWithPolylineString:(NSString *)string;

///  将单个坐标字符串转换为坐标
+ (CLLocationCoordinate2D)coordinateWithString:(NSString *)string;

///  获取两坐标之间的驾车出行规划
-(void)getRoutesStart:(CLLocationCoordinate2D) startCoordinate destination:(CLLocationCoordinate2D) destinationCoordinate mode:(NSInteger)mode ;

-(void)searchPlace:(NSString *)POIID;
-(void)searchPOIs:(NSArray *)poiIDs;
@end

NS_ASSUME_NONNULL_END
