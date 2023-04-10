//
//  ZHAddTravelsViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/22.
//  创建游记界面

#import "ZHAddTravelsViewController.h"
#import <TZImagePickerController.h>
#import "ZHInsetLabel.h"
#import "WMZDialog.h"
#import "ZHPlace.h"
#import "ZHNetworkingUtils.h"
#import "ZHPlaceSelectorViewController.h"
#import "QiniuUtils.h"

static NSInteger imgWidth = 96;
static NSString *contentPlaceHold =  @"记录一下旅游时的美好心情吧！";
@interface ZHAddTravelsViewController ()<TZImagePickerControllerDelegate, UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong)UIButton *addPhotos;
@property (nonatomic, strong)UIScrollView *imgScrollView;
@property (nonatomic, strong)NSMutableArray<UIImage *> *imgArr;
@property (nonatomic, strong)UITextField *traversTitle;
@property (nonatomic, strong)UITextView *traversContent;
@property (nonatomic, strong)UIScrollView *placeScrollView;
@property (nonatomic, strong)UIButton *addPlaces;
@property (nonatomic, strong)NSMutableArray<ZHPlace *> *placeArr;
@property (nonatomic, strong)NSMutableArray<UILabel *> *labelArr;
@property (nonatomic, strong)ZHInsetLabel *time;
@property (nonatomic, assign)NSInteger timeInt;
@property (nonatomic, strong)ZHInsetLabel *money;
@property (nonatomic, strong) UIButton *postButton;
@end

@implementation ZHAddTravelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建游记";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notificationAction:) name:SELECT_PLACE object:nil];
    
    //  点击背景落下键盘
    UITapGestureRecognizer *tapEndEdit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapEndEdit.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapEndEdit];
    
    //  图片滚动条
    [self.imgScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(imgWidth + 24);
    }];
    [self drawImageScroll];
    
    //  标题栏
    [self.traversTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.imgScrollView.mas_bottom).mas_offset(12);
        make.height.mas_offset(32);
    }];
    
    UIView *aline = [[UIView alloc]init];
    [self.view addSubview:aline];
    aline.backgroundColor = [UIColor systemGray5Color];
    [aline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
            make.top.mas_equalTo(self.traversTitle.mas_bottom).mas_offset(12);
            make.height.mas_offset(1);
    }];
    
    //  游记内容
    [self.traversContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
        make.top.mas_equalTo(aline.mas_bottom).mas_offset(12);
        make.height.mas_offset(96);
    }];
    
    UIView *bline = [[UIView alloc]init];
    [self.view addSubview:bline];
    bline.backgroundColor = [UIColor systemGray5Color];
    [bline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
        make.top.mas_equalTo(self.traversContent.mas_bottom).mas_offset(12);
        make.height.mas_offset(1);
    }];
    
    UILabel *placeLabel = [[UILabel alloc]init];
    [self.view addSubview:placeLabel];
    placeLabel.text = @"景点：";
    [placeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(bline.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    //  景点滚动条
    [self.placeScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(placeLabel.mas_right);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(bline.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    [self drawPlaceScroll];
    
    //  建议游玩时间
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(12);
        make.top.mas_equalTo(self.placeScrollView.mas_bottom).mas_offset(12);
        make.width.mas_greaterThanOrEqualTo(256);
        make.right.mas_lessThanOrEqualTo(self.view.mas_right).mas_offset(-12);
    }];
    //  预计花费
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(12);
        make.top.mas_equalTo(self.time.mas_bottom).mas_offset(12);
        make.width.mas_greaterThanOrEqualTo(256);
        make.right.mas_lessThanOrEqualTo(self.view.mas_right).mas_offset(-12);
    }];

    //  创建
    [self.postButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(12);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-12);
        make.height.mas_offset(48);
        make.bottom.mas_equalTo(self.view.mas_bottom).mas_offset(-24);
    }];
}

//  MARK: 懒加载

- (UIButton *)addPhotos{
    if(!_addPhotos){
        _addPhotos = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPhotos setImage:[UIImage imageNamed:@"travels_add"] forState:UIControlStateNormal];
        _addPhotos.backgroundColor = [UIColor systemGray6Color];
        [_addPhotos addTarget:self action:@selector(addImageAction) forControlEvents:UIControlEventTouchUpInside];
        [self.imgScrollView addSubview:_addPhotos];
        _addPhotos.layer.cornerRadius = 12;
        _addPhotos.layer.masksToBounds = YES;
    }
    return _addPhotos;
}

- (NSMutableArray<ZHPlace *> *)placeArr{
    if(!_placeArr){
        _placeArr = [[NSMutableArray alloc]init];
    }
    return _placeArr;
}

- (UIScrollView *)imgScrollView{
    if(!_imgScrollView){
        _imgScrollView = [[UIScrollView alloc]init];
        [self.view addSubview:_imgScrollView];
        _imgScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _imgScrollView;
}

- (UITextField *)traversTitle{
    if(!_traversTitle){
        _traversTitle = [[UITextField alloc]init];
        _traversTitle.placeholder = @"好的标题能够让更多人看到哦~";
        _traversTitle.font = [UIFont fontSize_20];
        [self.view addSubview:_traversTitle];
        
    }
    return _traversTitle;
}

- (UITextView *)traversContent{
    if(!_traversContent){
        _traversContent = [[UITextView alloc]init];
        _traversContent.text = contentPlaceHold;
        _traversContent.textColor = [UIColor systemGray3Color];
        _traversContent.font = [UIFont fontSize_17];
        _traversContent.delegate = self;
        [self.view addSubview:_traversContent];
    }
    return _traversContent;
}

- (ZHInsetLabel *)time{
    if(!_time){
        _time = [[ZHInsetLabel alloc]init];
        _time.text = @"建议游玩时长：";
        _time.layer.cornerRadius = 8;
        _time.layer.masksToBounds = YES;
        _time.topEdge = 8;
        _time.leftEdge = 8;
        _time.bottomEdge = 8;
        _time.backgroundColor = [UIColor systemGray6Color];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTimeDialog)];
        [_time addGestureRecognizer:tap];
        _time.userInteractionEnabled = YES;
        [self.view addSubview:_time];
        
    }
    return _time;
}

- (ZHInsetLabel *)money{
    if(!_money){
        _money = [[ZHInsetLabel alloc]init];
        _money.text = @"预计花费：";
        _money.layer.cornerRadius = 8;
        _money.layer.masksToBounds = YES;
        _money.topEdge = 8;
        _money.leftEdge = 8;
        _money.bottomEdge = 8;
        _money.backgroundColor = [UIColor systemGray6Color];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showMoneyDialog)];
        [_money addGestureRecognizer:tap];
        _money.userInteractionEnabled = YES;
        [self.view addSubview:_money];
    }
    return _money;
}

- (UIButton *)postButton{
    if(!_postButton){
        _postButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_postButton setTitle:@"创建" forState:UIControlStateNormal];
        _postButton.backgroundColor = [UIColor themeColor];
        _postButton.layer.cornerRadius = 12;
        _postButton.layer.masksToBounds = YES;
        [_postButton addTarget:self action:@selector(postTravelsAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_postButton];
    }
    return _postButton;
}

- (UIScrollView *)placeScrollView{
    if(!_placeScrollView){
        _placeScrollView = [[UIScrollView alloc]init];
        _placeScrollView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_placeScrollView];
    }
    return _placeScrollView;
}

- (UIButton *)addPlaces{
    if(!_addPlaces){
        _addPlaces = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addPlaces setImage:[UIImage imageNamed:@"circle_add"] forState:UIControlStateNormal];
        _addPlaces.backgroundColor = [UIColor systemGray6Color];
        [_addPlaces addTarget:self action:@selector(toTravelSelector) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_addPlaces];
    }
    return _addPlaces;
}

- (NSMutableArray<UILabel *> *)labelArr{
    if(!_labelArr){
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}


// MARK: Action
-(void)addImageAction{
    TZImagePickerController *imagePickerVC = [[TZImagePickerController alloc]initWithMaxImagesCount:9 delegate:self];
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

-(void)showTimeDialog{
    NSString *timeStr = @"00:00";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"HH:mm"];
    
    Dialog()
   .wEventOKFinishSet(^(id anyID, id otherData) {
       self.time.text = [NSString stringWithFormat:@"建议游玩时长：%@ h %@ min", anyID[0], anyID[1]];
   })
   //默认选中时间 不传默认是当前时间
   .wDefaultDateSet([dateFormatter dateFromString:timeStr])
   .wDateTimeTypeSet(@"HH:mm")
   .wTypeSet(DialogTypeDatePicker)
   .wMessageColorSet(DialogDarkColor(DialogColor(0x333333), DialogColor(0xffffff)))
   .wMessageFontSet(16)
   .wStart();
}

-(void)showMoneyDialog{
    Dialog().wTypeSet(DialogTypeWrite)
    .wEventOKFinishSet(^(id anyID, id otherData) {
        NSLog(@"%@",anyID);
        self.money.text = [NSString stringWithFormat:@"预计花费：￥%@", anyID];
    })
    .wMessageSet(@"预计花费")
    //  编辑框最大行数 1
    .wWirteTextMaxLineSet(1)
    //  编辑框可输入的文本最大文本长度 defualt -1 不限制
    .wWirteTextMaxNumSet(10)
    .wWirteKeyBoardTypeSet(UIKeyboardTypeNumberPad)
    .wStart();
}


-(void)postTravelsAction{
    NSString *errInfo = nil;
    if(self.imgArr == nil || [self.imgArr count] == 0){
        //  如果没有选中图片
        errInfo = @"未选中图片！";
    }else if([self.traversTitle.text isEqualToString:@""]){
        //  没有标题
        errInfo = @"未输入标题！";
    }else if([self.traversContent.text isEqualToString:@""]){
        //  没有内容
        errInfo = @"未输入内容！";
    }else if([self.time.text isEqual:@"建议游玩时长："]){
        //  没有输入建议游玩时间！
        errInfo = @"有建议游玩时间更好哦~";
    }else if([self.money.text isEqual:@"预计花费："]){
        errInfo = @"告诉大家这个路线需要花费多少吧！";
    }else{
        //  信息齐全可以发布
        
        
        NSLog(@"创建中！");
        //  先将图片上传到七牛云并返回地址
        NSMutableArray *urlArr = [[NSMutableArray alloc]init];
        
        //    for(UIImage *image in self.imgArr){
        //        [urlArr addObject:[QiniuUtils uploadImg:image]];
        //    }
        
        
        [QiniuUtils uploadImages:[self.imgArr copy] complete:^(NSArray<NSString *> * _Nonnull imageKeys) {
            NSString *imgStr = [QINIU_URL stringByAppendingFormat:@"/%@", imageKeys[0]];
            for(int i = 1; i<imageKeys.count;i++){
                
                imgStr = [imgStr stringByAppendingFormat:@"|%@", [QINIU_URL stringByAppendingFormat:@"/%@", imageKeys[i]]];
            }
            NSString *placeStr = @"";
            for(ZHPlace *place in self.placeArr){
                placeStr = [placeStr stringByAppendingFormat:@"%ld&", place.placeId];
            }
            //  去除最后一个&
//            placeStr = [placeStr substringToIndex:placeStr.length -1];
            
            NSDictionary *params = @{
                @"content": self.traversContent.text,
                @"expense": self.money.text,
                @"image":imgStr,
                @"duration": [NSNumber numberWithInt:200],
                @"title":self.traversTitle.text,
                @"placeid":placeStr,
                @"tip":@"无",
                @"cityid":[NSNumber numberWithInt:0],
            };
            
            
            [ZHNetworkingUtils requestWithURL:@"/note/addNote" method:RequestMethodPOST parameters:params needToken:YES success:^(id  _Nonnull responseObject) {
                NSLog(@"%@", responseObject);
                [self autoShowInfo:@"创建成功！"];
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(NSError * _Nonnull error) {
                [self autoShowInfo:@"创建失败！"];
            }];
            
        }];
        
        
        //
        //    if(urlArr.count != self.imgArr.count){
        //        NSLog(@"未上传完成");
        //    }else{
        //        NSLog(@"上传完成");
        //    }
        
    }
}

-(void)toTravelSelector{
    ZHPlaceSelectorViewController *placeSelector = [[ZHPlaceSelectorViewController alloc]init];
    [self.navigationController presentViewController:placeSelector animated:YES completion:nil];
}

// MARK: TZImagePickerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    self.imgArr = [photos mutableCopy];
    NSLog(@"imgArr 的照片数量 %ld", self.imgArr.count);
    [self drawImageScroll];
}

-(void)drawImageScroll{
    NSInteger count = self.imgArr.count;
    //  将图片添加到图片滚动条
    for(int i = 0; i < count; i++){
        UIImageView *aImageView = [[UIImageView alloc]initWithImage:self.imgArr[i]];
        [self.imgScrollView addSubview:aImageView];
        [aImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgScrollView.mas_left).mas_offset(i * (imgWidth + 12) + 12);
            make.top.mas_equalTo(self.imgScrollView.mas_top).mas_offset(12);
            make.width.height.mas_equalTo(imgWidth);
        }];
        aImageView.layer.cornerRadius = 12;
        aImageView.layer.masksToBounds = YES;
    }
    if(count < 9){
        [self.addPhotos mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.imgScrollView.mas_left).mas_offset(count * (imgWidth + 12) + 12);
            make.top.mas_equalTo(self.imgScrollView.mas_top).mas_offset(12);
            make.width.height.mas_equalTo(imgWidth);
        }];
    }
    self.imgScrollView.contentSize = CGSizeMake(count == 9? count*(imgWidth+ 12) + 12:(count+1)*(imgWidth+ 12) + 12, imgWidth + 24);
}

-(void)drawPlaceScroll{
    if(self.placeArr.count){
        ZHInsetLabel *aLabel = [[ZHInsetLabel alloc]init];
        [self.placeScrollView addSubview:aLabel];
        [aLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if(self.labelArr.count == 0){
                //  第一个元素
                make.left.mas_equalTo(self.placeScrollView.mas_left).mas_offset(12);
            }else{
                make.left.mas_equalTo(self.labelArr.lastObject.mas_right).mas_offset(12);
            }
            make.centerY.mas_equalTo(self.placeScrollView.mas_centerY);
        }];
        [self.labelArr addObject:aLabel];
        aLabel.text = self.placeArr.lastObject.placeName;
        aLabel.layer.cornerRadius = 4;
        aLabel.layer.masksToBounds = YES;
        aLabel.backgroundColor = [UIColor systemGray5Color];
        aLabel.rightEdge = 4;
        aLabel.leftEdge = 4;
        aLabel.topEdge = 4;
        aLabel.bottomEdge = 4;
    }

    [self.addPlaces mas_remakeConstraints:^(MASConstraintMaker *make) {
        if(self.labelArr.count == 0){
            make.left.mas_equalTo(self.placeScrollView.mas_left).mas_offset(12);
        }else{
            make.left.mas_equalTo(self.labelArr.lastObject.mas_right).mas_offset(12);
        }
        make.top.mas_equalTo(self.placeScrollView.mas_top).mas_offset(12);
        make.width.height.mas_equalTo(36);
    }];
    self.addPlaces.layer.cornerRadius = 18;
    self.addPlaces.layer.masksToBounds = YES;
    
    [self.view layoutIfNeeded];
    NSInteger width = self.addPlaces.frame.origin.x + self.addPlaces.frame.size.width;
    self.placeScrollView.contentSize = CGSizeMake(width, 60);
}

//  MARK: UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([self.traversContent.text isEqualToString:contentPlaceHold]){
        self.traversContent.text = @"";
        self.traversContent.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if([self.traversContent.text isEqualToString:@""]){
        self.traversContent.text = contentPlaceHold;
        self.traversContent.textColor = [UIColor systemGray4Color];
    }
}

//  MARK: UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return  [textField resignFirstResponder];
}

//  实现点击背景落下键盘
-(void)viewTapped:(UITapGestureRecognizer*)tap
{
    [self.view endEditing:YES];
}

-(void)notificationAction:(NSNotification *)notification{
    ZHPlace *place = notification.userInfo[@"place"];
    BOOL isExist = NO;
    for (ZHPlace *aPlace in self.placeArr){
        if([aPlace.placeName isEqualToString: place.placeName]){
            isExist = YES;
            break;
        }
    }
    if(isExist){
        [self autoShowInfo:@"已存在"];
    }else{
        [self.placeArr addObject:place];
        [self drawPlaceScroll];
    }
}

@end
