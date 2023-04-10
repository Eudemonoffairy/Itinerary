//
//  ZHEditUserInfoViewController.m
//  Itinerary
//
//  Created by Martin Liu on 2023/2/26.
//  用户编辑资料页面

#import "ZHEditUserInfoViewController.h"
#import "ZHEditInfoItem.h"
#import "WMZDialog.h"
#import "ZHChangePasswordViewController.h"
#import "QiniuUtils.h"
@interface ZHEditUserInfoViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong)UITableView *infoTableView;
@property (nonatomic, strong)UIButton *logoutButton;
@property (nonatomic, strong)ZHInsetLabel *leftAavatarTitle;
@property (nonatomic, strong) UIImageView *rightAvatarView;
@property (nonatomic, strong) UIView *avatarContentView;


@end

@implementation ZHEditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector( saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
    
    [self.avatarContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(NAVIGATION_BAR_HEIGHT);
        make.height.mas_equalTo(72);
    }];
    [self.leftAavatarTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarContentView.mas_left);
            make.centerY.mas_equalTo(self.avatarContentView.mas_centerY);
    }];
    [self.rightAvatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.avatarContentView.mas_right).mas_offset(-12);
            make.centerY.mas_equalTo(self.avatarContentView.mas_centerY);
            make.width.height.mas_equalTo(56);
    }];
    self.rightAvatarView.layer.cornerRadius = 28;
    self.rightAvatarView.layer.masksToBounds = YES;
    
    
 
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.avatarContentView.mas_bottom);
       
    }];
    [self.view layoutIfNeeded];
    
    
    [self.infoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.height.mas_equalTo(self.infoTableView.contentSize.height + 4);
    }];
    
    ZHInsetLabel *describeText = [[ZHInsetLabel alloc]init];
    describeText.text = @"除修改密码外，其他信息需要保存才能完成修改。";
    describeText.leftEdge = 12;
    describeText.lineBreakMode = NSLineBreakByWordWrapping;
    describeText.numberOfLines = 0;
    describeText.textColor = [UIColor systemGray4Color];
    [self.view addSubview:describeText];

    
    [describeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.top.mas_equalTo(self.infoTableView.mas_bottom).mas_offset(12);
    }];
    
    
    
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.width.mas_equalTo(self.view.mas_width).multipliedBy(0.64);
        make.top.mas_equalTo(describeText.mas_bottom).mas_offset(64);
        make.height.mas_equalTo(48);
    }];
    self.logoutButton.layer.cornerRadius = 24;
    self.logoutButton.layer.masksToBounds = YES;
    
    
}

//  MARK: 懒加载
- (UITableView *)infoTableView{
    if(!_infoTableView){
        _infoTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _infoTableView.delegate = self;
        _infoTableView.dataSource = self;
        _infoTableView.scrollEnabled = NO;
        _infoTableView.layer.borderWidth = 1;
        _infoTableView.layer.borderColor = [[UIColor systemGray5Color] CGColor];
        [self.view addSubview:_infoTableView];
    }
    return _infoTableView;
}

- (ZHUser *)aUser{
    if(!_aUser){
        _aUser = [[ZHUser alloc]init];
    }
    return _aUser;
}

- (ZHInsetLabel *)leftAavatarTitle{
    if(!_leftAavatarTitle){
        _leftAavatarTitle = [[ZHInsetLabel alloc]init];
        _leftAavatarTitle.leftEdge = 12;
        _leftAavatarTitle.text = @"头像";
        [self.avatarContentView addSubview:_leftAavatarTitle];
    }
    return _leftAavatarTitle;
}

- (UIImageView *)rightAvatarView{
    if(!_rightAvatarView){
        _rightAvatarView = [[UIImageView alloc]init];

        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.aUser.image] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                    [_rightAvatarView setImage:image];
                }];
        
        [self.avatarContentView addSubview:_rightAvatarView];
    }
    return _rightAvatarView;
}

- (UIView *)avatarContentView{
    if(!_avatarContentView){
        _avatarContentView = [[UIView alloc]init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAvatar)];
        [_avatarContentView addGestureRecognizer:tap];
        [self.view addSubview:_avatarContentView];
    }
    return _avatarContentView;
}

- (UIButton *)logoutButton{
    if(!_logoutButton){
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_logoutButton setTitle:@"退出" forState:UIControlStateNormal];
        _logoutButton.backgroundColor = [UIColor systemRedColor];
        [_logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_logoutButton];
    }
    return _logoutButton;
}






//  MARK: UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //  昵称、手机号、修改密码、性别
    return  4;
}

- (ZHEditInfoItem *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZHEditInfoItem *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(!cell){
       cell = [[ZHEditInfoItem alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    switch (indexPath.item) {
        case 0:
            cell.cellTitle.text = @"昵称";
            cell.cellContent.text = self.aUser.nickname;
            break;
        case 1:
            cell.cellTitle.text = @"手机号";
            cell.cellContent.text = self.aUser.tel;
            break;
        case 2:
            cell.cellTitle.text = @"修改密码";
            cell.cellContent.text = @">";
            break;
        case 3:
            cell.cellTitle.text = @"性别";
            cell.cellContent.text = self.aUser.gender;
            break;
            
        default:
            break;
    }
    
    
    cell.tag = indexPath.item;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(changeAction:)];
    [cell addGestureRecognizer:tap];
        
    return cell;
}

// MARK: ACTION



-(void)logoutAction{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:LOGIN_FLAG];
    [self autoShowInfo:@"退出成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

//  保存更改的信息
-(void)saveAction{
    //  首先先尝试将图片上传到七牛云，并返回链接
    //  如果成功，修改昵称、性别、头像链接
    
    NSString *imgKey = [QiniuUtils uploadImg:self.rightAvatarView.image];
    NSLog(@"%@", imgKey);
    if(imgKey){
        //  如果上传成功
        
    }
    
    
}

//  点击修改项
-(void)changeAction:(UIGestureRecognizer *)tap{
    
    NSInteger row = tap.view.tag;
    NSIndexPath  *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    ZHEditInfoItem *item = [self.infoTableView cellForRowAtIndexPath:indexPath];
    
    // TODO: 这里不知道为什么无法使用 switch , 所以只好用 if..else
    if(row == 0){
        //  修改昵称
        Dialog().wTypeSet(DialogTypeWrite)
        .wEventOKFinishSet(^(id anyID, id otherData) {
            NSLog(@"%@",anyID);
            item.cellContent.text = anyID;
        })
        .wTitleSet(@"修改昵称")
        .wWriteDefaultTextSet(item.cellContent.text)           //默认内容
        //编辑框最大行数 1
        .wWirteTextMaxLineSet(1)
        .wStart();
    }else if(row == 1){
        //  手机号不可修改
//        //  修改手机号
//        Dialog().wTypeSet(DialogTypeWrite)
//        .wEventOKFinishSet(^(id anyID, id otherData) {
//            NSLog(@"%@",anyID);
//        })
//        .wTitleSet(@"修改手机号")
//        //默认内容
//        .wWriteDefaultTextSet(item.cellContent.text)
//        .wWirteKeyBoardType(UIKeyboardTypeNumberPad)
//        //编辑框最大行数 1
//        .wWirteTextMaxLineSet(1)
//        //编辑框可输入的文本最大文本长度 defualt -1 不限制
//        .wWirteTextMaxNumSet(11)
//        .wStart();
//
    }else if (row == 2){
        //  修改密码
        ZHChangePasswordViewController *changePasswordVC = [[ZHChangePasswordViewController alloc]init];
        changePasswordVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:changePasswordVC animated:YES];
    }else if(row == 3){
        //  修改性别
        Dialog()
        .wTypeSet(DialogTypeSelect)
        .wTitleSet(@"修改性别")
            .wListDefaultValueSet(@[item.cellContent.text])   //默认选中爬山
        .wDataSet(@[@"男",@"女",@"未知"])
//        添加下划线
            .wSeparatorStyleSet(UITableViewCellSeparatorStyleSingleLine)
            //单选底部添加确定按钮
            .wAddBottomViewSet(YES)
            //单选底部添加取消按钮
            .wEventCancelFinishSet(^(id anyID, id otherData) {

            })
            .wEventOKFinishSet(^(id anyID, id otherData) {
                NSLog(@"%@",anyID);
                item.cellContent.text = anyID[0];
            })
        //父view
        .wStartView(self.view);
    }
    
    
    
  
}


-(void)changeAvatar{
    //  创建一个 UIImagePickerController 对象
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    
    //  显示 UIImagePickerController
    [self presentViewController:picker animated:YES completion:nil];
    
}

///  更换头像
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    //  获取用户选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    //  设置 imageView 的 image 属性
    self.rightAvatarView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)changePasswordAction{
    ZHChangePasswordViewController *changePasswordVC = [[ZHChangePasswordViewController alloc]init];
    changePasswordVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:changePasswordVC animated:YES];
}




@end
