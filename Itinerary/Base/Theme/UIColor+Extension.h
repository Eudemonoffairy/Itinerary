//
//  UIColor+Extension.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)
+(UIColor *)colorWithHex:(NSString *)color alpha:(CGFloat)alpha;
+(UIColor *)colorWithHex:(NSString *)color;

@end

NS_ASSUME_NONNULL_END
