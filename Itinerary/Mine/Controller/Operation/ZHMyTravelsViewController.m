//
//  ZHMyTravelsViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//  我的游记界面

#import "ZHMyTravelsViewController.h"
#import "ZHLoginViewController.h"
#import "ZHAddTravelsViewController.h"
@interface ZHMyTravelsViewController ()
///  新建游记按钮
@property (nonatomic, strong)UIButton *addTravels;
@end

@implementation ZHMyTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.addTravels mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(12);
        make.height.mas_equalTo(48);
    }];
    
    
}

//  MARK: 懒加载
- (UIButton *)addTravels{
    if(!_addTravels){
        _addTravels = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTravels setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
        _addTravels.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_addTravels setTitle:@"新建笔记" forState:UIControlStateNormal];
        [_addTravels setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addTravels setTitleEdgeInsets:UIEdgeInsetsMake(0, 24, 0, 0)];
        _addTravels.backgroundColor = [UIColor whiteColor];
        _addTravels.layer.borderColor = [[UIColor systemGrayColor] CGColor];
        _addTravels.layer.borderWidth = 1;
        _addTravels.layer.cornerRadius = 8;
        _addTravels.layer.masksToBounds = YES;
        [_addTravels addTarget:self action:@selector(addTravelsAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addTravels];
    }
    return _addTravels;
}


// MARK: Action
-(void)addTravelsAction{
    //  判断是否登录
    //  如果没有登录：跳转到登录页，并显示「暂未登录」
    //  如果登录了：跳转到新建游记页
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // TODO: 理论上这里应该需要解析 token
    if([defaults objectForKey:LOGIN_FLAG]){
        //  登录了
        [self toAddTravels];
    }
    else{
        ZHLoginViewController *loginVC = [[ZHLoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        [self autoShowInfo:@"暂未登录"];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
    
    
}

-(void)toAddTravels{
    ZHAddTravelsViewController *addTravelsVC = [[ZHAddTravelsViewController alloc]init];
    addTravelsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addTravelsVC animated:YES];
}

@end
