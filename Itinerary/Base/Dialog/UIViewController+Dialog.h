//
//  UIViewController+Dialog.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Dialog)
- (void)showInfo:(NSString *)info;
- (void)showInfo:(NSString *)info withTitle:(NSString *)title;
-(void)autoShowInfo:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
