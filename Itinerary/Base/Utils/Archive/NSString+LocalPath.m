//
//  NSString+LocalPath.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import "NSString+LocalPath.h"

@implementation NSString (LocalPath)

- (NSString *)directoryByAppendingPathComponent:(NSString *)pathComponent{
    NSString *path = [self stringByAppendingPathComponent:pathComponent];
    [NSString directoryCreate:path];
    return path;
}

+ (NSString *)documentDirectoryWithComponent:(NSString *)pathComponent{
    NSString *storePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    storePath = [NSString stringWithFormat:@"%@/%@", storePath, pathComponent];
    return storePath;
}

+ (NSString *)storePath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

+ (void)directoryCreate:(NSString *)path{
    BOOL isDic = YES;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDic]){
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if(error){
            NSLog(@"create direct with error:%@", error);
        }
    }
}
@end
