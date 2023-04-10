//
//  NSObject+Properties.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/10.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>
@implementation NSObject (Properties)

- (NSDictionary *)properties_aps{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    //  获取当前类的所有属性
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    //  遍历所有的属性
    for(i = 0; i < outCount; i++){
        objc_property_t property = properties[i];
        //  获得属性名
        const char* char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //  获得属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        //  若属性值为有效值，则添加到字典里
        if(propertyValue){
            [props setObject:propertyValue forKey:propertyName];
        }
    }
    free(properties);
    return props;
}


/// 返回所有的属性名
-(NSArray *)getAllProperties{
    u_int count;
    //  获得所有的属性
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    //  创建容量为 count 的列表
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for(int i =0; i < count; i++){
        const char* propertyName = property_getName(properties[i]);
        [propertiesArray addObject:[NSString stringWithUTF8String:propertyName]];
    }
    free(properties);
    return propertiesArray;
}

- (NSString *)getIvarType:(NSString *)keyPath{
    unsigned int outCount;
    Ivar* ivars = class_copyIvarList([self class], &outCount);
    NSString *result = nil;
    for(int i = 0; i < outCount; i++ ){
        Ivar ivar = ivars[i];
        const char* ivarType = ivar_getTypeEncoding(ivar);
        const char* ivarName = ivar_getName(ivar);
        if([[NSString stringWithFormat:@"%s", ivarName] containsString:keyPath]){
            result = [[NSString stringWithFormat:@"%s", ivarType] stringByReplacingOccurrencesOfString:@"@" withString:@""];
            result = [result stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            break;
        }
    }
    return result;
}


@end
