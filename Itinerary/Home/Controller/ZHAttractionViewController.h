//
//  ZHAttractionViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//  首页 - 景点浏览 - 景点列表 - 景点 Cell - 景点详细页

#import <UIKit/UIKit.h>
#import "ZHAttraction.h"
#import "ZHCarouselX.h"
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHAttractionViewController : UIViewController
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, strong) ZHInsetLabel *address;
@property (nonatomic, strong) ZHInsetLabel *tel;
@property (nonatomic, strong) ZHInsetLabel *opentime;
@property (nonatomic, strong) ZHInsetLabel *cost;
@property (nonatomic, strong) ZHInsetLabel *rating;
@property (nonatomic, strong) ZHAttraction *attraction;
@property (nonatomic, strong) ZHCarouselX *carousel;


- (instancetype)initWithAttraction:(ZHAttraction *)attraction;
@end

NS_ASSUME_NONNULL_END
