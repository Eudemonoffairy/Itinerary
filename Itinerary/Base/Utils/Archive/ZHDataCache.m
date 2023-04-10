//
//  ZHDataCache.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//


//   self.cache:{ projectName:{key:cache}    }

#import "ZHDataCache.h"
#import "NSString+LocalPath.h"

static ZHDataCache *defaultDataCache = nil;

@interface ZHBlockOperation : NSBlockOperation

@property (nonatomic, copy) CacheProjectCallback callback;

@end

@implementation ZHBlockOperation

@end


@implementation ZHCacheItem

- (NSString *)projectName{
    if(!_projectName){
        _projectName = [@"default" copy];
    }
    return _projectName;
}

+ (instancetype)cacheItemWithObj:(NSObject *)obj key:(NSString *)key project:(NSString *)projectName expiredTime:(NSTimeInterval)time{
    ZHCacheItem *item = [[ZHCacheItem alloc]init];
    item.obj = obj;
    item.key = key;
    item.projectName = projectName;
    item.expiredTime = time;
    item.method =SERIALIZE_METHOD_ARCHIVED;
    item.orderBy = -1;
    return item;
}

- (BOOL)isEqual:(id)object{
    if(!object){
        return NO;
    }
    if(![object isKindOfClass:ZHCacheItem.class]){
        return NO;
    }
    ZHCacheItem *other = object;
    if(!other.obj) {
        return NO;
    }
    return [other.obj isEqual:self.obj];
}
//
//+ (NSUInteger)hash{
//    int prime = 31;
//    long result = 1;
//    result = prime * result + ((self.obj == nil)? 0 : self.obj.hash);
//    return result;
//}

// TODO 未完待续
@end

