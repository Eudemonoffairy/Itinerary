//
//  ZHWaterfallFlowLayout.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/12.
//

#import "ZHWaterfallFlowLayout.h"

@interface ZHWaterfallFlowLayout ()

@property (nonatomic, strong) NSMutableArray *columnHeights; // 列高度数组
@property (nonatomic, strong) NSMutableArray *attributesArray; // item attributes 数组

@end

@implementation ZHWaterfallFlowLayout

- (instancetype)init {
    if (self = [super init]) {
        self.columnCount = 2;
        self.itemSpacing = 10;
        self.sectionInsets = UIEdgeInsetsMake(4, 12, 12, 12);
        self.columnHeights = [NSMutableArray arrayWithCapacity:self.columnCount];
        self.attributesArray = [NSMutableArray array];
        for (NSInteger i = 0; i < self.columnCount; i++) {
            [self.columnHeights addObject:@(self.sectionInsets.top)];
        }
    }
    return self;
}


- (void)prepareLayout {
    [super prepareLayout];
    // 清空数组
    [self.columnHeights removeAllObjects];
    [self.attributesArray removeAllObjects];
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.sectionInsets.top)];
    }
    // 计算每个 item 的 frame 并添加到 attributesArray 中
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < itemCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attributesArray addObject:attributes];
    }
}


- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = 0;
    for (NSInteger i = 0; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        if (columnHeight > maxHeight) {
            maxHeight = columnHeight;
        }
    }
    return CGSizeMake(self.collectionView.bounds.size.width, maxHeight + self.sectionInsets.bottom);
}


- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat collectionViewWidth = self.collectionView.bounds.size.width;
    CGFloat itemWidth = (collectionViewWidth - self.sectionInsets.left - self.sectionInsets.right - (self.columnCount - 1) * self.itemSpacing) / self.columnCount;
    CGFloat itemHeight = [self.delegate collectionView:self.collectionView heightForItemAtIndexPath:indexPath withItemWidth:itemWidth];
    // 找到最短的列
    NSInteger shortestColumnIndex = 0;
    CGFloat shortestColumnHeight = [self.columnHeights[0] floatValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        CGFloat columnHeight = [self.columnHeights[i] floatValue];
        if (columnHeight < shortestColumnHeight) {
            shortestColumnIndex = i;
            shortestColumnHeight = columnHeight;
        }
    }
    // 计算 item 的 frame
    CGFloat x = self.sectionInsets.left + shortestColumnIndex * (itemWidth + self.itemSpacing);
    CGFloat y = shortestColumnHeight + self.itemSpacing;
    CGRect frame = CGRectMake(x, y, itemWidth, itemHeight);
    // 更新列高
    self.columnHeights[shortestColumnIndex] = @(CGRectGetMaxY(frame));
    // 创建并返回 item 的 attributes
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = frame;
    return attributes;
    }
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
return self.attributesArray;
}


@end
