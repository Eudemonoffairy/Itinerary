//
//  QiniuUtils.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QiniuUtils : NSObject
+(NSString *)uploadImg:(UIImage *)image;
+ (void)uploadImages:(NSArray<UIImage *> *)images complete:(void(^)(NSArray<NSString *> *imageKeys))complete;
@end

NS_ASSUME_NONNULL_END
