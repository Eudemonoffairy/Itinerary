//
//  ZHOperationTableViewCell.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/20.
//

#import "ZHOperationTableViewCell.h"
#import "UIButton+Utils.h"
@implementation ZHOperationTableViewCell

- (void)drawRect:(CGRect)rect{
    NSInteger operationCount = [self.titles count];
    NSInteger w = self.frame.size.width / operationCount;
    for(int i = 0; i< operationCount;i++){
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aButton setVerticalWithNormalTitle:self.titles[i] font:UIFont.fontSize_14 normalImgage:[UIImage imageNamed:self.images[i]]];
        [self addSubview:aButton];
        [aButton mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.mas_left).offset(i * w);
                    make.top.bottom.mas_equalTo(0);
                    make.width.mas_equalTo(w);
        }];
        [aButton setNormalTitleColor:[UIColor blackColor]];
    }
}





- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
