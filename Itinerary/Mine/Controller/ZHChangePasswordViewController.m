//
//  ZHChangePasswordViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/1.
//  修改密码页面

#import "ZHChangePasswordViewController.h"
#import "ZHInsetTextField.h"
@interface ZHChangePasswordViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) ZHInsetTextField *originalPassword;        //  原密码
@property (nonatomic, strong) ZHInsetTextField *changePassword;          //  修改密码
@property (nonatomic, strong) ZHInsetTextField *checkPassword;           //  确认密码
@property (nonatomic, strong) UIButton *saveButton;                     //  保存
@end

@implementation ZHChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayBackgroundColor];
    self.title = @"修改密码";
    
    //  点击背景落下键盘
    UITapGestureRecognizer *tapEndEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapEndEdit.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEndEdit];
    
    [self.originalPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT+24);
        make.height.mas_equalTo(48);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
    }];
    
    
    [self.changePassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.originalPassword.mas_centerX);
        make.top.mas_equalTo(self.originalPassword.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(self.originalPassword.mas_height);
        make.width.mas_equalTo(self.originalPassword.mas_width);
    }];
    
    
    [self.checkPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.originalPassword.mas_centerX);
        make.top.mas_equalTo(self.changePassword.mas_bottom).mas_offset(24);
        make.height.mas_equalTo(self.originalPassword.mas_height);
        make.width.mas_equalTo(self.originalPassword.mas_width);
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.checkPassword.mas_bottom).mas_offset(24);
        make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.8);
        make.height.mas_equalTo(48);
    }];
    
    
}


//  MARK: 懒加载
- (ZHInsetTextField *)originalPassword{
    if(!_originalPassword){
        _originalPassword = [[ZHInsetTextField alloc]init];
        _originalPassword.placeholder = @"原密码";
        _originalPassword.leftEdge = 12;
        _originalPassword.layer.shadowOpacity = 0.1;
        _originalPassword.layer.shadowOffset = CGSizeMake(0, 1);
        _originalPassword.backgroundColor = [UIColor whiteColor];
        _originalPassword.layer.cornerRadius = 8;
        _originalPassword.keyboardType = UIKeyboardTypeASCIICapable;
        _originalPassword.delegate = self;
        [self.view addSubview:_originalPassword];
    }
    return _originalPassword;
}

- (ZHInsetTextField *)changePassword{
    if(!_changePassword){
        _changePassword = [[ZHInsetTextField alloc]init];
        _changePassword.placeholder = @"修改密码";
        _changePassword.leftEdge = 12;
        _changePassword.layer.shadowOpacity = 0.1;
        _changePassword.layer.shadowOffset = CGSizeMake(0, 1);
        _changePassword.backgroundColor = [UIColor whiteColor];
        _changePassword.layer.cornerRadius = 8;
        _changePassword.keyboardType = UIKeyboardTypeASCIICapable;
        _changePassword.delegate = self;
        [self.view addSubview:_changePassword];
    }
    return _changePassword;
}


- (ZHInsetTextField *)checkPassword{
    if(!_checkPassword){
        _checkPassword = [[ZHInsetTextField alloc]init];
        _checkPassword.placeholder = @"确认密码";
        _checkPassword.leftEdge = 12;
        _checkPassword.layer.shadowOpacity = 0.1;
        _checkPassword.layer.shadowOffset = CGSizeMake(0, 1);
        _checkPassword.backgroundColor = [UIColor whiteColor];
        _checkPassword.layer.cornerRadius = 8;
        _checkPassword.keyboardType = UIKeyboardTypeASCIICapable;
        _checkPassword.delegate = self;
        [self.view addSubview:_checkPassword];
    }
    return _checkPassword;
}

- (UIButton *)saveButton{
    if(!_saveButton){
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [_saveButton setBackgroundColor:[UIColor themeColor]];
        [self.view addSubview:_saveButton];
        
    }
    return _saveButton;
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

-(void)saveAction{
    if(self.changePassword.text.length < 8){
        [self autoShowInfo:@"密码太短会不安全哦！\n_(:τ」∠)_"];
    }
    else if(![self.changePassword.text isEqualToString:self.checkPassword.text]){
        //  修改密码与确认密码不匹配
        [self autoShowInfo:@"修改密码与确认密码不一致！"];
        
    }
    else{
        AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
        NSDictionary *dict = @{
                               @"originPassword":self.originalPassword.text,
                               @"newPassword":self.changePassword.text,
        };
        //  改为同步请求
        manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
        [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
        NSString *url = [BASE_URL stringByAppendingString:@"/user/updatepassword"];
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [manager POST:url parameters:dict headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"发送请求成功 %@", responseObject);
//            [self autoShowInfo:@"修改成功！"];
//            [self.navigationController popViewControllerAnimated:YES];
            dispatch_semaphore_signal(semaphore);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"发送请求失败 %@", error);
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    }

}

@end
