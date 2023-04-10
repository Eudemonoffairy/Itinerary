//
//  ZHHomeModuleView.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/30.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"

#import "ZHModuleBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHHomeModuleView : UIView
@property (nonatomic, strong) ZHInsetLabel *moduleName;
@property (nonatomic, strong) ZHModuleBaseView *moduleView;
@property (nonatomic, assign) NSInteger titleHeight;
-(void) setTitle:(NSString *)title font:(UIFont *)font leftSpacing:(NSInteger)spacing;


@end

NS_ASSUME_NONNULL_END
