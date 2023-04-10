//
//  ZHUserDataBase.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/20.
//

#import <Foundation/Foundation.h>
#import "ZHUser.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHUserDataBase : NSObject

+(BOOL)insertData:(ZHUser *)user password:(NSString *)password;
+(BOOL)dataExist:(NSString *)telphone;
+(ZHUser *)queryData:(NSString *)telphone;
+(BOOL)checkLogin:(NSString *)telphone password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
