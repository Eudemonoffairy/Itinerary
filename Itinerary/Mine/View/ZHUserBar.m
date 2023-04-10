//
//  ZHUserBar.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/12.
//

#import "ZHUserBar.h"

#define AVATAR_WH       80

@interface ZHUserBar()
@property (nonatomic, strong) UIButton* settingButton;
@end

@implementation ZHUserBar

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
  
    //  用户头像
    [self.userAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).mas_offset(16);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(AVATAR_WH);
        make.height.mas_equalTo(AVATAR_WH);
    }];
    //  用户昵称
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.userAvatar.mas_centerY);
        make.left.mas_equalTo(self.userAvatar.mas_right).mas_equalTo(20);
    }];

}


#pragma mark - 懒加载
- (UIImageView *)userAvatar{
    if(!_userAvatar){
        _userAvatar = [[UIImageView alloc]init];
  
        _userAvatar.layer.cornerRadius = AVATAR_WH/2;
        _userAvatar.layer.masksToBounds = YES;
        _userAvatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        _userAvatar.layer.borderWidth = 5;
        [self addSubview:_userAvatar];
    }
    return _userAvatar;
}

- (UILabel *)userName{
    if(!_userName){
        _userName = [[UILabel alloc]init];
        _userName.font = [UIFont boldFontSize_22];
        [self addSubview:_userName];
    }
    return _userName;
}
- (UIButton *)settingButton{
    if(!_settingButton){
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"mine_setting"] forState:UIControlStateNormal];
        _settingButton.contentEdgeInsets = UIEdgeInsetsMake(4, 4, 4, 4);
        [self addSubview:_settingButton];
        
    }
    return _settingButton;
}


@end
