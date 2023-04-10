//
//  KRScreenAdapter.m
//  SunshineHealthy
//
//  Created by kairu on 2017/3/2.
//  Copyright © 2017年 kaiRuTech. All rights reserved.
//

#import "KRScreenAdapter.h"

#define DWIDTH  375             //设计时使用宽度
#define DHEIGHT 667             //设计时使用高度

static KRScreenAdapter *_screenAdapter = nil;

@implementation KRScreenAdapter

+ (KRScreenAdapter *)screenAdapter {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _screenAdapter = [[self alloc] init];
    });
    
    return _screenAdapter;
}
- (instancetype)init {
    self =  [super init];
    if (self) {
        self.fontSize = [UIFont systemFontSize];
        self.width = 375.f;
        self.height = 667.f;
    }
    return self;
}

- (CGFloat)scale_width
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if (IS_IPHONE_4_OR_LESS) {
        width = 320;
    }else if (IS_IPHONE_5){
        width = 320;
    }else if (IS_IPHONE_6){
        width = 375;
    }else if (IS_IPHONE_6P){
        width = 414;
    }else if (IS_IPHONE_X)
    {
        width = 375;
    }else if (IS_IPAD)
    {
        width = 768;
    }
    
    CGFloat scale = width / DWIDTH;
    
    return scale;
    
}

- (CGFloat)scale_height {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    if (IS_IPHONE_4_OR_LESS) {
        height = 480;
    }else if (IS_IPHONE_5){
        height = 568;
    }else if (IS_IPHONE_6){
        height = 667;
    }else if (IS_IPHONE_6P){
        height = 736;
    }else if (IS_IPHONE_X)
    {
        height = 812 - 34 - 44;
    }
    else  if (IS_IPAD)
    {
        height = 1024;
    }
    
    CGFloat scale = height / DHEIGHT;
    
    return scale;
}

- (CGFloat)scale {
    
    return self.scale_width < self.scale_height ? self.scale_width : self.scale_height;
}

//字体大小适配
- (CGFloat)fitWithFontSize:(CGFloat)size
{
    if (IS_IPAD) {
        return size * 1.25;
    }else if(IS_IPHONE_4_OR_LESS)
    {
        return size;
    }else if(IS_IPHONE_6P)
    {
        return size;
    }else if(IS_IPHONE_X)
    {
        return size;
    }else
    {
        return size;
    }
}
//高度适配
- (CGFloat)fitWithHeight:(CGFloat )height
{
    return height * self.scale_height;
    return height;
}
//宽度适配
- (CGFloat)fitWithWidth:(CGFloat )width
{
    return width * self.scale_width;
    return width;
}

- (CGFloat)fitScale:(CGFloat)a
{
    return self.scale * a;
}

@end
