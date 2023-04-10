//
//  ZHLoginPhoneViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/13.
//

#import "ZHLoginPhoneViewController.h"
#import "ZHLoginViewController.h"
#import "ZHRegisterViewController.h"
#import "ZHInsetTextField.h"
#import "ZHChapchaButton.h"
@interface ZHLoginPhoneViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) ZHInsetTextField *username;
@property (nonatomic, strong) ZHInsetTextField *chapcha;
@property (nonatomic, strong) ZHChapchaButton *getChapcha;
@property (nonatomic, strong) UIButton *loginBtn;

///  手机号登录
@property (nonatomic, strong) UIButton *switchBtn;
///  注册账号
@property (nonatomic, strong) UIButton *registerBtn;
@end

@implementation ZHLoginPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayBackgroundColor];
    [self.view addSubview:self.username];
    [self.view addSubview:self.chapcha];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.switchBtn];
    [self.view addSubview:self.registerBtn];
    
    //  点击背景落下键盘
    UITapGestureRecognizer *tapEndEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapEndEdit.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEndEdit];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    UILabel *loginTitle = [[UILabel alloc]init];
    loginTitle.text =  @"登录 / Login";
    [self.view addSubview:loginTitle];
    loginTitle.font = [UIFont fontSize_h1];
    [loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(loginTitle.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
  
    
    [self.chapcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.username.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(self.username.mas_left);
    }];
    [self.view layoutIfNeeded];
    
    
    
  
    [self.getChapcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chapcha.mas_right);
        make.top.mas_equalTo(self.chapcha.mas_top);
        make.bottom.mas_equalTo(self.chapcha.mas_bottom);
        make.right.mas_equalTo(self.username.mas_right);
    }];
    __weak typeof(self)wself = self;
    self.getChapcha.clickedBlock = ^{
        //  TODO: 获取验证码
        [wself receiveChapcha];
    };
    

    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
            make.height.mas_equalTo(48);
            make.top.mas_equalTo(self.chapcha.mas_bottom).mas_offset(72);
            make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [self.view addSubview:self.loginBtn];
    [self.loginBtn setBackgroundColor:[UIColor themeColor]];
    self.loginBtn.layer.cornerRadius = 8;
    self.loginBtn.layer.masksToBounds = YES;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    
    /// 底部
    UIView *aLine = [[UIView alloc]init];
    [self.view addSubview:aLine];
    [aLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-36);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(12);
    }];
    aLine.backgroundColor = [UIColor systemGray3Color];
    
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(aLine.mas_left).mas_offset(-16);
            make.centerY.mas_equalTo(aLine.mas_centerY);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(aLine.mas_right).mas_offset(16);
            make.centerY.mas_equalTo(aLine.mas_centerY);
    }];
    
}


// MARK: 懒加载
- (ZHInsetTextField *)username{
    if(!_username){
        _username = [[ZHInsetTextField alloc]init];
        _username.leftEdge = 12;
        _username.placeholder = @"手机号 / Username";
        _username.clearButtonMode = UITextFieldViewModeWhileEditing;
        _username.layer.shadowOpacity = 0.1;
        _username.layer.shadowOffset = CGSizeMake(0, 1);
        _username.backgroundColor = [UIColor whiteColor];
        _username.layer.cornerRadius = 8;
        _username.keyboardType = UIKeyboardTypeNumberPad;
        _username.delegate = self;
    }
    return _username;
}

- (ZHInsetTextField *)chapcha{
    if(!_chapcha){
        _chapcha = [[ZHInsetTextField alloc]init];
        _chapcha.backgroundColor = [UIColor whiteColor];
        _chapcha.leftEdge = 12;
        _chapcha.placeholder = @"验证码 / CHAPCHA";
        _chapcha.clearButtonMode = UITextFieldViewModeWhileEditing;
        _chapcha.layer.shadowOpacity = 0.1;
        _chapcha.layer.shadowOffset = CGSizeMake(1, 1);
        _chapcha.backgroundColor = [UIColor whiteColor];
        _chapcha.layer.cornerRadius = 8;
        _chapcha.keyboardType = UIKeyboardTypeNumberPad;
        _chapcha.delegate = self;
    }
    return _chapcha;
}

- (ZHChapchaButton *)getChapcha{
    if(!_getChapcha){
        _getChapcha = [ZHChapchaButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_getChapcha];
        _getChapcha.titleLabel.font = [UIFont fontSize_14];
        [_getChapcha setBackgroundColor:[UIColor themeColor]];
    }
    return _getChapcha;
}

- (UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [[UIButton alloc]init];
        [_loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)switchBtn{
    if(!_switchBtn){
        _switchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        [_switchBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _switchBtn.titleLabel.font = [UIFont boldFontSize_14];
        [_switchBtn addTarget:self action:@selector(toUserPwLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchBtn;
}

- (UIButton *)registerBtn{
    if(!_registerBtn){
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont boldFontSize_14];
        [_registerBtn addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

//  MARK: UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return  [textField resignFirstResponder];
}

//  实现点击背景落下键盘
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)toUserPwLogin{
    ZHLoginViewController *phoneLoginVc = [[ZHLoginViewController alloc]init];
    phoneLoginVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:phoneLoginVc animated:NO];
}

-(void)toRegister{
    ZHRegisterViewController *registerVC = [[ZHRegisterViewController alloc]init];
    registerVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:registerVC animated:NO];
}
-(void)backToMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


//  获取验证码
-(void)receiveChapcha{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"tel":self.username.text,
    };

    //  获得登录验证码 URL
    NSString *url = [BASE_URL stringByAppendingString:@"/user/sendlogincode"];
    [manager POST:url parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success, %@", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
    }];

}


-(void)loginAction{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSDictionary *dict = @{
            @"tel":self.username.text,
            @"loginCode":self.chapcha.text,
        };

    //  用户注册 URL
    NSString *url = [BASE_URL stringByAppendingString:@"/user/login"];
        [manager POST:url parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"发送请求成功 %@", responseObject);
            //  将 token 存入用户偏好
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:responseObject[@"data"][@"token"] forKey:LOGIN_FLAG];
            
            //  TODO: 显示登录成功返回主界面
            [self autoShowInfo:@"登录成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"发送请求成功 %@", error);
        }];
}


@end
