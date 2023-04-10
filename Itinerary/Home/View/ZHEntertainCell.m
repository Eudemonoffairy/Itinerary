//
//  ZHEntertainCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/5.
//

#import "ZHEntertainCell.h"

@implementation ZHEntertainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom);
//        make.width.mas_equalTo(self.mas_width).multipliedBy(0.36);
        make.width.mas_equalTo(128);
    }];
    self.cellImage.contentMode = UIViewContentModeScaleAspectFill;
    self.cellImage.clipsToBounds = YES;
//    [self.cellImage setImage:[UIImage imageNamed:@"no_cover"]];
    [self.cellTiitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellImage.mas_right).mas_offset(8);
            make.top.mas_equalTo(self.mas_top).mas_offset(8);
        make.right.mas_equalTo(self.mas_right).mas_offset(-8);
    }];
    
    [self.ratingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellTiitle);
            make.top.mas_equalTo(self.cellTiitle.mas_bottom).mas_offset(4);
    }];
    self.ratingLabel.layer.cornerRadius = 4;
    self.ratingLabel.layer.masksToBounds = YES;
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.ratingLabel.mas_right).mas_offset(12);
            make.top.mas_equalTo(self.ratingLabel.mas_top);
    }];
    
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellTiitle);
            make.top.mas_equalTo(self.typeLabel.mas_bottom).mas_offset(4);
        make.right.mas_equalTo(self.mas_right).mas_offset(-8);
    }];
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellTiitle);
            make.top.mas_equalTo(self.locationLabel.mas_bottom).mas_offset(4);
    }];
    
}


// MARK: -懒加载
- (UIImageView *)cellImage{
    if(!_cellImage){
        _cellImage = [[UIImageView alloc]init];
        [self addSubview:_cellImage];
    }
    return _cellImage;
}

- (UILabel *)cellTiitle{
    if(!_cellTiitle){
        _cellTiitle = [[UILabel alloc]init];
        _cellTiitle.lineBreakMode = NSLineBreakByWordWrapping;
        _cellTiitle.numberOfLines = 2;
        _cellTiitle.font = [UIFont boldFontSize_20];
        [self addSubview:_cellTiitle];
    }
    return _cellTiitle;
}

- (UILabel *)typeLabel{
    if(!_typeLabel){
        _typeLabel = [[UILabel alloc]init];
//        _typeLabel.textColor = [UIColor systemGrayColor];
        _typeLabel.font = [UIFont fontSize_14];
        [self addSubview:_typeLabel];
    }
    return _typeLabel;
}

- (UILabel *)distanceLabel{
    if(!_distanceLabel){
        _distanceLabel = [[UILabel alloc]init];
        _distanceLabel.textColor = [UIColor systemGrayColor];
        _distanceLabel.font = [UIFont fontSize_14];
        [self addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (ZHInsetLabel *)ratingLabel{
    if(!_ratingLabel){
        _ratingLabel = [[ZHInsetLabel alloc]init];
        _ratingLabel.leftEdge = 4;
        _ratingLabel.rightEdge = 4;
        _ratingLabel.backgroundColor = [UIColor themeColor];
        _ratingLabel.textColor = [UIColor whiteColor];
        _ratingLabel.font = [UIFont boldFontSize_14];
        [self addSubview:_ratingLabel];
    }
    return _ratingLabel;
}

- (UILabel *)locationLabel{
    if(!_locationLabel){
        _locationLabel = [[UILabel alloc]init];
        _locationLabel.textColor = [UIColor systemGrayColor];
        _locationLabel.font = [UIFont fontSize_14];
        _locationLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locationLabel.numberOfLines = 0;
        [self addSubview:_locationLabel];
    }
    return _locationLabel;
}


@end
