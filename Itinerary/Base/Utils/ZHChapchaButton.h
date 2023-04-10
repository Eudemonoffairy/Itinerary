//
//  ZHChapchaButton.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHChapchaButton : UIButton
@property (nonatomic, assign) NSInteger timeCount; // 倒计时时间，默认为60秒
@property (nonatomic, copy) void(^clickedBlock)(void); // 点击按钮回调
@property (nonatomic, copy) void(^timingBlock)(NSInteger timeCount); // 倒计时回调
- (void)startTiming; // 开始倒计时
@end

NS_ASSUME_NONNULL_END
