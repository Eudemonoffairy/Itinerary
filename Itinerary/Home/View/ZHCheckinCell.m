//
//  ZHCheckinCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//

#import "ZHCheckinCell.h"

@implementation ZHCheckinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect{
    
    [self.content addSubview:self.cellImage];
    [self.content addSubview:self.cellTitle];
    [self.content addSubview:self.scoreLabel];
    [super drawRect:rect];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(12);
            make.right.mas_equalTo(self.mas_right).mas_offset(-12);
            make.top.mas_equalTo(self.mas_top).mas_offset(12);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-12);
    }];
    self.content.layer.cornerRadius = 24;
    self.content.layer.masksToBounds = YES;
    
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.content);
            make.right.mas_equalTo(self.content);
            make.top.mas_equalTo(self.content);
            make.bottom.mas_equalTo(self.content);
    }];
    
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.content).mas_offset(24);
            make.centerY.mas_equalTo(self.content);
    }];
    [self.scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.content).mas_offset(-12);
        make.top.mas_equalTo(self.cellTitle.mas_bottom);
    }];
    
}

- (UIImageView *)cellImage{
    if(!_cellImage){
        _cellImage = [[UIImageView alloc]init];
        [_cellImage setImage:[UIImage imageNamed:@"guangzhou"]];
        _cellImage.contentMode = UIViewContentModeScaleAspectFill;
        _cellImage.clipsToBounds = YES;
       
    }
    return _cellImage;
}

- (UILabel *)cellTitle{
    if(!_cellTitle){
        _cellTitle = [[UILabel alloc]init];
        _cellTitle.text = @"NaN";
        _cellTitle.font = [UIFont boldSystemFontOfSize:36];
        _cellTitle.textColor = [UIColor whiteColor];
       
    }
    return _cellTitle;
}

- (UILabel *)scoreLabel{
    if(!_scoreLabel){
        _scoreLabel = [[UILabel alloc]init];
        _scoreLabel.font = [UIFont boldFontSize_22];
        _scoreLabel.textColor = [UIColor whiteColor];
        
    }
    return _scoreLabel;
}
- (UIView *)content{
    if(!_content){
        _content = [[UIView alloc]init];
        [self addSubview:_content];
    }
    return _content;
}

- (void)setFinished:(NSInteger)finished{
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld / %ld",finished,self.unfinish];
}

- (void)setUnfinish:(NSInteger)unfinish{
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld / %ld",self.finished,unfinish];
}


@end
