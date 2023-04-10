//
//  ZHCheckinCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCheckinCell : UITableViewCell
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIImageView *cellImage;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic) NSInteger unfinish;
@property (nonatomic) NSInteger finished;


- (void)setFinished:(NSInteger)finished;
- (void)setUnfinish:(NSInteger)unfinish;
@end

NS_ASSUME_NONNULL_END
