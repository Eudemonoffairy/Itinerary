//
//  ZHCloseIconLabel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/8.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN
@class ZHCloseIconLabel;
@protocol ZHCloseIconLabelDelegate <NSObject>
@optional
-(void) closeAction:(ZHCloseIconLabel *)label;

@end


@interface ZHCloseIconLabel : UIView
@property (nonatomic, strong) ZHInsetLabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<ZHCloseIconLabelDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
