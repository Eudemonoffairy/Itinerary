//
//  ZHStrategyViewController.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import <UIKit/UIKit.h>
#import "ZHTitleNContentLabel.h"
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHStrategyViewController : UIViewController
@property (nonatomic, strong) NSString *imgUrls;
///  笔记标题
@property (nonatomic, strong) ZHInsetLabel *strategyTitle;
///  笔记详细
@property (nonatomic, strong) UILabel *detailText;
///  显示地图的按钮
@property (nonatomic, strong) UIButton *showWayButton;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
///  评论组
@property (nonatomic, strong) NSArray *commentArr;
@property (nonatomic, strong) NSString *contentStr;
@property (nonatomic, strong) UIImageView *authorAvatar;
@property (nonatomic, strong) UILabel *authorName;

@property (nonatomic, strong) NSString *placeids;


@end

NS_ASSUME_NONNULL_END
