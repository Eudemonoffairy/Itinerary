//
//  ZHTitleNContentLabel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHTitleNContentLabel : UIView
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelContent;
@property (nonatomic) BOOL isVertical;

- (instancetype)initWithTitle:(NSString *)labelTitle Content:(NSString *)labelContent isVertical:(BOOL)isVertical;

///  初始化方法，默认为横向显示
- (instancetype)initWithTitle:(NSString *)labelTitle Content:(NSString *)labelContent;
@end

NS_ASSUME_NONNULL_END
