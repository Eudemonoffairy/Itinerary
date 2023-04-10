//
//  ZHComment.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/5.
//

#import "ZHComment.h"
#import "ZHNetworkingUtils.h"
@implementation ZHComment

- (instancetype)initWithUserID:(NSInteger)userID{
    self = [super init];
    self.userId = userID;
    NSDictionary *dic = @{
        @"id": [NSNumber numberWithLong:userID]
    };
    
    [ZHNetworkingUtils requestWithURL:@"/user/getuserinfobyid"
                               method:RequestMethodGET
                           parameters:dic
                            needToken:NO
                              success:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
    }
                              failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    return self;
}


@end
