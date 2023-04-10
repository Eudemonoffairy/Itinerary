//
//  ZHDataCache.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import "KeyedArchiverModel.h"
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef enum:NSUInteger{
    SERIALIZE_METHOD_NO_SERIALIZE = 0,
    SERIALIZE_METHOD_ARCHIVED,
    SERIALIZE_METHOD_USERINFO
} SERIALIZE_METHOD;


@interface ZHCacheItem : KeyedArchiverModel

@property (nonatomic, copy)NSString *key;
@property (nonatomic, strong) NSObject *obj;
@property (nonatomic, copy) NSString *projectName;
@property (nonatomic) NSTimeInterval expiredTime;
@property (nonatomic) NSInteger orderBy;
@property (nonatomic) SERIALIZE_METHOD method;

+(instancetype)cacheItemWithObj:(NSObject *)obj key:(NSString *)key project:(NSString *)projectName expiredTime:(NSTimeInterval)time;

@end

typedef  void(^CacheProjectCallback) (NSArray <ZHCacheItem *> *obj);

@interface ZHDataCache : NSObject

+(instancetype)defaultCache;
-(BOOL)addCache:(ZHCacheItem *)cache;
-(void)batchUpdateCache:(NSArray <ZHCacheItem *> *)caches;
-(NSArray <ZHCacheItem *> *)queryCacheForProjectName:(NSString *)projectName;

-(ZHCacheItem *)queryCacheForProjectName:(NSString * _Nullable)projectName key:(NSString *)aKey;

-(void)queryItemsByProject:(NSString *)projectName callback:(CacheProjectCallback)callback;
-(BOOL)removeCacheForProjectName:(NSString * _Nullable)projectName key:(NSString *)aKey;
-(BOOL)removeCacheForProjectName:(NSString * _Nullable)projectName;

-(BOOL)existWithProjectName:(NSString * _Nullable)projectName key:(NSString *)aKey;

@end

NS_ASSUME_NONNULL_END
