//
//  ZHCheckinSetCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import <UIKit/UIKit.h>
#import "ZHInsetLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface ZHCheckinSetCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) ZHInsetLabel *cellTitle;
@property (nonatomic) BOOL isFinish;

-(void)updateStatus;
@end

NS_ASSUME_NONNULL_END
