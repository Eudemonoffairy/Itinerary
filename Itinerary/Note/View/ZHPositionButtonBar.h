//
//  ZHPositionButtonBar.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//

#import <UIKit/UIKit.h>
#import "ZHPlace.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHPositionButtonBar : UIScrollView
@property(nonatomic, strong) NSArray<ZHPlace *> *positionArr;
//  出行方式  0：驾车      1：公交/出行
@property (nonatomic, assign) NSInteger mode;
@end

NS_ASSUME_NONNULL_END
