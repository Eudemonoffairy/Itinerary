//
//  ZHEditInfoItem.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//

#import "ZHEditInfoItem.h"

@implementation ZHEditInfoItem


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.4);
    }];
    
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(self.cellTitle.mas_right);
    }];
    
    
    
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//  MARK: 懒加载
- (ZHInsetLabel *)cellTitle{
    if(!_cellTitle){
        _cellTitle = [[ZHInsetLabel alloc]init];
        _cellTitle.textAlignment = NSTextAlignmentLeft;
        _cellTitle.leftEdge = 12;
        [self addSubview:_cellTitle];
    }
    return _cellTitle;
}

- (ZHInsetLabel *)cellContent{
    if(!_cellContent){
        _cellContent = [[ZHInsetLabel alloc]init];
        _cellContent.textAlignment = NSTextAlignmentRight;
        _cellContent.rightEdge = 12;
        [self addSubview:_cellContent];
    }
    return _cellContent;
}

@end
