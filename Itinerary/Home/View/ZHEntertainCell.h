//
//  ZHEntertainCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/5.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHEntertainCell : UITableViewCell

/// 封面视图
@property (nonatomic, strong) UIImageView *cellImage;

/// 标题标签
@property (nonatomic, strong) UILabel *cellTiitle;

///  类型标签
@property (nonatomic, strong) UILabel *typeLabel;

/// 距离标签
@property (nonatomic, strong) UILabel *distanceLabel;

/// 评分标签
@property (nonatomic, strong) ZHInsetLabel *ratingLabel;

/// 地址标签
@property (nonatomic, strong) UILabel *locationLabel;
@end

NS_ASSUME_NONNULL_END
