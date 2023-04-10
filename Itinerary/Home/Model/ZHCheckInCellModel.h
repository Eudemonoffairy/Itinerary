//
//  ZHCheckInCellModel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCheckInCellModel : NSObject

@property (nonatomic) NSString *cityName;
@property (nonatomic) NSInteger unfinish;
@property (nonatomic) NSInteger finished;
@property (nonatomic) NSInteger cityID;

@end

NS_ASSUME_NONNULL_END
