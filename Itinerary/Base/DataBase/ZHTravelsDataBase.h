//
//  ZHTravelsDataBase.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//

#import <Foundation/Foundation.h>
#import "ZHTravels.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHTravelsDataBase : NSObject
+(BOOL)insertData:(ZHTravels *)travel;
+(NSMutableArray *)traverseAllData:(NSString *)telphon;
+(NSMutableArray *)traverseTenData;
+(NSInteger )tableCount;
+(void)deleteData:(NSInteger)travelId;
@end

NS_ASSUME_NONNULL_END
