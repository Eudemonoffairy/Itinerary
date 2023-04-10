//
//  ZHScrollView.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/15.
//  实现 UIGestureRecognizerDelegate 的 ScrollView

#import "ZHScrollView.h"

@implementation ZHScrollView

// 支持多手势触发
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
