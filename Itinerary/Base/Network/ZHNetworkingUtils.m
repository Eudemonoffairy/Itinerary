//
//  ZHNetworkingUtils.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/5.
//

#import "ZHNetworkingUtils.h"

@implementation ZHNetworkingUtils
+ (void)requestWithURL:(NSString *)urlStr
                method:(RequestMethod)method
            parameters:(NSDictionary *)parameters
             needToken:(BOOL)needToken
               success:(void (^)(id responseObject))success
               failure:(void (^)(NSError *error))failure {
    // 创建请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置请求格式
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // 如果需要传递 Token，则设置请求头
    if (needToken) {
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:LOGIN_FLAG];
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    // 发送网络请求
    switch (method) {
        case RequestMethodGET: {
            [manager GET:[BASE_URL stringByAppendingString:urlStr] parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
        }
        case RequestMethodPOST: {
            [manager POST:[BASE_URL stringByAppendingString:urlStr] parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
            break;
        }
    }
}
@end
