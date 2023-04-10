//
//  UIButton+Utils.m
//  reader
//
//  Created by 陈聪山 on 2021/7/19.
//

#import "UIButton+Utils.h"

@implementation UIButton (Utils)

/// 将图片和标题纵向排列
/// @param title 标题
/// @param titleFont 标题字体
/// @param normalImage 图片(图标)
- (UIButton *)setVerticalWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImgage:(UIImage *)normalImage {
    self.titleLabel.font = titleFont;
    [[self setNormalTitle:title] setNormalImage:normalImage];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(22 ,-24, 0.0,0.0)];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 20, -size.width)];
    return self;
}


- (UIButton *)setVerticalWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImgage:(UIImage *)normalImage normalColor:(UIColor *)normalColor verticalSpacing:(CGFloat) spacing{
    self.titleLabel.font = titleFont;
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setImage:normalImage forState:UIControlStateNormal];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(spacing ,-36, 0.0,0.0)];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 20, -size.width)];
    return self;
}


-(UIButton *)setRightIconButtonWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImage:(UIImage *)normalImage{
    
    self.titleLabel.font = titleFont;
    [[self setNormalTitle:title] setNormalImage:normalImage];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -48, 0.0, 0.0)];
    CGSize size = [title sizeWithAttributes:@{
        NSFontAttributeName:self.titleLabel.font}];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, -size.width * 2 - 8)];
    return self;
}





/// 设置一般状态标题的颜色
/// @param color 标题颜色
- (UIButton *)setNormalTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    return self;
}


/// 为按钮设置标题(横向)
/// @param title 标题
- (UIButton *)setNormalTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
    return self;
}

/// 设置按钮被选中是的标题
/// @param selectedTitle 标题
- (UIButton *)setSelectedTitle:(NSString *)selectedTitle {
    [self setTitle:selectedTitle forState:UIControlStateSelected];
    return self;
}


/// 为按钮设置图片
/// @param image 图片
- (UIButton *)setNormalImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateNormal];
    return self;
}


/// 为按钮设置被选择时的图片
/// @param image 图片
- (UIButton *)setSelectedImage:(UIImage *)image {
    [self setImage:image forState:UIControlStateSelected];
    return self;
}

@end
