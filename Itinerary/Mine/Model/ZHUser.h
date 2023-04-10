//
//  ZHUser.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHUser : NSObject
///  用户昵称（必填）
@property (nonatomic, strong) NSString *nickname;
///  用户头像地址
@property (nonatomic, strong) NSString *image;
///  用户电话号码
@property (nonatomic, strong) NSString *tel;
///  用户性别
@property (nonatomic, strong) NSString *gender;

@end

NS_ASSUME_NONNULL_END
