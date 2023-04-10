//
//  ZHPositionButtonBar.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/17.
//

#import "ZHPositionButtonBar.h"
#import "ZHMapUtil.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface ZHPositionButtonBar()<AMapSearchDelegate>
@property (nonatomic, strong) UIView *containView;
@end

@implementation ZHPositionButtonBar

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    NSMutableArray<UIButton *> *buttonArr = [[NSMutableArray alloc]init];
    for(int i = 0; i < self.positionArr.count - 1; i++){
        NSString *positionStr = [NSString stringWithFormat:@"%@ → %@",self.positionArr[i].placeName , self.positionArr[i+1].placeName] ;
        UIButton *positionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [positionButton setTitle:positionStr forState:UIControlStateNormal];
        [positionButton setBackgroundColor:[UIColor systemRedColor]];
        positionButton.tag =  i;
        [buttonArr addObject:positionButton];
    }
    NSInteger gap = 12;
    for(int i = 0; i < buttonArr.count; i++){
        UIButton *aButton = buttonArr[i];
        [self.containView addSubview:aButton];
        
        aButton.backgroundColor = [UIColor systemBlueColor];
        aButton.layer.cornerRadius = 12;
        aButton.layer.masksToBounds = YES;
        [aButton addTarget:self action:@selector(loadRouteInfo:) forControlEvents:UIControlEventTouchUpInside];
        CGSize titleSize = [aButton.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:aButton.titleLabel.font.fontName size:aButton.titleLabel.font.pointSize] }];
        
        titleSize.width += 48;
        
        [aButton mas_makeConstraints:^(MASConstraintMaker *make) {
            if(i == 0){
                make.left.mas_equalTo(self.containView.mas_left).mas_offset(gap);
            }
            else{
                make.left.mas_equalTo(buttonArr[i - 1].mas_right).mas_offset(gap);
            }
            make.top.mas_equalTo(self.containView).mas_offset(12);
            make.bottom.mas_equalTo(self.containView).mas_offset(-12);
            make.width.mas_equalTo( titleSize.width );
        }];
    }
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
            make.height.equalTo(self);
    }];
    
    [self.containView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(buttonArr[buttonArr.count - 1].mas_right);
    }];
   
}



- (instancetype)initWithPositions:(NSArray *)positions{
    if(self = [super init]){
        self.positionArr = positions;
        return self;
    }
    return nil;
}

- (UIView *)containView{
    if(!_containView){
        _containView = [[UIView alloc]init];
        [self addSubview:_containView];
    }
    return _containView;
}


-(void)loadRouteInfo:(UIButton *)button{
    NSInteger buttonIndex = button.tag;
    ZHMapUtil *mapUtil = [ZHMapUtil sharedInstance];
    [mapUtil getRoutesStart:CLLocationCoordinate2DMake(self.positionArr[buttonIndex].latitude, self.positionArr[buttonIndex].longitude) destination:CLLocationCoordinate2DMake(self.positionArr[buttonIndex + 1].latitude,self.positionArr[buttonIndex + 1].longitude) mode:self.mode];
    
    
    
//    NSNotification *notice = [NSNotification notificationWithName:MAP_ROUTES object:nil userInfo:@{@"Routes":[NSNumber numberWithInteger:buttonIndex]}];
//    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}




@end
