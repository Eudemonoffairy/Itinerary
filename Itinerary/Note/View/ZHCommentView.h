//
//  ZHCommentView.h
//  Itinerary
//  评论
//  Created by Martin Liu on 2023/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCommentView : UITableViewCell
@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *commentText;
@property (nonatomic, strong) UILabel *commentTime;
@property (nonatomic) CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
