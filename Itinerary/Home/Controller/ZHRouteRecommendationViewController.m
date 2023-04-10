//
//  ZHRouteRecommendationViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/8.
//

#import "ZHRouteRecommendationViewController.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "ZHRecommenddationModel.h"
#import "UIButton+Utils.h"
#import "ZHCloseIconLabel.h"
@interface ZHRouteRecommendationViewController ()<AMapSearchDelegate, MAMapViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, ZHCloseIconLabelDelegate>
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray <ZHCloseIconLabel *>*labelArray;
@property (nonatomic, strong) NSMutableArray <ZHRecommenddationModel *> *dataArr;
@property (nonatomic, strong) NSMutableArray <ZHRecommenddationModel *>*searchResult;

@end

@implementation ZHRouteRecommendationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
            make.height.mas_equalTo(216);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.mapView.mas_bottom);
            make.height.mas_equalTo(56);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.scrollView.mas_bottom);
            make.height.mas_equalTo(64);
    }];
    [self updateScrollView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.searchBar.mas_bottom);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    //  由于首页没有显示导航栏，这里要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.search = [[AMapSearchAPI alloc]init];
        self.search.delegate = self;
    }
    return self;
}


//  MARK: - 懒加载
- (MAMapView *)mapView{
    if(!_mapView){
        _mapView = [[MAMapView alloc]init];
        _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
    }
    return _mapView;
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _searchBar.delegate = self;
        _searchBar.placeholder = @"输入关键字";
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"routeRecommentResult"];
//        _tableView.allowsSelection = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_scrollView];
        
    }
    return _scrollView;
}

- (NSMutableArray<ZHRecommenddationModel *> *)dataArr{
    if(!_dataArr){
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}


- (NSMutableArray<ZHCloseIconLabel *> *)labelArray{
    if(!_labelArray){
        _labelArray = [[NSMutableArray alloc]init];
    }
    return _labelArray;
}

- (NSMutableArray *)searchResult{
    if(!_searchResult){
        _searchResult = [[NSMutableArray alloc]init];
    }
    return _searchResult;
}

//  MARK: - ACTION
-(void)updateScrollView{
    //  清除所有子视图
    for(UIView *view in [self.scrollView subviews]){
        [view removeFromSuperview];
    }
    if(self.labelArray.count == 0){
        UILabel *tipLabel = [[UILabel alloc]init];
        tipLabel.text = @"  请先从下方搜索地点  ";
        tipLabel.textColor = [UIColor systemGrayColor];
        tipLabel.backgroundColor = [UIColor systemGray5Color];
        [self.scrollView addSubview:tipLabel];
        [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.mas_equalTo(self.scrollView);
                    make.centerY.mas_equalTo(self.scrollView);
        }];
    }else{
        for(int i=0; i<self.labelArray.count; i++){
            ZHCloseIconLabel *label = self.labelArray[i];
            [self.scrollView addSubview:label];
            if(i == 0){
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(self.scrollView.mas_left).mas_offset(12);
                }];
            }else{
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                                    make.left.mas_equalTo(self.labelArray[i -1].mas_right).mas_offset(12);
                }];
            }
            CGSize size = [label.titleLabel.text sizeWithAttributes:@{
                NSFontAttributeName:label.titleLabel.font}];
            
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.centerY.mas_equalTo(self.scrollView.mas_centerY);
                make.width.mas_equalTo(size.width + 48);
                make.height.mas_equalTo(32);
            }];
            label.backgroundColor = [UIColor themeColor];
            label.layer.cornerRadius = 12;
            label.layer.masksToBounds = YES;
//            [label sizeToFit];
//            label.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
//            [button sizeToFit];
            
            
            [self.view layoutIfNeeded];
            CGFloat width = label.frame.origin.x + label.frame.size.width + 12;
            self.scrollView.contentSize = CGSizeMake(width, 56);
        }
    }
}


-(void)tapCell:(UIGestureRecognizer *)tap{

    ZHRecommenddationModel *model = self.searchResult[ tap.view.tag];
    for(ZHRecommenddationModel *aModel in self.dataArr){
        if([aModel.recommendTitle isEqualToString:model.recommendTitle]){
            [self showInfo:@"该景点已经选取了哟！"];
            return;
        }
    }
    [self.dataArr addObject:model];
    
    
    ZHCloseIconLabel *aLabel = [[ZHCloseIconLabel alloc]init];
    aLabel.titleLabel.textColor = [UIColor whiteColor];
    [aLabel.titleLabel setText:model.recommendTitle];
    aLabel.delegate = self;
    [self.labelArray addObject:aLabel];
  
    [self updateScrollView];
    NSLog(@"点击%@", model.recommendTitle);
    [self updateMapView];
    
//    清空搜索结果表
    [self.searchResult removeAllObjects];
    [self.tableView reloadData];
//  将 searchBar 的 text 清除，placehold 改为 ”试试下面的推荐结果吧“
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"试试下面推荐的结果吧";
    
//  根据 dataArr 最后一个对象的经纬度获得周边好玩的点
    [self searchPoiByLatitude:model.latitude longitude:model.longitude];
    
    
}


//  MARK: - UITableViewDelegate & UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeRecommentResult" forIndexPath:indexPath];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"routeRecommentResult"];
    }
    cell.textLabel.text = self.searchResult[indexPath.item].recommendTitle;
    cell.tag = indexPath.item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResult.count;
}


//  MARK: - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *poiIdentifier = @"poiIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:poiIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:poiIdentifier];
        }

        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return poiAnnotationView;
    }

    return nil;
}

//  MARK: - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    if(self.searchBar.text.length == 0) {
        return;
    }
    [self searchPoiByKeyword:self.searchBar.text];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    
    if (response.pois.count == 0)
    {
        return;
    }
    
    [self.searchResult removeAllObjects];
    for(AMapPOI *poi in response.pois){
        ZHRecommenddationModel *model = [[ZHRecommenddationModel alloc]init];
        model.recommendTitle = poi.name;
        model.longitude = poi.location.longitude;
        model.latitude = poi.location.latitude;
        [self.searchResult addObject:model];
    }
    [self.tableView reloadData];
}

#pragma mark - Utility
/* 根据关键字来搜索POI. */
- (void)searchPoiByKeyword:(NSString *)keyword
{
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = keyword;
    request.city = @"广州";
    request.sortrule            = -1;
    request.showFieldsType = AMapPOISearchShowFieldsTypeAll;
    request.offset = 50;
    [self.search AMapPOIKeywordsSearch:request];
    
}

//  根据经纬度来搜索 POI
- (void)searchPoiByLatitude:(CGFloat)latitude longitude:(CGFloat)longitude
{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    
    request.location            = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];
    request.keywords            = @"景点";
    /* 按照距离排序. */
    request.sortrule            = -1;
    request.showFieldsType      = AMapPOISearchShowFieldsTypeAll;
//    request.offset = 50;
    [self.search AMapPOIAroundSearch:request];
}

//  MARK: -ZHCloseIconLabelDelegate
- (void)closeAction:(ZHCloseIconLabel *)label{
//    NSLog(@"?1008");
    
    NSUInteger idx  = [self.labelArray indexOfObject:label];
    [self.labelArray removeObject:label];
    [self.dataArr removeObjectAtIndex:idx];
    [self updateScrollView];
    [self updateMapView];
    
    
    if(self.dataArr.count == 0){
        self.searchBar.text = @"";
        self.searchBar.placeholder = @"输入关键字";
    }
    
    
    
}

-(void)updateMapView{
//    if(self.dataArray.count != 0){
//        for()
//    }
    [self.mapView removeAnnotations:self.mapView.annotations];
    NSMutableArray *poiAnnotatiions = [NSMutableArray array];
    
    
    for(ZHRecommenddationModel *model in self.dataArr){
        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate = CLLocationCoordinate2DMake(model.latitude,model.longitude);
            pointAnnotation.title = model.recommendTitle;
        [poiAnnotatiions addObject:pointAnnotation];
//            [self.mapView addAnnotation:pointAnnotation];
    }
    
    [self.mapView addAnnotations:poiAnnotatiions];
    if(poiAnnotatiions.count == 1){
        [self.mapView setCenterCoordinate:[poiAnnotatiions[0] coordinate]];
    }else{
        [self.mapView showAnnotations:poiAnnotatiions animated:NO];
    }
    
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
@end

