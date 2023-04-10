//
//  ZHMineViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/12.
//

#import "ZHMineViewController.h"
#import "ZHUserBar.h"
#import "ZHLoginViewController.h"
#import "ZHInsetLabel.h"
#import "ZHOperationViewController.h"
#import "ZHUser.h"
#import "QiniuUtils.h"
#import "ZHEditUserInfoViewController.h"

@interface ZHMineViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)ZHUserBar *userBar;
@property (nonatomic, strong)ZHOperationViewController *operationVC;
@property (nonatomic, strong)ZHUser *aUser;
@property (nonatomic) BOOL isLogin;
@end
@implementation ZHMineViewController

- (void)viewDidLoad {
    self.title = @"我的";
    [super viewDidLoad];
  
    
    //  渐变色背景
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, 256);
    gradientLayer.colors = @[ (__bridge id)[UIColor mineBGColor].CGColor,  (__bridge id)[UIColor whiteColor].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0.0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    [self.view.layer insertSublayer:gradientLayer atIndex:0];

    //  用户栏
    [self.userBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.height.mas_offset(128);
    }];
    
    //  下方功能台
    [self.operationVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.userBar.mas_bottom).offset(24);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(TABBAR_HEIGHT);
    }];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.operationVC.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(20, 20)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = maskPath.CGPath;
    self.operationVC.view.layer.mask = maskLayer;


    self.userBar.userAvatar.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toEditInfo)];
    [self.userBar addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:LOGIN_FLAG]){
        [self getUserInfo];
//        self.isLogin = YES;
        
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.aUser.image] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    [self.userBar.userAvatar setImage:image];
                }];
        
        
        self.userBar.userName.text = self.aUser.nickname;
        
    }else{
        [self.userBar.userAvatar setImage:[UIImage imageNamed:@"normal_avatar"]];
        self.userBar.userName.text = @"未登录";
    }
}


///  MARK: 懒加载
- (ZHUserBar *)userBar{
    if(!_userBar){
        _userBar = [[ZHUserBar alloc]init];
        [self.view addSubview:_userBar];
    }
    return _userBar;
}

- (ZHOperationViewController *)operationVC{
    if(!_operationVC){
        _operationVC = [[ZHOperationViewController alloc]init];
        [self addChildViewController:_operationVC];
        [self.view addSubview:_operationVC.view];
    }
    return _operationVC;
}

- (ZHUser *)aUser{
    if(!_aUser){
        _aUser = [[ZHUser alloc]init];
    }
    return _aUser;
}

#pragma mark - 方法

-(void)toEditInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:LOGIN_FLAG]){
        ZHEditUserInfoViewController *editUserInfoVC = [[ZHEditUserInfoViewController alloc]init];
        editUserInfoVC.aUser = self.aUser;
        editUserInfoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:editUserInfoVC animated:YES];
    }
    else{
        ZHLoginViewController *loginVC = [[ZHLoginViewController alloc]init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}



///  更换头像



///  获取用户个人信息
-(void)getUserInfo{
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    //  改为同步请求
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:LOGIN_FLAG];
    
    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"token"];
    NSString *url = [BASE_URL stringByAppendingString:@"/user/getuserinfo"];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"发送请求成功 %@", responseObject);
        NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
        aDic = [responseObject[@"data"] copy];
        self.aUser.image = aDic[@"image"];
        self.aUser.nickname = aDic[@"name"];
        self.aUser.tel =  [NSString stringWithFormat:@"%@",  aDic[@"tel"]];
        NSString *genderIndex = aDic[@"sex"] ;
        NSInteger genderInx = [genderIndex integerValue];
        switch (genderInx) {
            case 0:
                self.aUser.gender = @"男";
                break;
            case 1:
                self.aUser.gender = @"女";
                break;
            case 2:
                self.aUser.gender = @"未知";
                break;
                
            default:
                break;
        }
        dispatch_semaphore_signal(semaphore);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"发送请求失败 %@", error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}
@end
