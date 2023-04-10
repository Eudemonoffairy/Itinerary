//
//  KeyedArchiverModel.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import "KeyedArchiverModel.h"
#import "NSObject+Properties.h"
@implementation KeyedArchiverModel

///  通过编码实例化对象
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]){
        NSArray *array = [self getAllProperties];
        for (NSString *pro in array){
            NSString *varType = [self getIvarType:pro];
            NSObject *obj = nil;
            if([varType isEqualToString:NSStringFromClass(NSObject.class)]){
                obj = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[KeyedArchiverModel class], [NSString class], [NSDictionary class], [NSArray class], nil] forKey:pro];
            }
            else{
                obj = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[KeyedArchiverModel class], NSClassFromString(varType),  nil] forKey:pro];
            }
            if(obj){
                [self setValue:obj forKey:pro];
            }
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSDictionary *all = [self properties_aps];
    NSArray *array = [self exceptKeys];
    for(NSString *key in all.keyEnumerator){
        if([array containsObject:key]){
            continue;
        }
        [aCoder encodeObject:all[key] forKey:key];
    }
}

- (NSArray *)exceptKeys{
    return @[];
}

+(BOOL)supportsSecureCoding{
    return YES;
}
@end
