//
//  ZHCarousel.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/5.
//

#import "ZHCarousel.h"

static const int imageBtnCount = 3;
@interface ZHCarousel()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView*scrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
@property (nonatomic, assign) BOOL autoScroll;

@end
@implementation ZHCarousel

- (instancetype)initWithFrame:(CGRect)frame autoScroll:(BOOL)autoscroll{
    if(self = [self initWithFrame:frame]){
        self.autoScroll = autoscroll;
    }
    return self;
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    if(self= [super initWithFrame:frame]){
        //  定义一个 scrollView, 最主要的轮播控件
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.delegate = self;
        //  不显示滚动条
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        //  需要分页
        scrollView.pagingEnabled = YES;
        //  不需要回弹
        scrollView.bounces = NO;
        
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        //  添加图片按钮，用于响应点击事件
        for(int i = 0; i < imageBtnCount; i++){
            UIImageView *image = [[UIImageView alloc]init];
            image.contentMode = UIViewContentModeScaleAspectFit;
            [scrollView addSubview:image];
        }
        //  添加 pageControl
        UIPageControl *pageControl = [[UIPageControl alloc]init];
        if (@available(iOS 14.0, *)) {
            [pageControl setBackgroundStyle:UIPageControlBackgroundStyleProminent];
        } else {
            // Fallback on earlier versions
        }
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        //  设置控制器不能用来点击
        self.pageControl.enabled = NO;
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
//  布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-2);
        make.height.mas_offset(26);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.mas_equalTo(self.mas_bottom).mas_offset(-2);
    }];
    
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height - 30;
    
    //  设置 contentSize
    self.scrollView.contentSize = CGSizeMake(width * imageBtnCount, height);
    
    //  设置三张图片的位置， 并为三个按钮添加点击事件
    for(int i = 0; i< imageBtnCount; i++){
        UIImageView *image = self.scrollView.subviews[i];
        image.frame = CGRectMake(i * width, 0, width, height);
        [image setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageClick:)];
        [image addGestureRecognizer:tap];
    }
    //  设置 contentOffset， 显示最中间的图片
    self.scrollView.contentOffset = CGPointMake(width, 0);

}

- (void)setCurrentPageColor:(UIColor *)currentPageColor{
    _currentPageColor = currentPageColor;
    self.pageControl.currentPageIndicatorTintColor = currentPageColor;
}


#pragma mark - 懒加载
- (void)setPageColor:(UIColor *)pageColor{
    _pageColor = pageColor;
    self.pageControl.pageIndicatorTintColor = pageColor;
}

//  根据传入的图片数组设置图片
-(void)setImageArr:(NSArray *)imageArr{
    _imageArr = imageArr;
    //  pageControl 的页数就是图片的个数
    self.pageControl.numberOfPages = imageArr.count;
    //  默认一开始显示的是第 0 页
    self.pageControl.currentPage = 0;
    //  设置图片显示内容
    [self setContent];
}

//  设置显示内容
-(void) setContent{
    //  设置三个 imageButton 的显示图片
    for(int i = 0; i < self.scrollView.subviews.count; i++){
        //  取出三个 imageButton
        UIImageView *image = self.scrollView.subviews[i];
        //  这个是为了给图片做索引用的
        NSInteger index = self.pageControl.currentPage;
        
        if(i == 0){
            //  第一个 imageButton，隐藏在当前显示的 imageButton 的左侧
            index --;   //  当前索引 减 1 就是第一个 imagebutton 的图片索引
        }else if(i == 2){
            //  第三个 imageButton, 隐藏在当前显示的 imageButton 的右侧
            index ++;   //  当前页索引加1 就是第三个 imageButton 的图片索引
        }

        //  无限循环效果
        if(index < 0){
            //  当上面 index 为 0 的时候，在向右拖动，左侧图片显示， 这个时候显示最后一张图片
            index = self.pageControl.numberOfPages - 1;
        }else if(index == self.pageControl.numberOfPages){
            //  当上面 index 超过最大 page 索引的时候， 显示第一张照片
            index = 0;
        }
        image.tag = index;
        //  用上面处理好的索引给 imageButton 设置图片
        image.image = self.imageArr[index];
    }
}

-(void)updateContent{
    CGFloat width = self.bounds.size.width;
//    CGFloat height = self.bounds.size.height;
    [self setContent];
    //  唯一跟设置显示不同的就是重新设置偏移量，让他永远用中间的按钮显示图片，滑动之后就偷偷地把偏移位置设置回去，这样就实现了永远用中间的按钮显示图片
    //  设置偏移量在中间
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

- (void)imageClick:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(carouselView:toBigimg:)])
    {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView = (UIImageView *)recognizer.view;
        [self.delegate carouselView:self toBigimg:imageView.image];
    }
}


@end
