//
//  ZHHomeTouristCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//

#import "ZHHomeTouristCell.h"

@implementation ZHHomeTouristCell

- (void)drawRect:(CGRect)rect{
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.top.mas_equalTo(self.mas_top);
            make.width.mas_equalTo(self.mas_width).multipliedBy(0.5);
            make.height.mas_equalTo(self.mas_height);
    }];
    
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellImage.mas_right).mas_offset(8);
            make.right.mas_equalTo(self.mas_right).mas_offset(-8);
            make.top.mas_equalTo(self.mas_top).mas_offset(8);
        
    }];
    
    [self.cellRate mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.cellTitle);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-8);
    }];
}

//  MARK: - 懒加载
- (UIImageView *)cellImage{
    if(!_cellImage){
        _cellImage = [[UIImageView alloc]init];
        _cellImage.contentMode = UIViewContentModeScaleAspectFill;
        _cellImage.clipsToBounds = YES;
        [self addSubview:_cellImage];
        
    }
    return _cellImage;
}

- (UILabel *)cellTitle{
    if(!_cellTitle){
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _cellTitle.numberOfLines = 2;
        _cellTitle.font = [UIFont boldFontSize_22];
        _cellTitle.textColor = [UIColor H1Color];
        [self addSubview:_cellTitle];
    }
    return _cellTitle;
}

- (ZHInsetLabel *)cellRate{
    if(!_cellRate){
        _cellRate = [[ZHInsetLabel alloc]init];
        _cellRate.textColor = [UIColor whiteColor];
        _cellRate.backgroundColor = [UIColor themeColor];
        _cellRate.leftEdge = 4;
        _cellRate.rightEdge = 4;
        _cellRate.layer.cornerRadius = 8;
        _cellRate.layer.masksToBounds = YES;
        [self addSubview:_cellRate];
    }
    return _cellRate;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
