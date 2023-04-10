//
//  ZHCollectionViewCell.h
//  Itinerary
//
//  Created by Martin Liu on 2023/2/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZHCollectionViewCell : UICollectionViewCell
//  笔记图、 标题（两行）、作者头像、作者名、 评分


@property (nonatomic, strong) UIImageView *cellImg;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *authorName;
@property (nonatomic, strong) UILabel *mark;
@end

NS_ASSUME_NONNULL_END
