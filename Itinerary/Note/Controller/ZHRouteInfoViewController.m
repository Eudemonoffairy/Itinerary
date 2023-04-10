//
//  ZHRouteInfoViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/18.
//

#import "ZHRouteInfoViewController.h"
#import "ZHSchemeViewController.h"

@interface ZHRouteInfoViewController ()
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation ZHRouteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(48);
    }];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.width.mas_equalTo(SCREEN_WIDTH / 2);
        make.height.mas_equalTo(48);
    }];
    [self.positionBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.leftButton.mas_bottom);
        make.height.mas_equalTo(48);
    }];
    
    ZHSchemeViewController *schemeVC = [[ZHSchemeViewController alloc]init];
    [self addChildViewController:schemeVC];
    [self.view addSubview:schemeVC.view];
    [schemeVC didMoveToParentViewController:self];
    [schemeVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.positionBar.mas_bottom);
    }];
    schemeVC.view.backgroundColor = [UIColor orangeColor];
    
   
    
}


#pragma mark - 懒加载
///  驾车
- (UIButton *)leftButton{
    if(!_leftButton){
        _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftButton setImage:[UIImage imageNamed:@"icon_map_left_0"] forState:UIControlStateNormal];
        [_leftButton setImage:[UIImage imageNamed:@"icon_map_left_1"] forState:UIControlStateSelected];
        [_leftButton setBackgroundColor:[UIColor whiteColor]];
        [_leftButton setTitle:@"驾车" forState:UIControlStateNormal];
        [_leftButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateSelected];
        [_leftButton setTitleColor:[UIColor systemGray4Color] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_leftButton];
        [self.view layoutIfNeeded];
    }
    return _leftButton;
}

//  公交/步行
- (UIButton *)rightButton{
    if(!_rightButton){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightButton setImage:[UIImage imageNamed:@"icon_map_right_0"] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"icon_map_right_1"] forState:UIControlStateSelected];
        [_rightButton setBackgroundColor:[UIColor whiteColor]];
        [_rightButton setTitle:@"公交/步行" forState:UIControlStateNormal];
        [_rightButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateSelected];
        [_rightButton setTitleColor:[UIColor systemGray4Color] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_rightButton];
        [self.view layoutIfNeeded];
    }
    return _rightButton;
}
- (UIView *)contentView{
    if(!_contentView){
        _contentView = [[UIView alloc]init];
        [self.view addSubview:_contentView];
    }
    return _contentView;
}

-(void)leftAction{
    self.contentView.backgroundColor = [UIColor systemRedColor];
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    self.leftButton.backgroundColor = [UIColor whiteColor];
    self.rightButton.backgroundColor = [UIColor systemGray2Color];
    self.positionBar.mode = 0;
    [self drawLeftView];

}
-(void)rightAction{
    self.contentView.backgroundColor = [UIColor systemBlueColor];
    self.leftButton.selected = NO;
    self.rightButton.selected = YES;
    self.rightButton.backgroundColor = [UIColor whiteColor];
    self.leftButton.backgroundColor = [UIColor systemGray2Color];
    self.positionBar.mode = 1;

}


- (ZHPositionButtonBar *) positionBar{
    if(!_positionBar){
        _positionBar = [[ZHPositionButtonBar alloc]init];
        _positionBar.positionArr = self.placeArr;
        _positionBar.backgroundColor = [UIColor whiteColor];
        _positionBar.contentSize = _positionBar.frame.size;
        _positionBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.contentView addSubview:_positionBar];
        
    }
    return _positionBar;
}

-(void)drawLeftView{

    
}



@end
