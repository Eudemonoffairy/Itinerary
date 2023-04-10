//
//  ZHEntertain.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHEntertain : NSObject
///  封面图片
@property (nonatomic) NSString *imageUrl;
///  标题
@property (nonatomic) NSString *title;
///  评分
@property (nonatomic) NSString *rating;
///  类型
@property (nonatomic) NSString *type;
///  距离
@property (nonatomic) NSString *distance;
///  地址
@property (nonatomic) NSString *location;
@end

NS_ASSUME_NONNULL_END
