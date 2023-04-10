//
//  ZHCommentViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//  评论区

#import "ZHCommentViewController.h"
#import "ZHCommentView.h"
#import "ZHInsetLabel.h"
#import "ZHNetworkingUtils.h"
@interface ZHCommentViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGFloat currOffsetY;

@end

@implementation ZHCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;     //  高度设置为自适应
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.commentArr.count;
}


- (ZHCommentView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHCommentView *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *data = self.commentArr[indexPath.item];
    if(!cell){
       cell = [[ZHCommentView alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.commentText.text = data[@"content"];
    cell.commentTime.text = data[@"date"];
    
    NSDictionary *params = @{
        @"id":[NSNumber numberWithInteger:[data[@"userid"] integerValue]],
    };
    [ZHNetworkingUtils requestWithURL:@"/user/getuserinfobyid" method:RequestMethodGET parameters:params needToken:YES success:^(id  _Nonnull responseObject) {
        NSLog(@"%@", responseObject);
        cell.userName.text = responseObject[@"data"][@"name"];
        [cell.userAvatar sd_setImageWithURL:[NSURL URLWithString:responseObject[@"data"][@"image"]] placeholderImage:[UIImage imageNamed:@"normal_avatar"]];
    } failure:^(NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
    
    return cell;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _currOffsetY = scrollView.contentOffset.y;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(!self.canSlide){
        scrollView.contentOffset = CGPointMake(0, scrollView.contentOffset.y == 0? 0 :_currOffsetY);
    }
    _currOffsetY = scrollView.contentOffset.y;
    if(scrollView.contentOffset.y < 0){
        self.canSlide = NO;
        scrollView.contentOffset = CGPointZero;
        //  到顶通知父视图改变状态
        if(self.slideDragBlock){
            self.slideDragBlock();
        }
    }
    scrollView.showsVerticalScrollIndicator = NO;
}


@end
