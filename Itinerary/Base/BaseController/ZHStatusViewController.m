//
//  ZHStatusViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/21.
//

#import "ZHStatusViewController.h"


@interface ZHStatusViewController ()
@property (nonatomic) UIImageView *statusImage;
@property (nonatomic) UILabel *infoLabel;
@end

@implementation ZHStatusViewController

- (UIImageView *)statusImage{
    if(!_statusImage){
        _statusImage = [[UIImageView alloc]init];
        [self.view addSubview:_statusImage];
    }
    return _statusImage;
}
- (UILabel *)infoLabel{
    if(!_infoLabel){
        _infoLabel = [[UILabel alloc]init];
        _infoLabel.textColor = [UIColor auxiliaryTextColor];
        [self.view addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (void)showStatus:(VIEW_STATUS)status info:(NSString *)info{
    self.statusImage.hidden = NO;
    self.infoLabel.hidden = NO;
    switch (status) {
        case SEARCHING_STATSUS:
            [self.statusImage setImage:[UIImage imageNamed:@"status_search"]];
            self.infoLabel.text = info;
            break;
            
        default:
            break;
    }
  
    CGFloat scale = self.statusImage.image.size.height / self.statusImage.image.size.width;
    [self.statusImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(-64);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.6);
            make.height.mas_equalTo(self.statusImage.mas_width).multipliedBy(scale);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.top.mas_equalTo(self.statusImage.mas_bottom).mas_offset(12);
    }];

    self.statusImage.layer.zPosition = MAXFLOAT;
    self.infoLabel.layer.zPosition = MAXFLOAT;
}

-(void)hideStatuView{
    self.statusImage.hidden = YES;
    self.infoLabel.hidden = YES;
}

@end
