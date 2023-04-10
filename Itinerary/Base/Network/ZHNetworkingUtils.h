//
//  ZHNetworkingUtils.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, RequestMethod) {
    RequestMethodGET,
    RequestMethodPOST,
};

@interface ZHNetworkingUtils : NSObject

/**
 *  发送网络请求
 *
 *  @param urlStr      请求URL
 *  @param method      请求方法 GET 或 POST
 *  @param parameters  请求参数
 *  @param needToken   是否需要传递 Token
 *  @param success     请求成功回调
 *  @param failure     请求失败回调
 */
+ (void)requestWithURL:(NSString *)urlStr
                method:(RequestMethod)method
            parameters:(NSDictionary *)parameters
             needToken:(BOOL)needToken
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
