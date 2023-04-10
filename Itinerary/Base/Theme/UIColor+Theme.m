//
//  UIColor+Theme.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import "UIColor+Theme.h"
#import "UIColor+Extension.h"

@implementation UIColor (Theme)







+(UIColor *)tabbarTintColor{
    return [UIColor colorWithHex:@"#4C956C"];
}

+(UIColor *)statisticBGColor{
    return [UIColor colorWithHex:@"#50C1B9"];
}
+(UIColor *)statisticTextColor{
    return [UIColor colorWithHex:@"#F9E64F"];
}

+(UIColor *)mineBGColor{
    return [UIColor colorWithHex:@"#41F28D"];
}

+(UIColor *)themeColor{
    return [UIColor colorWithHex:@"#41F28D"];
}

+(UIColor *)backButtonTextColor{
    return [UIColor colorWithHex:@"#4A4A4A"];
}

+(UIColor *)grayBackgroundColor{
    return [UIColor colorWithHex:@"#F8F8F8"];
}

//  MARK: - 品牌色与辅助色
+(UIColor *)bandColor{
    return [UIColor colorWithHex:@"#1BF1D3"];
}

+(UIColor *)secondaryColor{
    return [UIColor colorWithHex:@"#FFD927"];
}

//  MARK: - 文字用色
+(UIColor *)H1Color{
    return [UIColor colorWithHex:@"#303434"];
}

+(UIColor *)titleColor{
    return [UIColor colorWithHex:@"#303434" alpha:0.8];
}

+(UIColor *)textColor{
    return [UIColor colorWithHex:@"#303434" alpha:0.67];
}
+(UIColor *)auxiliaryTextColor{
    return [UIColor colorWithHex:@"#303434" alpha:0.48];
}

+(UIColor *)instructionsColor{
    return [UIColor colorWithHex:@"#303434" alpha:0.36];
}

+(UIColor *)dividingLineColor{
    return [UIColor colorWithHex:@"#303434" alpha:0.04];
}

+(UIColor *)backgroundColor{
    return [UIColor colorWithHex:@"#FAFCFC"];
}



@end
