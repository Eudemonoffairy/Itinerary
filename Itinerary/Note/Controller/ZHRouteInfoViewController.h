//
//  ZHRouteInfoViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/18.
//

#import <UIKit/UIKit.h>
#import "ZHPlace.h"
#import "ZHPositionButtonBar.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHRouteInfoViewController : UIViewController
@property (nonatomic, strong)NSArray<ZHPlace *> *placeArr;
@property (nonatomic, strong) ZHPositionButtonBar *positionBar;
@end

NS_ASSUME_NONNULL_END
