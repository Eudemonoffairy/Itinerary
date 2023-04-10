//
//  ZHPlaceDataBase.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//

#import <Foundation/Foundation.h>
#import "ZHPlace.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHPlaceDataBase : NSObject
+(BOOL)insertData:(ZHPlace *)place;
+(NSMutableArray *)traverseAllData;
@end

NS_ASSUME_NONNULL_END
