//
//  ZHAttraction.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHAttraction : NSObject
///  景点代码
@property (nonatomic, copy) NSString *placeCode;
///  景点名字
@property (nonatomic, copy) NSString *name;
///  景点地址
@property (nonatomic, copy) NSString *address;
///  景点纬度
@property (nonatomic, assign) double latitude;
///  景点经度
@property (nonatomic, assign) double longitude;
///  景点电话
@property (nonatomic, copy) NSString *tel;
///  景点图片 url
@property (nonatomic, copy) NSArray *images;
///  景点营业时间
@property (nonatomic, copy) NSString *opentime;
///  景点人均消费
@property (nonatomic, copy) NSString *cost;
///  景点标签
@property (nonatomic, copy) NSArray *tag;
///  景点评分
@property (nonatomic, copy) NSString *rating;
@end

NS_ASSUME_NONNULL_END
