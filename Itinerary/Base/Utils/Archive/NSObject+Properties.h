//
//  NSObject+Properties.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Properties)
-(NSDictionary *)properties_aps;
-(NSArray *)getAllProperties;
-(NSString *)getIvarType:(NSString *)keyPath;
@end

NS_ASSUME_NONNULL_END
