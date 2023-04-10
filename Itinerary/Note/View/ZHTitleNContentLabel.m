//
//  ZHTitleNContentLabel.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import "ZHTitleNContentLabel.h"

@implementation ZHTitleNContentLabel
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addSubview:self.labelTitle];
    [self addSubview:self.labelContent];
    
    if(self.isVertical){
        //  如果是垂直显示（居中）
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).mas_offset(4);
            make.centerX.mas_equalTo(self.mas_centerX);
            
        }];
        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.labelTitle.mas_bottom).mas_offset(4);
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }else{
        //  如果是水平显示（居左）
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [self.labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.labelTitle.mas_right).mas_offset(12);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
    }
    
    self.labelTitle.font = [UIFont boldFontSize_14];
    self.labelContent.font = [UIFont boldFontSize_17];
    
    
}

#pragma mark - 初始化
///  初始化方法
- (instancetype)initWithTitle:(NSString *)labelTitle Content:(NSString *)labelContent isVertical:(BOOL)isVertical{
    self = [super init];
    self.labelTitle.text = labelTitle;
    self.labelContent.text = labelContent;
    self.isVertical = isVertical;
    return self;
}

///  初始化方法，默认为横向显示
- (instancetype)initWithTitle:(NSString *)labelTitle Content:(NSString *)labelContent{
    return [self initWithTitle:labelTitle Content:labelContent isVertical:NO];
}


#pragma mark - 懒加载
- (UILabel *)labelTitle{
    if(!_labelTitle){
        _labelTitle = [[UILabel alloc]init];
        _labelTitle.textColor = [UIColor statisticTextColor];
    }
    return _labelTitle;
}

- (UILabel *)labelContent{
    if(!_labelContent){
        _labelContent = [[UILabel alloc]init];
        _labelContent.textColor = [UIColor statisticTextColor];
    }
    return _labelContent;
}

@end
