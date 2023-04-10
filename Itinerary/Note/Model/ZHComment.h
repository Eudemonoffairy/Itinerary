//
//  ZHComment.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHComment : NSObject
///  评论者的 ID
@property (nonatomic)NSInteger userId;
///  评论内容
@property (nonatomic, strong)NSString *commentContent;
///  评论日期
@property (nonatomic, strong)NSString *commentDate;
///  用户昵称
@property (nonatomic, strong)NSString *userNickName;
///  用户头像 URL
@property (nonatomic, strong)NSString *imageUrl;

@end

NS_ASSUME_NONNULL_END
