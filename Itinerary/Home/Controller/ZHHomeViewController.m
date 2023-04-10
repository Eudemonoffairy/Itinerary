//
//  ZHHomeViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/29.
//

#import "ZHHomeViewController.h"
#import "ZHCarouselX.h"
#import "UIButton+Utils.h"
#import "ZHHomeModuleView.h"
#import "ZHHomeModuleCollectionView.h"
#import "ZHLocationUtils.h"
#import "ZHTouristAttrationsViewController.h"
#import "ZHPopularCheckinViewController.h"
#import "ZHEntertainmentViewController.h"
#import "ZHRouteRecommendationViewController.h"
@interface ZHHomeViewController ()
//  内容页面，由于模块可能超过实际长度，所以使用 scrollView
@property (nonatomic, strong) UIScrollView* homeContentView;

//  顶部页面，包括欢迎语以及定位
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UILabel *welcomeLabel;    //  欢迎语
@property (nonatomic, strong) UIButton *positionButton; //  定位按钮

//  banner 视图
@property (nonatomic, strong) ZHCarouselX *carousel;

//  操作区 - 景点游览，热门打卡，路线推荐，娱乐餐饮
@property (nonatomic, strong) UIView *operationView;

//  热门景点
@property (nonatomic, strong) ZHHomeModuleView * destination;

//  热门话题
@property (nonatomic, strong) ZHHomeModuleView * topic;

@end

@implementation ZHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
//    [[ZHLocationUtils sharedInstance] startLocation];
    
    
    [self.homeContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    //  布局顶部视图
    [self layoutTopView];
    //  轮播图
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_bottom).mas_offset(12);
            make.left.mas_equalTo(self.homeContentView.mas_left).mas_offset(12);
            make.width.mas_equalTo(self.homeContentView.mas_width).mas_offset(-24);
            make.height.mas_equalTo(196);
    }];
    self.carousel.imageArray = @[
        [UIImage imageNamed:@"home_banner_1"],
        [UIImage imageNamed:@"home_banner_2"],
        [UIImage imageNamed:@"home_banner_3"],
        [UIImage imageNamed:@"home_banner_4"],
    ];
   
    //  中部金刚区
    [self layoutOperationView];
    
    //  热门景点
    [self.destination mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.homeContentView.mas_left);
            make.width.mas_equalTo(self.homeContentView.mas_width);
            make.top.mas_equalTo(self.operationView.mas_bottom).mas_offset(8);
            make.height.mas_equalTo(216);
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    //  隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

// MARK: - 懒加载
- (UIScrollView *)homeContentView{
    if(!_homeContentView){
        _homeContentView = [[UIScrollView alloc]init];
        [self.view addSubview:_homeContentView];
    }
    return _homeContentView;
}

- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor backgroundColor];
        [self.homeContentView addSubview:_topView];
    }
    return _topView;
}

- (UILabel *)welcomeLabel{
    if(!_welcomeLabel){
        _welcomeLabel = [[UILabel alloc]init];
        _welcomeLabel.text = @"Hello! 旅行者";
        _welcomeLabel.font = [UIFont boldFontSize_22];
        [self.topView addSubview:_welcomeLabel];
    }
    return _welcomeLabel;
}

- (UIButton *)positionButton{
    if(!_positionButton){
        _positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_positionButton setImage:[UIImage imageNamed:@"home_position"] forState:UIControlStateNormal];
        _positionButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_positionButton setTitle:@"未知" forState:UIControlStateNormal];
        _positionButton.titleLabel.font = [UIFont fontSize_14];
        [_positionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.topView addSubview:_positionButton];
    }
    return _positionButton;
}

- (ZHCarouselX *)carousel{
    if(!_carousel){
        _carousel = [[ZHCarouselX alloc]initWithFrame:CGRectZero autoScroll:YES];
        [self.homeContentView addSubview:_carousel];
        _carousel.currentPageColor = [UIColor secondaryColor];
        _carousel.defaultPageColor = [UIColor bandColor];
        _carousel.layer.cornerRadius = 24;
        _carousel.layer.masksToBounds = YES;
    }
    return _carousel;
}

- (UIView *)operationView{
    if(!_operationView){
        _operationView = [[UIView alloc]init];
        [self.homeContentView addSubview:_operationView];
    }
    return _operationView;
}

- (ZHHomeModuleView *)destination{
    if(!_destination){
        _destination = [[ZHHomeModuleView alloc]init];
        [_destination setTitle:@"热门景点" font:[UIFont boldFontSize_20] leftSpacing:12];
        _destination.titleHeight = 40;
        ZHHomeModuleCollectionView *destinationView = [[ZHHomeModuleCollectionView alloc]init];
        [destinationView setDataArray:@[@"",@"",@"",@""]];
        [_destination setModuleView:destinationView];
        
        [self.homeContentView addSubview:_destination];
        
    }
    return _destination;
}

//  MARK: - layout
-(void)layoutTopView{
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeContentView.mas_left);
        make.top.mas_equalTo(self.homeContentView.mas_top);
        make.width.mas_equalTo(self.homeContentView.mas_width);
        make.height.mas_equalTo(48);
    }];
    
    [self.welcomeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.topView.mas_left).mas_offset(12);
        make.width.mas_equalTo(self.topView.mas_width).multipliedBy(0.5);
        make.centerY.mas_equalTo(self.topView.mas_centerY);
    }];
    
    //  定位
//    [self.positionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(self.topView.mas_right).mas_offset(-12);
//        make.centerY.mas_equalTo(self.topView.mas_centerY);
//    }];
//    self.positionButton.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
//    [self.positionButton sizeToFit];
}

-(void)layoutOperationView{
    [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.homeContentView.mas_left).mas_offset(12);
        make.width.mas_equalTo(self.homeContentView.mas_width).mas_offset(-24);
        make.top.mas_equalTo(self.carousel.mas_bottom).mas_offset(8);
        make.height.mas_equalTo(80);
    }];
    self.operationView.userInteractionEnabled = YES;
    CGFloat verticalSpacing = 56;
    
    //  景点游览
    UIButton *touristAttrations = [UIButton buttonWithType:UIButtonTypeCustom];
    touristAttrations.tag = 0;
    [touristAttrations setVerticalWithNormalTitle:@"景点游览" font:[UIFont boldFontSize_14] normalImgage:[UIImage imageNamed:@"home_operation_1"] normalColor:[UIColor H1Color] verticalSpacing:verticalSpacing];
    [touristAttrations addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  热门打卡
    UIButton *popularCheckin = [UIButton buttonWithType:UIButtonTypeCustom];
    popularCheckin.tag = 1;
    [popularCheckin setVerticalWithNormalTitle:@"热门打卡" font:[UIFont boldFontSize_14] normalImgage:[UIImage imageNamed:@"home_operation_2"] normalColor:[UIColor H1Color] verticalSpacing:verticalSpacing];
   
    [popularCheckin addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    //  路线推荐
    UIButton *routeRecommendation = [UIButton buttonWithType:UIButtonTypeCustom];
    routeRecommendation.tag = 2;
    [routeRecommendation setVerticalWithNormalTitle:@"路线推荐" font:[UIFont boldFontSize_14] normalImgage:[UIImage imageNamed:@"home_operation_3"] normalColor:[UIColor H1Color] verticalSpacing:verticalSpacing];
    [routeRecommendation addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //  娱乐餐饮
    UIButton *entertainment = [UIButton buttonWithType:UIButtonTypeCustom];
    entertainment.tag = 3;
    [entertainment setVerticalWithNormalTitle:@"娱乐餐饮" font:[UIFont boldFontSize_14] normalImgage:[UIImage imageNamed:@"home_operation_4"] normalColor:[UIColor H1Color] verticalSpacing:verticalSpacing];
    [entertainment addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.operationView addSubview:touristAttrations];
    [self.operationView addSubview:popularCheckin];
    [self.operationView addSubview:routeRecommendation];
    [self.operationView addSubview:entertainment];
    
    [touristAttrations mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.operationView.mas_left);
            make.centerY.mas_equalTo(self.operationView.mas_centerY);
            make.width.mas_equalTo(self.operationView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(self.operationView.mas_height);
    }];
    
    [popularCheckin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(touristAttrations.mas_right);
            make.centerY.mas_equalTo(self.operationView.mas_centerY);
            make.width.mas_equalTo(self.operationView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(self.operationView.mas_height);
    }];
    
    
    [routeRecommendation mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(popularCheckin.mas_right);
            make.centerY.mas_equalTo(self.operationView.mas_centerY);
            make.width.mas_equalTo(self.operationView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(self.operationView.mas_height);
    }];
    
    [entertainment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(routeRecommendation.mas_right);
            make.centerY.mas_equalTo(self.operationView.mas_centerY);
            make.width.mas_equalTo(self.operationView.mas_width).multipliedBy(0.25);
            make.height.mas_equalTo(self.operationView.mas_height);
    }];
}

-(void)buttonAction:(UIButton *)button{
    switch (button.tag) {
        case 0:{
            ZHTouristAttrationsViewController *aViewController = [[ZHTouristAttrationsViewController alloc]init];
            aViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aViewController animated:YES];
            break;
        }
        case 1:{
            ZHPopularCheckinViewController *aViewController = [[ZHPopularCheckinViewController alloc]init];
            aViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aViewController animated:YES];
            break;
        }
        case 2:{
            ZHRouteRecommendationViewController *aViewController = [[ZHRouteRecommendationViewController alloc]init];
            aViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aViewController animated:YES];
            break;
        }
        case 3:{
            ZHEntertainmentViewController *aViewController = [[ZHEntertainmentViewController alloc]init];
            aViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aViewController animated:YES];
            break;
        }
            
        default:
            break;
    }
}

@end
