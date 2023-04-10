//
//  NSString+LocalPath.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LocalPath)
-(NSString *) directoryByAppendingPathComponent:(NSString *)pathComponent;
+(NSString *) documentDirectoryWithComponent:(NSString *)pathComponent;
+(NSString *)storePath;
+(void)directoryCreate:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
