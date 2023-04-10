//
//  ZHAttractionViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//  首页 - 景点浏览 - 景点列表 - 景点 Cell - 景点详细页

#import "ZHAttractionViewController.h"

@interface ZHAttractionViewController ()
@property (nonatomic, strong) UIView *infoView;
@end

@implementation ZHAttractionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.carousel];
    [self.view addSubview:self.infoView];
    [self.infoView addSubview:self.name];
    [self.infoView addSubview:self.address];
    [self.infoView addSubview:self.tel];
    [self.infoView addSubview:self.opentime];
    [self.infoView addSubview:self.cost];
    [self.infoView addSubview:self.rating];
    [self.carousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(256);
    }];
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.carousel.mas_bottom).mas_offset(-24);
        make.left.mas_equalTo(self.view.mas_left);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    self.infoView.layer.cornerRadius = 24;
    self.infoView.layer.masksToBounds = YES;
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.infoView).mas_offset(24);
            make.right.mas_equalTo(self.infoView).mas_offset(-24);
            make.top.mas_equalTo(self.infoView).mas_offset(24);
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name);
            make.right.mas_equalTo(self.name);
            make.top.mas_equalTo(self.name.mas_bottom).mas_offset(16);
    }];
    
    [self.tel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name);
            make.right.mas_equalTo(self.name);
            make.top.mas_equalTo(self.address.mas_bottom).mas_offset(8);
    }];
    
    [self.opentime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name);
            make.right.mas_equalTo(self.name);
            make.top.mas_equalTo(self.tel.mas_bottom).mas_offset(8);
    }];
    
    [self.cost mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name);
            make.right.mas_equalTo(self.name);
            make.top.mas_equalTo(self.opentime.mas_bottom).mas_offset(8);
    }];
    
    [self.rating mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.name);
            make.right.mas_equalTo(self.name);
            make.top.mas_equalTo(self.cost.mas_bottom).mas_offset(8);
    }];
    
}

//  MARK: - 懒加载
- (ZHCarouselX *)carousel{
    if(!_carousel){
        _carousel = [[ZHCarouselX alloc]initWithFrame:CGRectZero autoScroll:NO];
    }
    return _carousel;
}

- (UIView *)infoView{
    if(!_infoView){
        _infoView = [[UIView alloc]init];
        _infoView.backgroundColor = [UIColor backgroundColor];
    }
    return _infoView;
}

- (UILabel *)name{
    if(!_name){
        _name = [[UILabel alloc]init];
        _name.font = [UIFont boldFontSize_22];
        _name.textColor = [UIColor titleColor];
    }
    return _name;
}

- (ZHInsetLabel *)address{
    if(!_address){
        _address = [[ZHInsetLabel alloc]init];
        _address.lineBreakMode = NSLineBreakByWordWrapping;
        _address.numberOfLines = 3;
        _address.backgroundColor = [UIColor auxiliaryTextColor];
        _address.textColor = [UIColor whiteColor];
        _address.leftEdge = 8;
        _address.rightEdge = 8;
        _address.topEdge = 8;
        _address.bottomEdge = 8;
        _address.layer.cornerRadius = 8;
        _address.layer.masksToBounds = YES;
    }
    return _address;
}

- (ZHInsetLabel *)tel{
    if(!_tel){
        _tel = [[ZHInsetLabel alloc]init];
        _tel.lineBreakMode = NSLineBreakByWordWrapping;
        _tel.numberOfLines = 2;
        _tel.backgroundColor = [UIColor auxiliaryTextColor];
        _tel.textColor = [UIColor whiteColor];
        _tel.leftEdge = 8;
        _tel.rightEdge = 8;
        _tel.topEdge = 8;
        _tel.bottomEdge = 8;
        _tel.layer.cornerRadius = 8;
        _tel.layer.masksToBounds = YES;
    }
    return _tel;
}

- (ZHInsetLabel *)opentime{
    if(!_opentime){
        _opentime = [[ZHInsetLabel alloc]init];
        _opentime.lineBreakMode = NSLineBreakByWordWrapping;
        _opentime.numberOfLines = 0;
        _opentime.backgroundColor = [UIColor auxiliaryTextColor];
        _opentime.textColor = [UIColor whiteColor];
        _opentime.leftEdge = 8;
        _opentime.rightEdge = 8;
        _opentime.topEdge = 8;
        _opentime.bottomEdge = 8;
        _opentime.layer.cornerRadius = 8;
        _opentime.layer.masksToBounds = YES;
    }
    return _opentime;
}

- (ZHInsetLabel *)cost{
    if(!_cost){
        _cost = [[ZHInsetLabel alloc]init];
        _cost.backgroundColor = [UIColor auxiliaryTextColor];
        _cost.textColor = [UIColor whiteColor];
        _cost.leftEdge = 8;
        _cost.rightEdge = 8;
        _cost.topEdge = 8;
        _cost.bottomEdge = 8;
        _cost.layer.cornerRadius = 8;
        _cost.layer.masksToBounds = YES;
    }
    return _cost;
}

- (ZHInsetLabel *)rating{
    if(!_rating){
        _rating = [[ZHInsetLabel alloc]init];
        _rating.backgroundColor = [UIColor auxiliaryTextColor];
        _rating.textColor = [UIColor whiteColor];
        _rating.leftEdge = 8;
        _rating.rightEdge = 8;
        _rating.topEdge = 8;
        _rating.bottomEdge = 8;
        _rating.layer.cornerRadius = 8;
        _rating.layer.masksToBounds = YES;
    }
    return _rating;
}

- (instancetype)initWithAttraction:(ZHAttraction *)attraction{
    if(self = [super init]){
        [self setAttraction:attraction];
    }
    return self;
}


- (void)setAttraction:(ZHAttraction *)attraction{
    self.name.text = attraction.name;
    self.address.text = attraction.address;
    if(attraction.tel && ![attraction.tel isEqualToString:@""]){
        self.tel.text = @"景点电话: \n";
        self.tel.text = [self.tel.text stringByAppendingString: [attraction.tel stringByReplacingOccurrencesOfString:@";" withString:@"；"]];
    }else{
        self.tel.hidden = YES;
    }
    if(attraction.opentime && ![attraction.opentime isEqualToString:@""]){
        self.opentime.text = [NSString stringWithFormat:@"营业时间:\n%@",attraction.opentime];
    }
    else{
        self.opentime.hidden = YES;
    }
    if(attraction.cost && ![attraction.cost isEqualToString:@""]){
        self.cost.text = [NSString stringWithFormat:@"人均:  ￥%@", attraction.cost];
    }else{
        self.cost.hidden = YES;
    }
    if(attraction.rating && ![attraction.rating isEqualToString:@""]){
        self.rating.text = [NSString stringWithFormat:@"评分:  %@", attraction.rating];
    }else{
        self.rating.hidden = YES;
    }
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}




@end
