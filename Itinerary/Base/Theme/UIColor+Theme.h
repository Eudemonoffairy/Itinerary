//
//  UIColor+Theme.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Theme)

+(UIColor *)tabbarTintColor;
+(UIColor *)statisticBGColor;
+(UIColor *)statisticTextColor;
+(UIColor *)mineBGColor;
+(UIColor *)themeColor;

+(UIColor *)backButtonTextColor;

+(UIColor *)grayBackgroundColor;

///  品牌色
+(UIColor *)bandColor;
///  辅助色
+(UIColor *)secondaryColor;
///  一级标题文字颜色
+(UIColor *)H1Color;
///  文章标题文字颜色
+(UIColor *)titleColor;
///  正文颜色
+(UIColor *)textColor;
///  辅助文字颜色
+(UIColor *)auxiliaryTextColor;
///  说明文字颜色
+(UIColor *)instructionsColor;
///  分割线颜色
+(UIColor *)dividingLineColor;
///  背景颜色
+(UIColor *)backgroundColor;


@end

NS_ASSUME_NONNULL_END
