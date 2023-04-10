//
//  ZHHomeTouristTableViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/31.
//  首页 - 景点浏览 - 景点列表

#import "ZHHomeTouristTableViewController.h"
#import "ZHHomeTouristCell.h"
#import "ZHAttraction.h"
#import "ZHAttractionViewController.h"
#import <SDWebImage/SDWebImage.h>
@interface ZHHomeTouristTableViewController ()
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation ZHHomeTouristTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[ZHHomeTouristCell class] forCellReuseIdentifier:@"TouristCell"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.rowHeight = 96;
}

- (instancetype)init{
    if(self = [super init]){
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(notificationAction:) name:MAP_ATTRATION object:nil];
    }
    return self;
}

-(void)notificationAction:(NSNotification *)notification{
    self.dataArray= notification.userInfo[@"attractions"];
    [self.tableView reloadData];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (ZHHomeTouristCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHHomeTouristCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TouristCell" forIndexPath:indexPath];
    if(!cell){
        cell = [[ZHHomeTouristCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TouristCell"];
    }
    if(self.dataArray.count != 0){
        ZHAttraction *attraction = self.dataArray[indexPath.item];
        [cell.cellImage sd_setImageWithURL:attraction.images[0]];
        cell.cellTitle.text = attraction.name;
        cell.cellRate.text = attraction.rating;
        cell.tag = indexPath.item;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCell:)];
        [cell addGestureRecognizer:tap];
    }
    return cell;
}

-(void) tapCell:(UIGestureRecognizer *)tap{
    NSInteger index = tap.view.tag;
    __block NSInteger completedCount = 0;
    ZHAttraction *attraction = self.dataArray[index];
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];

    for(NSString *imgUrl in attraction.images){
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imgUrl] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [imgArr addObject:image];
            completedCount ++;
            if(completedCount == attraction.images.count){
                ZHAttractionViewController *attractionVC = [[ZHAttractionViewController alloc]initWithAttraction:attraction];
                [attractionVC.carousel setImageArray:imgArr];
                [self.navigationController pushViewController:attractionVC animated:YES];
            }
        }];
    }
}


@end
