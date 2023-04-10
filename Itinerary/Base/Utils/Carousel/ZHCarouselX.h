//
//  ZHCarouselX.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCarouselX : UIView
//  图片源数组
@property (nonatomic, copy) NSArray *imageArray;
//  当前页颜色
@property (nonatomic, strong) UIColor *currentPageColor;
//  未选中页面颜色
@property (nonatomic, strong) UIColor *defaultPageColor;

- (instancetype)initWithFrame:(CGRect)frame autoScroll:(BOOL)autoScroll;

@end

NS_ASSUME_NONNULL_END
