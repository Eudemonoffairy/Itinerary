//
//  ZHMapViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/16.
//

#import <UIKit/UIKit.h>
#import "ZHPlace.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHMapViewController : UIViewController
@property (nonatomic, copy) NSMutableArray<ZHPlace *> *placeArr;
@end

NS_ASSUME_NONNULL_END
