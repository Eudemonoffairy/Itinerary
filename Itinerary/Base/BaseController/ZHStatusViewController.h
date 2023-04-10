//
//  ZHStatusViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    SEARCHING_STATSUS,
} VIEW_STATUS;


@interface ZHStatusViewController : UIViewController
- (void)showStatus:(VIEW_STATUS)status info:(NSString *)info;
- (void)hideStatuView;
@end

NS_ASSUME_NONNULL_END
