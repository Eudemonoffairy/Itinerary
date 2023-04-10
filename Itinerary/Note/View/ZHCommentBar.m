//
//  ZHCommentBar.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/16.
//  发布评论条

#import "ZHCommentBar.h"



@implementation ZHCommentBar

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self.commentContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(12);
        make.width.mas_equalTo(self.mas_width).multipliedBy(0.70);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.sentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.commentContent.mas_right);
            make.right.mas_equalTo(self.mas_right).mas_offset(0);
            make.top.bottom.mas_equalTo(0);
    }];
    
}

- (UITextField *)commentContent{
    if(!_commentContent ){
        _commentContent = [[UITextField alloc]init];
        _commentContent.placeholder = @"说些什么吧~";
//        _commentContent.borderStyle = UITextBorderStyleLine;
        [self addSubview:_commentContent];
    }
    return _commentContent;
}
- (UIButton *)sentBtn{
    if(!_sentBtn){
        _sentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sentBtn.backgroundColor = [UIColor systemBlueColor];
        [_sentBtn setTitle:@"评论" forState:UIControlStateNormal];
        [self addSubview:_sentBtn];
        _sentBtn.backgroundColor = [UIColor statisticBGColor];
    }
    return _sentBtn;
}


@end
