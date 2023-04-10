//
//  KRScreenAdapter.h
//  SunshineHealthy
//
//  Created by kairu on 2017/3/2.
//  Copyright © 2017年 kaiRuTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/**
 *  界面适配调用的宏
 */
/// 宽度适配
#define FITWITH(width)  [[KRScreenAdapter screenAdapter] fitWithWidth:width]
/// 高度适配
#define FITHEIGHT(height) [[KRScreenAdapter screenAdapter] fitWithHeight:height]
/// 字体大小适配
#define FITFONTSIZE(a) [[KRScreenAdapter screenAdapter] fitWithFontSize:a]
/// 自动缩放适配
#define FITSCALE(a)     [[KRScreenAdapter screenAdapter] fitScale:a]

/**
 *  一些宏定义值
 */
#define WIDTH_SCALE 375.0/320.0

#define NAVIGATION_BAR_HEIGHT (self.navigationController.navigationBar.frame.size.height + STATUS_BAR_HEIGHT)
#define ICStatusNav_Height (IS_IPHONE_X_U ? 88 : 64)

#define STATUS_BAR_HEIGHT [(AppDelegate *)[UIApplication sharedApplication].delegate statusBarHeight]

#define ipad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPAD ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
#define IS_IPHONE ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
 
/**
 各个机型像素:
 4/4S          320 * 480  @2x
 5/5S/5C       320 * 568  @2x
 6/6S/7/8      375 * 667  @2x
 6+/6S+/7+/8+  414 * 736 @3x
 X             375 * 812 @3x
 
 */
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5  (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6  (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X  (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)
#define IS_IPHONE_X_U  (IS_IPHONE && SCREEN_MAX_LENGTH >= 812.0)

//底部安全区域高度
#define  TabbarSafeBottomMargin         (IS_IPHONE_X_U ? 34.f : 0.f)

#define  TABBAR_HEIGHT         (IS_IPHONE_X_U ? (49.f+34.f) : 49.f)

#define ReadHeight [[ICReaderConfig defaultConfig] readHeight]

@interface KRScreenAdapter : NSObject
//适配UI
@property (nonatomic, assign) CGFloat fontSize;     //字体大小
@property (nonatomic, assign) CGFloat height;       //高度
@property (nonatomic, assign) CGFloat width;        //宽

@property (nonatomic, assign) CGFloat scale_width;   //宽度缩放
@property (nonatomic, assign) CGFloat scale_height; //高度缩放

@property (nonatomic, assign) CGFloat scale;        //缩放

+ (KRScreenAdapter *)screenAdapter;

//字体大小适配
- (CGFloat)fitWithFontSize:(CGFloat )size;
//纵向适配(高度,Y值)
- (CGFloat)fitWithHeight:(CGFloat )height;
//横向适配(宽度,X值)
- (CGFloat)fitWithWidth:(CGFloat )width;

- (CGFloat)fitScale:(CGFloat)a;

@end
