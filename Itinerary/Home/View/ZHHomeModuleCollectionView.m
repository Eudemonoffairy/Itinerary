//
//  ZHHomeModuleCollectionView.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//

#import "ZHHomeModuleCollectionView.h"
#import "ZHHomeModuleCollectionViewCell.h"
@interface ZHHomeModuleCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end

static NSString * const reuseIdentifier = @"ZHModuleCollectionViewCell";
@implementation ZHHomeModuleCollectionView

- (void)layoutSubviews{
    [self.collectionView registerClass:[ZHHomeModuleCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    CGFloat height = self.frame.size.height;
    self.layout.itemSize = CGSizeMake(128, height - 8);
}

//  MARK: - 懒加载
- (UICollectionView *)collectionView{
    if(!_collectionView){
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)layout{
    if(!_layout){
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.sectionInset = UIEdgeInsetsMake(4, 12, 4, 12);
        _layout.minimumLineSpacing = 12;
        _layout.minimumInteritemSpacing = 20;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _layout;
}

//  MARK: - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.cornerRadius = 8;
    cell.layer.masksToBounds = YES;
    cell.backgroundColor = [UIColor systemGray5Color];
    return cell;
}


@end
