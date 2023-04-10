//
//  ZHWaterfallFlowLayout.h
//  Itinerary
//
//  Created by Martin Liu on 2023/3/12.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WaterfallFlowLayoutDelegate <UICollectionViewDelegate>

@required
- (CGFloat)collectionView:(UICollectionView *)collectionView heightForItemAtIndexPath:(NSIndexPath *)indexPath withItemWidth:(CGFloat)itemWidth;

@end

@interface ZHWaterfallFlowLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) NSInteger columnCount; // 列数
@property (nonatomic, assign) CGFloat itemSpacing; // item 间距
@property (nonatomic, assign) UIEdgeInsets sectionInsets; // section 内边距

@property (nonatomic, weak)id<WaterfallFlowLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
