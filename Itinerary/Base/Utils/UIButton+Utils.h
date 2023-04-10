//
//  UIButton+Utils.h
//  reader
//
//  Created by 陈聪山 on 2021/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Utils)

- (UIButton *)setVerticalWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImgage:(UIImage *)normalImage;
- (UIButton *)setVerticalWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImgage:(UIImage *)normalImage normalColor:(UIColor *)normalColor verticalSpacing:(CGFloat) spacing;
-(UIButton *)setRightIconButtonWithNormalTitle:(NSString *)title font:(UIFont *)titleFont normalImage:(UIImage *)normalImage;
- (UIButton *)setNormalTitleColor:(UIColor *)color;
- (UIButton *)setNormalTitle:(NSString *)title;
- (UIButton *)setSelectedTitle:(NSString *)selectedTitle;
- (UIButton *)setNormalImage:(UIImage *)image;
- (UIButton *)setSelectedImage:(UIImage *)image;


@end

NS_ASSUME_NONNULL_END
