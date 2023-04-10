//
//  ZHLocationUtils.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
NS_ASSUME_NONNULL_BEGIN

@interface ZHLocationUtils : NSObject
-(void)startLocation;

+(instancetype) sharedInstance;
@end

NS_ASSUME_NONNULL_END
