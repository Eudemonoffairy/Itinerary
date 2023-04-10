//
//  ZHCarousel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ZHCarousel;
@protocol ZHCarouselDelegate <NSObject>

@optional
-(void)carouselView:(ZHCarousel *)carouselView indexOfClickedImageButton:(NSUInteger)index;
-(void)carouselView:(ZHCarousel *)carouselView toBigimg:(UIImage *)image;
@end

@interface ZHCarousel : UIView

@property (nonatomic, copy) NSArray *imageArr;
@property (nonatomic, strong) UIColor *currentPageColor;
@property (nonatomic, strong) UIColor *pageColor;

@property (nonatomic, weak)id<ZHCarouselDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
