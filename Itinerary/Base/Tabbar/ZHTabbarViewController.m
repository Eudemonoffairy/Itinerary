//
//  ZHTabbarViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/3.
//

#import "ZHTabbarViewController.h"
#import "ZHHomeViewController.h"
#import "ZHNoteViewController.h"
#import "ZHMineViewController.h"
@interface ZHTabbarViewController ()

@end

@implementation ZHTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //  首页
    ZHHomeViewController *homeView = [[ZHHomeViewController alloc]init];
//    homeView.view.backgroundColor = [UIColor grayBackgroundColor];
    homeView.tabBarItem.title = @"首页";
    UINavigationController *homeNavi = [[UINavigationController alloc]initWithRootViewController:homeView];
    homeNavi.tabBarItem.title = homeView.tabBarItem.title;
    homeNavi.tabBarItem.image = [UIImage imageNamed:@"Note_0"];
    homeNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"Note_1"];
    
    //  游记
    ZHNoteViewController *noteView = [[ZHNoteViewController alloc]init];
    noteView.view.backgroundColor = [UIColor grayBackgroundColor];
    noteView.tabBarItem.title = @"游记";
    UINavigationController *noteNavi = [[UINavigationController alloc]initWithRootViewController:noteView];
    noteNavi.tabBarItem.title = noteView.tabBarItem.title;
    noteNavi.tabBarItem.image = [UIImage imageNamed:@"Note_0"];
    noteNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"Note_1"];
    
    //  我的
    ZHMineViewController *mineView = ZHMineViewController.new;
    mineView.tabBarItem.title = @"我的";
    UINavigationController *mineNavi = [[UINavigationController alloc]initWithRootViewController:mineView];
    mineNavi.tabBarItem.title = mineView.tabBarItem.title;
    mineNavi.tabBarItem.image = [UIImage imageNamed:@"Mine_0"];
    mineNavi.tabBarItem.selectedImage = [UIImage imageNamed:@"Mine_1"];
    
    UINavigationBarAppearance *naviappearance = UINavigationBarAppearance.new;
    naviappearance.backgroundColor = [UIColor whiteColor];
    naviappearance.shadowColor = [UIColor systemGray2Color];
    [UINavigationBar appearance].standardAppearance = naviappearance;
    [UINavigationBar appearance].scrollEdgeAppearance = naviappearance;

    UITabBarAppearance *tabAppearance = UITabBarAppearance.new;
    tabAppearance.backgroundColor = [UIColor whiteColor];
    tabAppearance.shadowColor = [UIColor systemGray2Color];
    [UITabBar appearance].standardAppearance = tabAppearance;
    if (@available(iOS 15.0, *)) {
        [UITabBar appearance].scrollEdgeAppearance = tabAppearance;
    } else {
    }
    self.tabBar.unselectedItemTintColor = [UIColor whiteColor];
    self.tabBar.tintColor = [UIColor tabbarTintColor];
    self.viewControllers = @[homeNavi, noteNavi, mineNavi];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
