//
//  ZHInsetTextField.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHInsetTextField : UITextField
@property (nonatomic, assign) IBInspectable CGFloat leftEdge;
@property (nonatomic, assign) IBInspectable CGFloat rightEdge;
@property (nonatomic, assign) IBInspectable CGFloat topEdge;
@property (nonatomic, assign) IBInspectable CGFloat bottomEdge;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@end

NS_ASSUME_NONNULL_END
