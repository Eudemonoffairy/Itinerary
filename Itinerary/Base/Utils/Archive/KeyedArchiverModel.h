//
//  KeyedArchiverModel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyedArchiverModel : NSObject<NSSecureCoding>

-(NSArray *)exceptKeys;

@end

NS_ASSUME_NONNULL_END
