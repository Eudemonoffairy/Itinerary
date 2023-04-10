//
//  ZHNoteViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/4.
//

#import "ZHNoteViewController.h"
#import "ZHTitleNContentLabel.h"
#import "ZHNoteContentCollectionViewController.h"
@interface ZHNoteViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate>
@property (nonatomic, strong)UITableViewController *resultTable;
@property (nonatomic, strong)UISearchController *searchController;
///  数据源数组
@property (nonatomic, strong)NSMutableArray *datas;
///  搜索结果数组
@property (nonatomic, strong)NSMutableArray *results;
@end

@implementation ZHNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游记";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    ZHNoteContentCollectionViewController *ViewC = [[ZHNoteContentCollectionViewController alloc]initWithCollectionViewLayout:layout];
    [self addChildViewController:ViewC];
    [self.view addSubview:ViewC.view];
    [ViewC didMoveToParentViewController:self];
    [ViewC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT + STATUS_BAR_HEIGHT );
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(TABBAR_HEIGHT);
    }];
   
    UITableViewController *searchResultsController = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.tintColor = [UIColor blueColor];
    
    self.searchController.searchBar.delegate = self;
    self.navigationItem.searchController = self.searchController;
    self.definesPresentationContext = YES;
}

#pragma mark - 懒加载
- (UITableViewController *)resultTable{
    if(!_resultTable){
        _resultTable = [[UITableViewController alloc]init];
        _resultTable.tableView.delegate = self;
        _resultTable.tableView.dataSource = self;
    }
    return _resultTable;
}

- (NSMutableArray *)datas{
    if(!_datas){
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)results{
    if(!_results){
        _results = [NSMutableArray array];
    }
    return _results;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    //  当用户开始编辑搜索栏时调用
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    //  当用户点击搜索栏的取消按钮时调用
    self.results = [NSMutableArray array];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    //  当用户键入搜索栏时调用
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchText = searchController.searchBar.text;
    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@", searchText];
    self.results = [self.datas filteredArrayUsingPredicate:searchPredicate];
}

@end
