//
//  ZHStatisticBar.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/6.
//

#import "ZHStatisticBar.h"
#import "ZHTitleNContentLabel.h"
@implementation ZHStatisticBar

- (void)drawRect:(CGRect)rect{
    if(self.dataDic){
        NSArray *keyArr = [self.dataDic allKeys];
        NSInteger dataCount = [keyArr count];
        
        CGFloat w = self.frame.size.width;
        CGFloat h = self.frame.size.height;
        for(int i = 0; i < dataCount; i++){
            ZHTitleNContentLabel *label  = [[ZHTitleNContentLabel alloc]initWithTitle:keyArr[i] Content:self.dataDic[keyArr[i]] isVertical:YES];
            
            [self addSubview:label];
            label.frame = CGRectMake(i * w/dataCount, 0, w/dataCount, h);
        }
    }
}

- (instancetype)initWithDataDic:(NSDictionary *)dataDic{
    self = [super init];
    self.dataDic = dataDic;
    return self;
}

- (instancetype)initWithTitle:(NSString *)itemTitle itemContent:(NSString *)itemContent{
    NSDictionary *dic = @{itemTitle:itemContent};
    return [self initWithDataDic:dic];
}


- (NSDictionary *)dataDic{
    if(!_dataDic){
        _dataDic = [NSDictionary dictionary];
    }
    return _dataDic;
}



@end
