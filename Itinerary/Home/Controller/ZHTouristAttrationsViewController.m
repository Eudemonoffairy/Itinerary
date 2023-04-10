//
//  ZHTouristAttrationsViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//  首页 - 景点游览

#import "ZHTouristAttrationsViewController.h"
#import "ZHHomeTouristTableViewController.h"
#import "ZHNetworkingUtils.h"
#import "ZHAttraction.h"
#import "ZHMapUtil.h"
@interface ZHTouristAttrationsViewController ()

@end

@implementation ZHTouristAttrationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //  显示缺省图
    [self showStatus:SEARCHING_STATSUS info:@"搜索中"];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(hideStatuView) name:MAP_ATTRATION object:nil];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    ZHHomeTouristTableViewController *tableViewController = [[ZHHomeTouristTableViewController alloc]init];
    [self addChildViewController:tableViewController];
    [self.view addSubview:tableViewController.view];
    
    [tableViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.left.right.bottom.mas_equalTo(0);
    }];
    [self getResource];
}


- (void)viewWillAppear:(BOOL)animated{
    //  由于首页没有显示导航栏，这里要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getResource{
    NSDictionary *params = @{
        
    };
    [ZHNetworkingUtils requestWithURL:@"/attractions/getalldata" method:RequestMethodGET parameters:params needToken:YES success:^(id  _Nonnull responseObject) {
        [self preprocessingData:responseObject[@"data"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}

-(void)preprocessingData:(NSArray *)data{
    NSMutableArray *codeArr = [[NSMutableArray alloc]init];
    for(int i = 0; i < data.count;i++){
        [codeArr addObject:data[i][@"placecode"]];
    }
    [[ZHMapUtil sharedInstance] searchPOIs:codeArr];
}





@end
