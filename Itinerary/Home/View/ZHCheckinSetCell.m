//
//  ZHCheckinSetCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/7.
//

#import "ZHCheckinSetCell.h"
@interface ZHCheckinSetCell()
@property (nonatomic, strong) UIImageView *cellStatus;
@end
@implementation ZHCheckinSetCell

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addSubview:self.cellImage];
    [self addSubview:self.cellTitle];
    [self addSubview:self.cellStatus];
    
    [self.cellImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.height.mas_equalTo(128);
    }];
    
    
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.cellImage.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
    }];
    [self.cellStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.cellImage.mas_right).mas_offset(-8);
            make.bottom.mas_equalTo(self.cellImage.mas_bottom).mas_offset(-8);
            make.height.width.mas_equalTo(32);
    }];
    [self updateStatus];
    
    
    
}

-(void)updateStatus{
    if(self.isFinish){
        [self.cellStatus setImage:[UIImage imageNamed:@"checkin_1"]];
    }else{
        [self.cellStatus setImage:[UIImage imageNamed:@"checkin_0"]];
    }
}



// MARK: - 懒加载
- (UIImageView *)cellImage{
    if(!_cellImage){
        _cellImage = [[UIImageView alloc]init];
    }
    return _cellImage;
}

- (ZHInsetLabel *)cellTitle{
    if(!_cellTitle){
        _cellTitle = [[ZHInsetLabel alloc]init];
        _cellTitle.font = [UIFont fontSize_14];
        _cellTitle.leftEdge = 8;
        _cellTitle.rightEdge = 8;
        _cellTitle.lineBreakMode = NSLineBreakByWordWrapping;
        _cellTitle.numberOfLines = 2;
        
    }
    return _cellTitle;
}

- (UIImageView *)cellStatus{
    if(!_cellStatus){
        _cellStatus = [[UIImageView alloc]init];
    }
    return _cellStatus;
}

@end
