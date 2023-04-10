//
//  ZHStatisticBar.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHStatisticBar : UIView
@property (nonatomic) NSDictionary *dataDic;
- (instancetype)initWithDataDic:(NSDictionary *)dataDic;
- (instancetype)initWithTitle:(NSString *)itemTitle itemContent:(NSString *)itemContent;
@end

NS_ASSUME_NONNULL_END
