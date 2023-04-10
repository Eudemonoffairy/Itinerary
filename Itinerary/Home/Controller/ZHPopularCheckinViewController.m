//
//  ZHPopularCheckinViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/4/3.
//

#import "ZHPopularCheckinViewController.h"
#import "ZHCheckinCell.h"
#import "ZHNetworkingUtils.h"
#import "ZHCheckInCellModel.h"
#import "ZHCheckinSetViewController.h"
@interface ZHPopularCheckinViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <ZHCheckInCellModel *>*dataArray;
@end

@implementation ZHPopularCheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUnfinishData];
    
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"base_back"] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor backButtonTextColor] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
    // Do any additional setup after loading the view.
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.bottom.mas_equalTo(self.self.view.mas_bottom);
    
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    //  由于首页没有显示导航栏，这里要显示
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
}

//  MARK: - 懒加载
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZHCheckinCell class] forCellReuseIdentifier:@"CheckinCell"];
        _tableView.rowHeight = 144;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}


//  MARK: - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZHCheckinCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CheckinCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ZHCheckinCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CheckinCell"];
    }
    ZHCheckInCellModel *checkinCellModel = self.dataArray[indexPath.item];
//    cell.unfinish = checkinCellModel.unfinish;
//    cell.finished = checkinCellModel.finished;
    [cell.scoreLabel setText:[NSString stringWithFormat:@"%ld / %ld", checkinCellModel.finished, checkinCellModel.unfinish]];
    cell.cellTitle.text = checkinCellModel.cityName;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}


-(void)tapAction{
    ZHCheckinSetViewController *checkinSetVC = [[ZHCheckinSetViewController alloc]init];
    [self.navigationController pushViewController:checkinSetVC animated:YES];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}


-(void)getFinishedData{
    [ZHNetworkingUtils requestWithURL:@"/usercheckin/getalldatabyid" method:RequestMethodPOST parameters:nil needToken:YES success:^(id  _Nonnull responseObject) {
            NSLog(@"");
        if([responseObject[@"code"] integerValue] == 200){
            
        }else{
            
        }
        } failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

-(void) getUnfinishData{
    [ZHNetworkingUtils requestWithURL:@"/checkin/getcitychecknums" method:RequestMethodGET parameters:nil needToken:YES
                              success:^(id  _Nonnull responseObject) {
        for(NSDictionary *data in responseObject[@"data"]){
            ZHCheckInCellModel *checkin = [[ZHCheckInCellModel alloc]init];
            checkin.cityID = [data[@"city"] integerValue];
            checkin.unfinish = [data[@"checknums"] integerValue];
            checkin.finished = 0;
            [self getCityData:checkin.cityID toCheckinModel:checkin];
            [self.dataArray addObject:checkin];
           
        }
        
        }
                              failure:^(NSError * _Nonnull error) {
            NSLog(@"%@", error);
        }];
}

-(void)getCityData:(NSInteger )cityID toCheckinModel:(ZHCheckInCellModel *)model{
    NSDictionary *params = @{
        @"cityId":[NSNumber numberWithInteger:cityID]
    };
    [ZHNetworkingUtils requestWithURL:@"/city/getOneCityById" method:RequestMethodGET parameters:params needToken:YES
                              success:^(id  _Nonnull responseObject) {
        NSDictionary *data = responseObject[@"data"];
        model.cityName = data[@"name"];
        [self.tableView reloadData];
        }
                              failure:^(NSError * _Nonnull error) {
            
        }];
}



-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
