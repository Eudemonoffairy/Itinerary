//
//  ZHHomeModuleView.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/30.
//

#import "ZHHomeModuleView.h"

@implementation ZHHomeModuleView

- (void)layoutSubviews{
    [self.moduleName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            if(self.titleHeight == 0){
                make.height.mas_equalTo(24);        //  设置默认值
            }else{
                make.height.mas_equalTo(self.titleHeight);
            }
    }];

    
    [self.moduleView mas_makeConstraints:^(MASConstraintMaker *make){
        make.top.mas_equalTo(self.moduleName.mas_bottom);
        make.bottom.left.right.mas_equalTo(0);
    }];

}

//  MARK: - 懒加载
- (ZHInsetLabel *)moduleName{
    if(!_moduleName){
        _moduleName = [[ZHInsetLabel alloc]init];
        [self addSubview:_moduleName];
    }
    return _moduleName;
}

- (void)setModuleView:(ZHModuleBaseView *)moduleView{
    _moduleView = moduleView;
    [self addSubview:_moduleView];
}

//  MARK: - 头文件方法
-(void) setTitle:(NSString *)title font:(UIFont *)font leftSpacing:(NSInteger)spacing{
    self.moduleName.text = title;
    self.moduleName.font = font;
    self.moduleName.leftEdge = spacing;
}

@end
