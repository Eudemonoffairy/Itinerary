//
//  ZHNetwork.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/11.
//

#import "ZHNetwork.h"

@implementation ZHNetwork

//  无参同步POST(带 token)
+(NSDictionary *)POSTWithToken_Sync:(NSString *)apiUrl{
    return [self POSTWithToken_Sync:apiUrl parameters:nil];
}

//  有参数同步POST(带 token)
+(NSDictionary *)POSTWithToken_Sync:( NSString *)apiUrl parameters: ( NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

///  无参异步 POST(带 token)
+(NSDictionary *)POSTWithToken_Async:(NSString *)apiUrl{
    return [self POSTWithToken_Async:apiUrl parameters:nil];
}


///  有参异步 POST(带 token)
+(NSDictionary *)POSTWithToken_Async:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
    }];
    return resultDic;
}


//  无参同步POST
+(NSDictionary *)POST_Sync:(NSString *)apiUrl{
    return [self POST_Sync:apiUrl parameters:nil];
}


//  有参数同步POST
+(NSDictionary *)POST_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

///  无参异步 POST
+(NSDictionary *)POST_Async:(NSString *)apiUrl{
    return [self POST_Async:apiUrl parameters:nil];
}


///  有参异步 POST
+(NSDictionary *)POST_Async:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    [manager POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
    }];
    return resultDic;
}


//  无参同步POST(带 token)
+(NSDictionary *)GETWithToken_Sync:(NSString *)apiUrl{
    return [self GETWithToken_Sync:apiUrl parameters:nil];
}


//  有参数同步POST(带 token)
+(NSDictionary *)GETWithToken_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

///  无参异步 POST(带 token)
+(NSDictionary *)GETWithToken_Async:(NSString *)apiUrl{
    return [self GETWithToken_Async:apiUrl parameters:nil];
}


///  有参异步 POST(带 token)
+(NSDictionary *)GETWithToken_Async:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
    }];
    return resultDic;
}


//  无参同步POST
+(NSDictionary *)GET_Sync:(NSString *)apiUrl{
    return [self GET_Sync:apiUrl parameters:nil];
}


//  有参数同步POST
+(NSDictionary *)GET_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return resultDic;
}

///  无参异步 POST
+(NSDictionary *)GET_Async:(NSString *)apiUrl{
    return [self GET_Async:apiUrl parameters:nil];
}


///  有参异步 POST
+(NSDictionary *)GET_Async:(NSString *)apiUrl parameters:(NSDictionary *)params{
    __block NSDictionary *resultDic = [NSDictionary dictionary];
    
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *url = [BASE_URL stringByAppendingString:apiUrl];
    [manager GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        resultDic = [responseObject copy];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
    }];
    return resultDic;
}

@end
