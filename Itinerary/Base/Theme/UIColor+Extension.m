//
//  UIColor+Extension.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)


/// 十六进制颜色
/// @param color 十六进制颜色
/// @param alpha 透明度
+(UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha{
    //  删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if([cString hasPrefix:@"#"]){
        cString =[cString substringFromIndex:1];
    }
    NSRange range;
    range.location = 0;
    range.length = 2;
    //  R
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    //  G
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    //  B
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:alpha];
}


/// 十六进制颜色, 不透明
/// @param color 十六进制颜色
+(UIColor *)colorWithHex:(NSString *)color{
    return [self colorWithHex:color alpha:1.0f];
}

@end
