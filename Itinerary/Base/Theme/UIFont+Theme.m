//
//  UIFont+Theme.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import "UIFont+Theme.h"

@implementation UIFont (Theme)

+ (UIFont *)fontSize_10{
    return [UIFont systemFontOfSize:10.0];
}
+ (UIFont *)fontSize_12{
    return [UIFont systemFontOfSize:12.0];
}
+ (UIFont *)fontSize_14{
    return [UIFont systemFontOfSize:14.0];
}
+ (UIFont *)fontSize_17{
    return [UIFont systemFontOfSize:17.0];
}
+ (UIFont *)fontSize_20{
    return [UIFont systemFontOfSize:20.0];
}
+ (UIFont *)fontSize_22{
    return [UIFont systemFontOfSize:22.0];
}

+ (UIFont *) boldFontSize_12{
    return [UIFont boldSystemFontOfSize:12];
}

+ (UIFont *) boldFontSize_14{
    return [UIFont boldSystemFontOfSize:14];
}

+ (UIFont *) boldFontSize_17{
    return [UIFont boldSystemFontOfSize:17];
}

+ (UIFont *) boldFontSize_20{
    return [UIFont boldSystemFontOfSize:20];
}

+ (UIFont *) boldFontSize_22{
    return [UIFont boldSystemFontOfSize:22];
}

+(UIFont *) fontSize_h1{
    return [UIFont boldSystemFontOfSize:32];
}

+(UIFont *) fontSize_h2{
    return [UIFont boldSystemFontOfSize:24];
}
+(UIFont *) fontSize_h3{
    return [UIFont systemFontOfSize:18.72];
}
+(UIFont *) fontSize_h4{
    return [UIFont boldSystemFontOfSize:16];
}
+(UIFont *) fontSize_h5{
    return [UIFont boldSystemFontOfSize:13.28];
}
+(UIFont *) fontSize_h6{
    return [UIFont boldSystemFontOfSize:10.72];
}
@end
