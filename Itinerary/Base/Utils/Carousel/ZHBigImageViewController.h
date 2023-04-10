//
//  ZHBigImageViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHBigImageViewController : UIViewController
@property (nonatomic, strong)UIImageView *image;

- (instancetype)initWithImage:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
