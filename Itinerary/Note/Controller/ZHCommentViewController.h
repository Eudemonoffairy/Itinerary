//
//  ZHCommentViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCommentViewController : UITableViewController
//  评论区对应的 id
@property (nonatomic) NSString *noteId;

//  可否滑动
@property (nonatomic, assign)BOOL canSlide;
///滑动block通知
@property (nonatomic,copy) void (^slideDragBlock)(void);
///  评论组
@property (nonatomic, copy) NSMutableArray *commentArr;
@end

NS_ASSUME_NONNULL_END
