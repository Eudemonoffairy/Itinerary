//
//  ZHPlace.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/18.
//  景点模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHPlace : NSObject

///  景点 id
@property (nonatomic, assign) NSInteger placeId;
///  景点名称
@property (nonatomic, strong) NSString *placeName;
///  经度
@property (nonatomic, assign) CGFloat longitude;
///  纬度
@property (nonatomic, assign) CGFloat latitude;
///  标签
@property (nonatomic, strong) NSString *tip;
///  景点特色
@property (nonatomic, strong) NSString *feature;
///  儿童门票
@property (nonatomic, assign) CGFloat cPrice;
///  老人门票
@property (nonatomic, assign) CGFloat oPrice;
///  成人门票
@property (nonatomic, assign) CGFloat pPrice;
///  评分
@property (nonatomic, assign) CGFloat guide;
///  景点图片
@property (nonatomic, strong) NSString *imageUrls;
///  建议游玩时间时长
@property (nonatomic, strong) NSString *rangeTime;
///  开放时间
@property (nonatomic, strong) NSString *openTime;
///  景点介绍
@property (nonatomic, strong) NSString *introduce;
///  景点所在城市 ID
@property (nonatomic, assign) NSInteger cityid;

@end

NS_ASSUME_NONNULL_END
