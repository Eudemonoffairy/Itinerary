//
//  ZHRegisterViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/13.
//

#import "ZHRegisterViewController.h"
#import "ZHLoginViewController.h"
#import "ZHUser.h"

#import "ZHStatusViewController.h"
#import "ZHInsetTextField.h"
#import "ZHChapchaButton.h"
@interface ZHRegisterViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) ZHInsetTextField *username;
@property (nonatomic, strong) ZHInsetTextField *chapcha;
@property (nonatomic, strong) ZHInsetTextField *password;
@property (nonatomic, strong) ZHInsetTextField *checkPW;
@property (nonatomic, strong) UIButton *registerBtn;

///  登录账号
@property (nonatomic, strong) UIButton *loginBtn;
@end

@implementation ZHRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.username];
    [self.view addSubview:self.chapcha];
    [self.view addSubview:self.password];
    [self.view addSubview:self.checkPW];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerBtn];
    
    //  点击背景落下键盘
    UITapGestureRecognizer *tapEndEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapEndEdit.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEndEdit];
    
    //  将导航栏的返回键实现返回到根控制器
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backToMain) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    
    UILabel *registerTitle = [[UILabel alloc]init];
    registerTitle.text =  @"注册 / Register";
    [self.view addSubview:registerTitle];
    registerTitle.font = [UIFont fontSize_h1];
    [registerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(registerTitle.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
  
    
    //  密码
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.username.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
   
    
    
    
    //  确认密码
    [self.checkPW mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.password.mas_bottom).mas_offset(24);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.chapcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.5);
        make.height.mas_equalTo(48);
        make.top.mas_equalTo(self.checkPW.mas_bottom).mas_offset(20);
        
        make.left.mas_equalTo(self.username.mas_left);
    }];
    
    ZHChapchaButton *getChapcha = [ZHChapchaButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:getChapcha];
    [getChapcha setTitle:@"获取验证码" forState:UIControlStateNormal];
    getChapcha.titleLabel.font = [UIFont fontSize_14];
    [getChapcha setBackgroundColor:[UIColor themeColor]];
    [getChapcha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.chapcha.mas_right);
        make.top.mas_equalTo(self.chapcha.mas_top);
        make.bottom.mas_equalTo(self.chapcha.mas_bottom);
        make.right.mas_equalTo(self.username.mas_right);
    }];
//    [getChapcha addTarget:self action:@selector(receiveChapcha) forControlEvents:UIControlEventTouchUpInside];
    getChapcha.clickedBlock = ^{
        [self receiveChapcha];
    };
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
            make.height.mas_equalTo(48);
            make.top.mas_equalTo(self.chapcha.mas_bottom).mas_offset(72);
            make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    [self.view addSubview:self.registerBtn];
    [self.registerBtn setBackgroundColor:[UIColor themeColor]];
    [self.registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    

    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-36);
    }];
    
}

// MARK: 懒加载

- (ZHInsetTextField *)username{
    if(!_username){
        _username = [[ZHInsetTextField alloc]init];
        _username.delegate = self;
        _username.placeholder = @"手机号 / Username";
        _username.clearButtonMode = UITextFieldViewModeWhileEditing;
        _username.layer.shadowOpacity = 0.1;
        _username.layer.shadowOffset = CGSizeMake(0, 1);
        _username.backgroundColor = [UIColor whiteColor];
        _username.layer.cornerRadius = 8;
        _username.leftEdge = 12;
        _username.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _username;
}

- (ZHInsetTextField *)password{
    if(!_password){
        _password = [[ZHInsetTextField alloc]init];
        _password.delegate = self;
        _password.secureTextEntry = YES;
        _password.placeholder = @"密码 / Password";
        _password.clearButtonMode = UITextFieldViewModeWhileEditing;
        _password.layer.shadowOpacity = 0.1;
        _password.layer.shadowOffset = CGSizeMake(0, 1);
        _password.backgroundColor = [UIColor whiteColor];
        _password.layer.cornerRadius = 8;
        _password.leftEdge = 12;
        _password.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _password;
}

- (ZHInsetTextField *)checkPW{
    if(!_checkPW){
        _checkPW = [[ZHInsetTextField alloc]init];
        _checkPW.delegate = self;
        _checkPW.placeholder = @"确认密码 / CheckPasswod";
        _checkPW.clearButtonMode = UITextFieldViewModeWhileEditing;
        _checkPW.layer.shadowOpacity = 0.1;
        _checkPW.layer.shadowOffset = CGSizeMake(0, 1);
        _checkPW.backgroundColor = [UIColor whiteColor];
        _checkPW.layer.cornerRadius = 8;
        _checkPW.secureTextEntry = YES;
        _checkPW.leftEdge = 12;
        _checkPW.keyboardType = UIKeyboardTypeASCIICapable;
    }
    return _checkPW;
}

- (ZHInsetTextField *)chapcha{
    if(!_chapcha){
        _chapcha = [[ZHInsetTextField alloc]init];
        _chapcha.delegate = self;
        _chapcha.placeholder = @"验证码 / CHAPCHA";
        _chapcha.clearButtonMode = UITextFieldViewModeWhileEditing;
        _chapcha.layer.shadowOpacity = 0.1;
        _chapcha.layer.shadowOffset = CGSizeMake(1, 1);
        _chapcha.backgroundColor = [UIColor whiteColor];
        _chapcha.layer.cornerRadius = 8;
        _chapcha.leftEdge = 12;
        _chapcha.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _chapcha;
}

- (UIButton *)registerBtn{
    if(!_registerBtn){
        _registerBtn = [[UIButton alloc]init];
        [_registerBtn addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        _registerBtn.layer.cornerRadius = 8;
    }
    return _registerBtn;
}


- (UIButton *)loginBtn{
    if(!_loginBtn){
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录账号" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont boldFontSize_14];
        [_loginBtn addTarget:self action:@selector(toUserPwLogin) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
-(void)toUserPwLogin{
    ZHLoginViewController *phoneLoginVc = [[ZHLoginViewController alloc]init];
    phoneLoginVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:phoneLoginVc animated:NO];
}

-(void)backToMain{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)registerAction{
    
    NSLog(@"点击发送验证码");
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSDictionary *dict = @{
                               @"phoneNumber":@"18316693689",
                               @"password":@"aaaaaaaa",
                               @"confirmPassword":@"aaaaaaaa",
                               @"code":self.chapcha.text,
                               @"name":@"旅行者",
        };

    //  用户注册 URL
    NSString *url = [BASE_URL stringByAppendingString:@"/user/register"];
        [manager POST:url parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"发送请求成功 %@", responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"发送请求成功 %@", error);
        }];
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

-(void)registerSuccess{
//    ZHUser *aUser = [[ZHUser alloc]init];
//    aUser.tel = self.username.text;
//    if([ZHUserDataBase insertData:aUser password:self.password.text]){
//        //  注册成功
////        ZHStatusViewController* statusViewController = [[ZHStatusViewController alloc]initWithStatus:STATUS_SUCCESS info:@"注册成功"];
//        [self autoShowInfo:[NSString stringWithFormat:@"注册成功！"]];
//        [self toUserPwLogin];
//    }
//    else{
//        [self autoShowInfo:[NSString stringWithFormat:@"注册失败"]];
//    }
}

//  获取验证码
-(void)receiveChapcha{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSDictionary *dict = @{
                           @"phoneNumber":self.username.text,
    };

    //  用户注册 URL
    NSString *url = [BASE_URL stringByAppendingString:@"/user/sendregistercode"];
    [manager POST:url parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"fail");
    }];

}





@end
