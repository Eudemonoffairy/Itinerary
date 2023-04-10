//
//  ZHOperationViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/20.
//

#import "ZHOperationViewController.h"
#import "ZHMyTravelsViewController.h"
@interface ZHOperationViewController ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (nonatomic, strong) NSArray *contentViewControllers;
@property (nonatomic, strong) UISegmentedControl *segment;
@property (nonatomic, strong) UIPageViewController *pageViewController;
@end

@implementation ZHOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    // 创建内容视图控制器
    //  我的游记
    ZHMyTravelsViewController *contentViewController1 = [[ZHMyTravelsViewController alloc] init];
    UIViewController *contentViewController2 = [[UIViewController alloc] init];
    contentViewController2.view.backgroundColor = [UIColor systemBlueColor];
    UIViewController *contentViewController3 = [[UIViewController alloc] init];
    contentViewController3.view.backgroundColor = [UIColor systemGreenColor];
    self.contentViewControllers = @[contentViewController1, contentViewController2,contentViewController3];
    
    // 创建 page view controller
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    [self.pageViewController setViewControllers:@[contentViewController1] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    

    
    // 将 page view controller 添加到当前视图控制器
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    [self.view addSubview:self.segment];
    [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(48);
    }];
    
    UIImage *image = [[UIImage alloc]init];
    CGSize size = CGSizeMake(1, self.segment.intrinsicContentSize.height);
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.segment setBackgroundImage:scaledImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.segment setDividerImage:scaledImage forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    
    
    [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.segment.mas_bottom);
            make.left.right.bottom.mas_equalTo(0);
    }];
    
}


// MARK: 懒加载
- (UISegmentedControl *)segment{
    if(!_segment){
        NSArray *array = [NSArray arrayWithObjects:@"我的笔记",@"打卡",@"点赞记录" ,nil];
        _segment = [[UISegmentedControl alloc]initWithItems:array];
        _segment.selectedSegmentIndex = 0;
        
//        _segment.selectedSegmentTintColor = [UIColor blueColor];
       
        
        
        
        
        
        [_segment addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_segment];
    }
    return _segment;
}


- (UIPageViewController *)pageViewController{
    if(!_pageViewController){
        _pageViewController = [[UIPageViewController alloc]init];
        
    }
    return _pageViewController;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index == 0) {
        return nil;
    }
    return self.contentViewControllers[index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self.contentViewControllers indexOfObject:viewController];
    if (index == self.contentViewControllers.count - 1) {
        return nil;
    }
    return self.contentViewControllers[index + 1];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        UIViewController *currentViewController = [pageViewController.viewControllers firstObject];
        NSUInteger index = [self.contentViewControllers indexOfObject:currentViewController];
        self.segment.selectedSegmentIndex = index;
    }
}

#pragma mark - Action

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
    NSUInteger index = sender.selectedSegmentIndex;
    UIViewController *viewController = self.contentViewControllers[index];
    UIPageViewControllerNavigationDirection direction = index > [self.contentViewControllers indexOfObject:self.pageViewController.viewControllers.firstObject] ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
    [self.pageViewController setViewControllers:@[viewController] direction:direction animated:YES completion:nil];
}






@end
