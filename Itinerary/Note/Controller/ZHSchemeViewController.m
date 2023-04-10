//
//  ZHSchemeViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//  方案视图控制器

#import "ZHSchemeViewController.h"

@interface ZHSchemeViewController ()<UIGestureRecognizerDelegate>
//  记录 section 是否展开
@property (nonatomic, strong) NSMutableArray *isExpandArr;
@property (nonatomic, strong) NSArray *keyArray;
@end

@implementation ZHSchemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];

}

//  初始化数据
-(void)initData{
    self.keyArray = [self.sourceDic allKeys];
    for(int i = 0; i < self.keyArray.count; i++){
        [self.isExpandArr addObject:@"0"];
    }
    
}

#pragma mark - 懒加载
- (NSMutableDictionary *)sourceDic{
    if(!_sourceDic){
        _sourceDic = [NSMutableDictionary dictionary];
    }
    return _sourceDic;
}

- (NSMutableArray *)isExpandArr{
    if(!_isExpandArr){
        _isExpandArr = [NSMutableArray array];
    }
    return _isExpandArr;
}

- (NSArray *)keyArray{
    if(!_keyArray){
        _keyArray = [NSArray array];
    }
    return _keyArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.keyArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.isExpandArr[section]isEqualToString:@"1"]){
        //  已展开
        NSArray *valueArray = self.sourceDic[self.keyArray[section]];
        return valueArray.count;
    }
    else{
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]init];
    UILabel *headerTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 28)];
    headerTitle.textColor = [UIColor blackColor];
    headerTitle.text = self.keyArray[section];
    [headerView addSubview:headerTitle];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    tap.delegate = self;
    [headerView addGestureRecognizer:tap];
    headerView.tag = section;
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"schemeTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.sourceDic[self.keyArray[indexPath.section]][indexPath.row];
    
    return cell;
}

-(void)tapAction:(UITapGestureRecognizer *)tap{
    if([self.isExpandArr[tap.view.tag] isEqualToString:@"0" ]){
        // to 展开
        [self.isExpandArr replaceObjectAtIndex:tap.view.tag withObject:@"1"];
    }else{
        [self.isExpandArr replaceObjectAtIndex:tap.view.tag withObject:@"0"];
    }
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:tap.view.tag];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    NSNumber *routeIndex = [NSNumber numberWithInteger:tap.view.tag];
    NSNotification *notice = [NSNotification notificationWithName:SHOW_IN_MAP object:nil userInfo:@{@"routeIndex":routeIndex}];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}

-(void)selectCell:(UITapGestureRecognizer *)tap{
    NSNumber *routeIndex = [NSNumber numberWithInteger:tap.view.tag];
    NSNotification *notice = [NSNotification notificationWithName:MAP_ROUTES object:nil userInfo:@{@"routeIndex":routeIndex}];
    [[NSNotificationCenter defaultCenter] postNotification:notice];
}



@end
