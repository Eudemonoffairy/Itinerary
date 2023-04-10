//
//  ZHInsetLabel.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/9.
//

#import "ZHInsetLabel.h"

@implementation ZHInsetLabel

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect{
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    [super drawTextInRect: UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

- (CGSize)intrinsicContentSize{
    self.edgeInsets = UIEdgeInsetsMake(self.topEdge, self.leftEdge, self.bottomEdge, self.rightEdge);
    CGSize size = [super intrinsicContentSize];
    size.width += self.edgeInsets.left + self.edgeInsets.right;
    size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return size;
}

@end
