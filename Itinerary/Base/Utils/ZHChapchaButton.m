//
//  ZHChapchaButton.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//  发送验证码按钮

#import "ZHChapchaButton.h"

@implementation ZHChapchaButton
{
    NSTimer *_timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
        self.timeCount = 60;
    }
    return self;
}

- (void)clicked:(UIButton *)sender {
    if (self.clickedBlock) {
        self.clickedBlock();
     
    }
    [self startTiming];
}

- (void)startTiming {
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    self.enabled = NO;
}

- (void)timing {
    self.timeCount -= 1;
    [self setTitle:[NSString stringWithFormat:@"%lds后重新获取", (long)self.timeCount] forState:UIControlStateDisabled];
    if (self.timingBlock) {
        self.timingBlock(self.timeCount);
    }
    if (self.timeCount <= 0) {
        [self stopTiming];
    }
}

- (void)stopTiming {
    [_timer invalidate];
    _timer = nil;
    self.enabled = YES;
    self.timeCount = 60;
    [self setTitle:@"获取验证码" forState:UIControlStateNormal];
}

@end
