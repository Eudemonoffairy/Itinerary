//
//  ZHInsetLabel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHInsetLabel : UILabel

@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;
@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

NS_ASSUME_NONNULL_END
