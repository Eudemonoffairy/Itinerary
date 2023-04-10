//
//  QiniuUtils.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/11.
//

#include <CommonCrypto/CommonCrypto.h>
#import "QiniuUtils.h"
#import <QiniuSDK.h>
#import <QNConfiguration.h>
#import <QN_GTM_Base64.h>
#import <AFNetworking.h>

@implementation QiniuUtils

+(NSString *)uploadImg:(UIImage *)image{
    __block BOOL isOK;                  //  是否上传成功的标识
    __block NSString * token;           //  七牛云的 token
    
    
    //  自动配置上传空间
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useHttps = YES;
    }];
    
    //  从后端获取 token
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    NSString *url = [BASE_URL stringByAppendingString:@"/note/getuploadtoken"];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        token = responseObject[@"data"];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
    NSString *key =  [self qnImageFilePatName];
    NSData *data;
    
    if(UIImagePNGRepresentation(image) == nil){
        data = UIImageJPEGRepresentation(image, 1);
    }else{
        data = UIImagePNGRepresentation(image);
    }
    
    QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
    [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if(info.ok)
                   {
                       NSLog(@"请求成功");
                       isOK = YES;
                   }
                   else{
                       NSLog(@"失败");
                       isOK = NO;
                       //如果失败，这里可以把info信息上报自己的服务器，便于后面分析上传错误原因
                   }
                   NSLog(@"info ===== %@", info);
                   NSLog(@"resp ===== %@", resp);
    } option:nil];
    
    if(isOK){
        return key;
    }else{
        return nil;
    }
}


+ (void)uploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *imageKeys))complete {
    __block NSMutableArray<NSString *> *imageKeys = [NSMutableArray array]; // 存储上传图片的key
    __block NSUInteger completedCount = 0; // 已经上传成功的图片数量
    
    //  自动配置上传空间
    QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
        builder.useHttps = YES;
    }];
    
    //  从后端获取 token
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    NSString *url = [BASE_URL stringByAppendingString:@"/note/getuploadtoken"];
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        NSString *token = responseObject[@"data"];
        
        // 上传所有图片
        for (UIImage *image in images) {
            NSString *key = [self qnImageFilePatName];
            NSData *data;
            
            if (UIImagePNGRepresentation(image) == nil) {
                data = UIImageJPEGRepresentation(image, 1);
            } else {
                data = UIImagePNGRepresentation(image);
            }
            
            QNUploadManager *upManager = [[QNUploadManager alloc] initWithConfiguration:config];
            [upManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                if (info.ok) {
                    NSLog(@"上传图片成功");
                    [imageKeys addObject:key];
                } else {
                    NSLog(@"上传图片失败");
                }
                completedCount++;
                
                if (completedCount == images.count) {
                    // 所有图片上传完成
                    if (complete) {
                        complete(imageKeys);
                    }
                }
            } option:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
    }];
}

//  文件命名
+ (NSString *)qnImageFilePatName{
   NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"yyyyMMdd"];
   NSString *nowe = [formatter stringFromDate:[NSDate date]];
    char datax[12];//十六位防重字符
   for (int x=0;x<12;datax[x++] = (char)('A' + (arc4random_uniform(26))));
   NSString *number = [[NSString alloc] initWithBytes:datax length:12 encoding:NSUTF8StringEncoding];
   //当前时间
   NSInteger interval = (NSInteger)[[NSDate date]timeIntervalSince1970];
   NSString *name = [NSString stringWithFormat:@"Picture/%@/%ld%@.jpg",nowe,interval,number];
   NSLog(@"name__%@",name);
   return name;
    
}
@end
