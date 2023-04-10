//
//  ZHCarouselX.m
//  Itinerary
//
//  Created by Martin Liu on 2023/3/30.
//

#import "ZHCarouselX.h"

@interface ZHCarouselX ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;         //  滚动视图
@property (nonatomic, strong) UIPageControl *pageControl;       //  分页控制器
@property (nonatomic, strong) NSTimer *timer;                   //  定时器
@property (nonatomic, assign) NSInteger currentPageIndex;       //  当前页索引
@property (nonatomic, assign) BOOL autoScroll;
@end

@implementation ZHCarouselX

- (instancetype)initWithFrame:(CGRect)frame autoScroll:(BOOL)autoScroll{
    if(self = [self initWithFrame:frame]){
        self.autoScroll = autoScroll;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        //  滚动视图
        self.scrollView = [[UIScrollView alloc]init];
        self.scrollView.delegate = self;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.bounces = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];

        //  分页控制器
        self.pageControl = [[UIPageControl alloc]init];
        [self addSubview:self.pageControl];

       //  在滚动视图中添加图片视图
        for(int i=0; i<3; i++){
            UIImageView *image = [[UIImageView alloc]init];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
        
            [self.scrollView addSubview:image];
        }

        self.currentPageIndex = 0;

        //  TODO:  未定义定时器
//        self.timer
        
    }
    return self;
}

//  MARK: - 定时器
-(void) startAutoCarousel{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void) stopAutoCarousel {
    [self.timer invalidate];
    self.timer = nil;
}
//
//-(void)autoCarousel {
//    self ne
//}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.pageControl.numberOfPages = self.imageArray.count;
    if(self.currentPageColor){
        self.pageControl.currentPageIndicatorTintColor = self.currentPageColor;
    }else{
        self.pageControl.currentPageIndicatorTintColor = [UIColor systemBlueColor];
    }
    if(self.defaultPageColor){
        self.pageControl.pageIndicatorTintColor = self.defaultPageColor;
    }else{
        self.pageControl.pageIndicatorTintColor = [UIColor systemGray4Color];
    }

    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-4);
            make.height.mas_offset(24);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(0);
            make.bottom.mas_equalTo(self.mas_bottom);
    }];

    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;

    //  设置 contentSize
    self.scrollView.contentSize = CGSizeMake(width * 3, height);

    //  设置三张图片的位置， 并为三个图片添加点击事件
    for(int i = 0; i < 3; i++){
        UIImageView *image = self.scrollView.subviews[i];
        image.frame = CGRectMake(i*width, 0, width, height);
        [image setUserInteractionEnabled:YES];
        //  TODO: 添加点击事件
    }
    self.scrollView.contentOffset = CGPointMake(width, 0);

    if(self.autoScroll){
        [self startAutoCarousel];
    }
    
}


//  MARK: - 懒加载
- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    self.pageControl.numberOfPages = imageArray.count;
    self.pageControl.currentPage = 0;
    [self setContent];
}

//  MARK: - ACTION
-(void) setContent{
    //  设置三个 imageButton 的显示图片
    for(int i = 0; i < self.scrollView.subviews.count; i++){
        //  取出三个 image
        UIImageView *image = self.scrollView.subviews[i];
        NSInteger index = self.pageControl.currentPage;
        
        if(i == 0){
            //  第一个 image
            index --;
        }else if(i == 2){
            //  第三个 image
            index ++;
        }
        
        // 无限循环效果
        if(index < 0){
            index = self.pageControl.numberOfPages -1;
        }else if(index == self.pageControl.numberOfPages){
            index = 0;
        }
        image.tag = index;
        image.image = self.imageArray[index];
    }
}

-(void)updateContent{
    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
    [self setContent];
    self.scrollView.contentOffset = CGPointMake(width, 0);
    
}

#pragma mark - UIScrollViewDelegate
//  拖拽的时候执行哪些操作
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //  拖动的时候， 那张图片最靠中间， 也就是偏移量最小， 就滑到哪页
    //  用来设置当前页
    NSInteger page = 0;
    //  用来拿最小偏移量
    CGFloat minDistance = MAXFLOAT;
    //  遍历三个 imageView, 看哪个图片偏移量最小，也就是最靠中间
    for(int i = 0; i < self.scrollView.subviews.count; i++){
        UIImageView *image = self.scrollView.subviews[i];
        CGFloat distance = 0;
        distance = ABS(image.frame.origin.x - scrollView.contentOffset.x);
        if(distance < minDistance){
            minDistance = distance;
            page = image.tag;
        }
    }
    self.pageControl.currentPage = page;
}

//  结束拖拽的时候更新 image 内容
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self updateContent];
}

//  scroll 滚动动画结束的时候更新 image 内容
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self updateContent];
}

//通过改变contentOffset * 2换到下一张图片
- (void)nextImage {
    CGFloat width = self.bounds.size.width;
    [self.scrollView setContentOffset:CGPointMake(2 * width, 0) animated:YES];
    
}



//- (void)imageClick:(UITapGestureRecognizer *)recognizer {
//    if ([self.delegate respondsToSelector:@selector(carouselView:toBigimg:)])
//    {
//        UIImageView *imageView = [[UIImageView alloc]init];
//        imageView = (UIImageView *)recognizer.view;
//        [self.delegate carouselView:self toBigimg:imageView.image];
//    }
//}




@end
