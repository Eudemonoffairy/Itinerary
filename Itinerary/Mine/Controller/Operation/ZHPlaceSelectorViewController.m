//
//  ZHPlaceSelectorViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/13.
//

#import "ZHPlaceSelectorViewController.h"
#import "ZHNetworkingUtils.h"
#import "ZHPlace.h"

@interface ZHPlaceSelectorViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UIView *selectedView;         //  显示已选择的地点

@property (nonatomic ,strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) NSMutableArray<ZHPlace *> *searchedData;

@end

@implementation ZHPlaceSelectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self getAllPlace];
    self.title = @"选择景点";
    // Do any additional setup after loading the view.
    
    //  点击背景落下键盘
    UITapGestureRecognizer *tapEndEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapEndEdit.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEndEdit];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.view.mas_top).mas_offset(24);
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(12);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.searchBar.mas_bottom);
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.view);
    }];
}



-(void)getAllPlace{
    [ZHNetworkingUtils requestWithURL:@"/place/getalldata" method:RequestMethodGET parameters:nil needToken:NO success:^(id  _Nonnull responseObject) {
//        NSLog(@"请求成功%@",responseObject);
        [self dataToPlace:responseObject[@"data"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"请求错误：%@", error);
    }];
}

-(void)dataToPlace:(NSArray *)datas{
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for(NSDictionary *data in datas){
        ZHPlace *place = [[ZHPlace alloc]init];
        place.placeId = [data[@"id"] integerValue];
        place.placeName = data[@"name"];
        place.cityid = (NSInteger)data[@"cityid"];
        [result addObject:place];
    }
    self.dataArr = [result copy];
}




//  MARK: 懒加载

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"选择景点";
        _titleLabel.font = [UIFont boldFontSize_17];
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UISearchBar *)searchBar{
    if(!_searchBar){
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索景点";
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSArray *)dataArr{
    if(!_dataArr){
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (NSMutableArray *)searchedData{
    if(!_searchedData){
        _searchedData = [[NSMutableArray alloc]init];
    }
    return _searchedData;
}


// MARK: UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchText.length > 0){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"placeName CONTAINS[c] %@", searchText];
//        NSMutableArray *arr = [[NSMutableArray alloc]init];
        self.searchedData = [[self.dataArr filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else{
        [self.searchedData removeAllObjects];
    }
    [self.tableView reloadData];
}

//  MARK: UITabelDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchedData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"searchPlace";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.tag = indexPath.item;
    cell.textLabel.text = self.searchedData[indexPath.row].placeName;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//  MARK: Action
//  实现点击背景落下键盘
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)tapAction:(UITapGestureRecognizer *)tap{

    NSInteger index = tap.view.tag;
    ZHPlace *place = self.searchedData[index];
    NSNotification *notice = [NSNotification notificationWithName:SELECT_PLACE object:nil userInfo:@{@"place":place}];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
