//
//  ZHCheckinSetModel.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCheckinSetModel : NSObject
@property (nonatomic) NSInteger checkinID;
@property (nonatomic, strong) NSString *checkinName;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) CGFloat latitude;
@property (nonatomic, strong) NSString *cellImageUrl;
@end

NS_ASSUME_NONNULL_END
