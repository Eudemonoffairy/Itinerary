//
//  ZHHomeTouristCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//  首页 - 景点浏览 - 景点列表 - 列表 Cell

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHHomeTouristCell : UITableViewCell
@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) ZHInsetLabel *cellRate;
@end

NS_ASSUME_NONNULL_END
