//
//  ZHCollectionViewCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/4.
//

#import "ZHCollectionViewCell.h"
@interface ZHCollectionViewCell()
@property (nonatomic, strong) UIView *infoView;
@end

@implementation ZHCollectionViewCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self addSubview:self.cellImg];
    [self addSubview:self.infoView];
    [self.infoView addSubview:self.cellTitle];
    [self.infoView addSubview:self.avatar];
    [self.infoView addSubview:self.authorName];
    [self.infoView addSubview:self.mark];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.height.mas_offset(72);
    }];
    self.infoView.backgroundColor = [UIColor whiteColor];
    
    [self.cellImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.infoView.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
    }];
    
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoView.mas_left).mas_offset(8);
        make.right.mas_equalTo(self.infoView.mas_right).mas_offset(-8);
        make.top.mas_equalTo(self.infoView.mas_top).mas_offset(8);
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.infoView.mas_left).mas_offset(12);
        make.width.mas_offset(16);
        make.height.mas_offset(16);
        make.bottom.mas_equalTo(self.infoView.mas_bottom).mas_offset(-12);
    }];
    self.avatar.layer.cornerRadius = 8;
    self.avatar.layer.masksToBounds = YES;
    
    [self.authorName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar.mas_right).mas_offset(6);
        make.right.mas_equalTo(self.infoView.mas_right).mas_offset(-48);
        make.centerY.mas_equalTo(self.avatar.mas_centerY);
    }];
    
    self.authorName.font = [UIFont fontSize_14];
    self.authorName.textColor = [UIColor systemGrayColor];
//    self.authorName.text = @"芜湖";
    
    [self.mark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).mas_offset(-8);
        make.centerY.mas_equalTo(self.avatar.mas_centerY);
    }];
    
    self.mark.font = [UIFont fontSize_12];
    self.mark.textColor = [UIColor systemYellowColor];
}

#pragma mark - 懒加载
- (UIImageView *)cellImg{
    if(!_cellImg){
        _cellImg = [[UIImageView alloc]init];
    }
    return _cellImg;
}

- (UIView *)infoView{
    if(!_infoView){
        _infoView = [[UIView alloc]init];
    }
    return _infoView;
}

- (UILabel *)cellTitle{
    if(!_cellTitle){
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.font = [UIFont boldFontSize_20];
//        _cellTitle.numberOfLines = 2;
//        _cellTitle.textAlignment = NSTextAlignmentNatural;
    }
    return _cellTitle;
}

- (UIImageView *)avatar{
    if(!_avatar){
        _avatar = [[UIImageView alloc]init];
    }
    return _avatar;
}

- (UILabel *)authorName{
    if(!_authorName){
        _authorName = [[UILabel alloc]init];
    }
    return _authorName;
}

- (UILabel *)mark{
    if(!_mark){
        _mark = [[UILabel alloc]init];
    }
    return _mark;
}

@end
