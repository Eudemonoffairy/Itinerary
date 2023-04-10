//
//  ZHCommentView.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//

#import "ZHCommentView.h"

@implementation ZHCommentView
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self  initSubView];
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
 
}

-(void)initSubView{
    [self addSubview:self.userAvatar];
    [self addSubview:self.userName];
    [self addSubview:self.commentText];
    [self addSubview:self.commentTime];
    self.backgroundColor = [UIColor whiteColor];
    [self.userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(8);
        make.top.mas_equalTo(self.mas_top).mas_offset(16);
        make.width.mas_offset(48);
        make.height.mas_offset(48);
    }];
    self.userAvatar.layer.cornerRadius = 24;
    self.userAvatar.layer.masksToBounds = YES;
    self.userAvatar.layer.borderWidth = 1;
    self.userAvatar.layer.borderColor = [[UIColor systemGray4Color] CGColor];
    self.userAvatar.image = [UIImage imageNamed:@"Test_1"];
    
    
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).mas_offset(8);
        make.left.mas_equalTo(self.userAvatar.mas_right).mas_offset(12);
        make.width.mas_offset(SCREEN_WIDTH * 0.5);
    }];
//    self.userName.text = @"旅游爱好者";
    
    [self.commentTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userName.mas_left);
        make.right.mas_equalTo(self.mas_right).mas_offset(-8);
        make.top.mas_equalTo(self.userName.mas_bottom);
    }];
//    self.commentTime.text = @"2023-01-23 12:34";
    
    
    [self.commentText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.userName.mas_left);
        make.top.mas_equalTo(self.commentTime.mas_bottom).mas_offset(6);
        make.right.mas_equalTo(self.mas_right).mas_offset(-8);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-8);
    }];
    self.commentText.text = @"散文诗是一种现代文体﹐兼有 诗 与散文特点的一种现代 抒情 文学体裁 。 它融合了诗的表现性和散文描写性的某些特点。散文诗一般表现作者基于社会和人生背景的小感触﹐注意描写客观生活触发下思想情感的波动和片断。";
    [self layoutIfNeeded];
}

#pragma mark - 懒加载
- (UIImageView *)userAvatar{
    if(!_userAvatar){
        _userAvatar = [[UIImageView alloc]init];
        _userAvatar.contentMode = UIViewContentModeScaleAspectFit;
    
    }
    return _userAvatar;
}

- (UILabel *)userName{
    if(!_userName){
        _userName = [[UILabel alloc]init];
        _userName.font = [UIFont boldSystemFontOfSize:18];
    }
    return _userName;
}

- (UILabel *)commentText{
    if(!_commentText){
        _commentText = [[UILabel alloc]init];
        _commentText.numberOfLines = 0;
        _commentText.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _commentText;
}

- (UILabel *)commentTime{
    if(!_commentTime){
        _commentTime = [[UILabel alloc]init];
        _commentTime.font = [UIFont fontSize_14];
        _commentTime.textColor = [UIColor systemGrayColor];
//        _commentTime.textAlignment = NSTextAlignmentRight;
    }
    return _commentTime;
}

@end
