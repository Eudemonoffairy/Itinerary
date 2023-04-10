//
//  ZHTravels.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//  游记模型

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHTravels : NSObject
///  游记 ID
@property (nonatomic) NSInteger travelID;
///  创建用户 ID
@property (nonatomic) NSInteger userID;
///  图片串列以 | 分隔
@property (nonatomic) NSString *image;
///  游记标题
@property (nonatomic) NSString *title;
///  游记内容
@property (nonatomic) NSString *content;
///  建议游玩时间，单位 s
@property (nonatomic) NSInteger time;
///  花销
@property (nonatomic) NSString* money;
///  评分
@property (nonatomic) double grade;
@end

NS_ASSUME_NONNULL_END
