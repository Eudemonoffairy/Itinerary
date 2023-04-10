//
//  ZHHomeModuleCollectionViewCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHHomeModuleCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UIView *infoView;
@property (nonatomic, strong) ZHInsetLabel *cellTitle;
@property (nonatomic, strong) ZHInsetLabel *cellInfo;

@end

NS_ASSUME_NONNULL_END
