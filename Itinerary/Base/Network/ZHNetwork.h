//
//  ZHNetwork.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHNetwork : NSObject
///  无参同步POST(带 token)
+(NSDictionary *)POSTWithToken_Sync:(NSString *)apiUrl;


///  有参数同步POST(带 token)
+(NSDictionary *)POSTWithToken_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params;

///  无参异步 POST(带 token)
+(NSDictionary *)POSTWithToken_Async:(NSString *)apiUrl;


///  有参异步 POST(带 token)
+(NSDictionary *)POSTWithToken_Async:(NSString *)apiUrl parameters:(NSDictionary *)params;


//  无参同步POST（无token）
+(NSDictionary *)POST_Sync:(NSString *)apiUrl;


//  有参数同步POST（无token）
+(NSDictionary *)POST_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params;

///  无参异步 POST（无token）
+(NSDictionary *)POST_Async:(NSString *)apiUrl;


///  有参异步 POST（无token）
+(NSDictionary *)POST_Async:(NSString *)apiUrl parameters:(NSDictionary *)params;

//  无参同步POST(带 token)
+(NSDictionary *)GETWithToken_Sync:(NSString *)apiUrl;

//  有参数同步POST(带 token)
+(NSDictionary *)GETWithToken_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params;

///  无参异步 GET(带 token)
+(NSDictionary *)GETWithToken_Async:(NSString *)apiUrl;


///  有参异步 GET(带 token)
+(NSDictionary *)GETWithToken_Async:(NSString *)apiUrl parameters:(NSDictionary *)params;


//  无参同步GET
+(NSDictionary *)GET_Sync:(NSString *)apiUrl;


//  有参数同步GET
+(NSDictionary *)GET_Sync:(NSString *)apiUrl parameters:(NSDictionary *)params;

///  无参异步 POST
+(NSDictionary *)GET_Async:(NSString *)apiUrl;


///  有参异步 POST
+(NSDictionary *)GET_Async:(NSString *)apiUrl parameters:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
