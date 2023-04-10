//
//  UIFont+Theme.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (Theme)

+ (UIFont *)fontSize_10;
+ (UIFont *)fontSize_12;
+ (UIFont *)fontSize_14;
+ (UIFont *)fontSize_17;
+ (UIFont *)fontSize_20;
+ (UIFont *)fontSize_22;

+ (UIFont *) boldFontSize_12;
+ (UIFont *) boldFontSize_14;
+ (UIFont *) boldFontSize_17;
+ (UIFont *) boldFontSize_20;
+ (UIFont *) boldFontSize_22;

+(UIFont *) fontSize_h1;
+(UIFont *) fontSize_h2;
+(UIFont *) fontSize_h3;
+(UIFont *) fontSize_h4;
+(UIFont *) fontSize_h5;
+(UIFont *) fontSize_h6;
@end

NS_ASSUME_NONNULL_END
