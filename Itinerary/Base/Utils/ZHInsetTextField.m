//
//  ZHInsetTextField.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//

#import "ZHInsetTextField.h"

@implementation ZHInsetTextField





// 控制文本的边距
- (CGRect)textRectForBounds:(CGRect)bounds {
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    return rect;
}
 
// 控制 placeHolder 的边距
- (CGRect)placeholderRectForBounds:(CGRect)bounds {
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    return rect;
}
 
// 控制编辑状态文本的边距
- (CGRect)editingRectForBounds:(CGRect)bounds {
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    CGRect rect = UIEdgeInsetsInsetRect(bounds, self.edgeInsets);
    return rect;
}



@end
