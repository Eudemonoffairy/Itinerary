//
//  ZHCloseIconLabel.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/8.
//

#import "ZHCloseIconLabel.h"

@implementation ZHCloseIconLabel

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(8);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(8);
            make.right.mas_equalTo(self.mas_right).mas_offset(-8);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.mas_equalTo(24);
    }];
}


//  MARK: - 懒加载
- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"button_close"]];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClose)];
        [_imageView addGestureRecognizer:tap];
        _imageView.userInteractionEnabled = YES;
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (ZHInsetLabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[ZHInsetLabel alloc]init];
        _titleLabel.font = [UIFont boldFontSize_17];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(void)tapClose{
    if([self.delegate respondsToSelector:@selector(closeAction:)]){
        [self.delegate closeAction:self];
    }
}

@end
