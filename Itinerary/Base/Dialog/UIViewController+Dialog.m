//
//  UIViewController+Dialog.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/21.
//  对 WMZDiaglog  的进一步封装

#import "UIViewController+Dialog.h"
#import "WMZDialog.h"
@implementation UIViewController (Dialog)

///  普通弹窗
- (void)showInfo:(NSString *)info{
    [self showInfo:info withTitle:@""];
}

///  带标题的普通弹窗
- (void)showInfo:(NSString *)info withTitle:(NSString *)title{
    Dialog()
    .wTitleSet(title)
    .wMessageSet(info)
    .wTypeSet(DialogTypeNornal)
    .wStartView(self.view);
}

///  自动显示与消失弹窗
-(void)autoShowInfo:(NSString *)info{
    Dialog().wTypeSet(DialogTypeAuto)
    .wMessageSet(info)
    //自动消失时间 默认1.5
    .wDisappelSecondSet(4)
    //自定义属性
    .wMainOffsetXSet(15)
    .wMainOffsetYSet(15)
    .wShowAnimationSet(AninatonShowScaleFade)
    .wHideAnimationSet(AninatonHideScaleFade)
    ///关闭交互
    .wUserInteractionEnabledSet(NO)
    .wStart();
}




@end
