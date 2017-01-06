//
//  BTIMMyInfoViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMMyInfoViewController.h"
#import "BTUserInfoModel.h"
#import "BTIMNavViewController.h"
#import "BTIMEditUserInfoViewController.h"

@interface BTIMMyInfoViewController () <BTEditUserInfoViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, UIPickerViewDataSource,UIPickerViewDelegate> {
    NSArray *_pickerDataArr;
}

@property (weak, nonatomic)  UIImageView *headView;
@property (nonatomic,strong) NSMutableArray *allArr;  //里面存放的arr数组
@property (nonatomic,strong) NSMutableArray *oneArr;//里面存放第一组的用户信息
@property (nonatomic,strong) NSMutableArray *twoArr;//里面存放第二组的用户信息
@property (nonatomic, strong) UIPickerView *genderPicker;
@end

@implementation BTIMMyInfoViewController

-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    [self loadUserinfo];
    _pickerDataArr = @[@"男", @"女"];
    [self.view addSubview:self.genderPicker];
}

-(void)loadUserinfo
{
    [self.oneArr removeAllObjects];
    [self.twoArr removeAllObjects];
    [self.allArr removeAllObjects];
    JMSGUser *user = [JMSGUser myInfo];
    
    BTUserInfoModel *pro1 = [BTUserInfoModel profileWithUser:user name:@"头像"];
    
    NSString *nickName = user.nickname ? user.nickname : @"未设置";
    BTUserInfoModel *pro2 = [BTUserInfoModel profileWithInfo:nickName infoType:UserNickName name:@"昵称"];
    
    NSString *account = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    BTUserInfoModel *pro3 = [BTUserInfoModel profileWithInfo:account infoType:UserWeixinNum name:@"私语号"];
    //添加到第一个数组中
    [self.oneArr addObject:pro1];
    [self.oneArr addObject:pro2];
    [self.oneArr addObject:pro3];
    [self.allArr addObject:_oneArr];
    
    //4.性别
    NSString *gender;
    if (user.gender == kJMSGUserGenderMale) {
        gender = @"男";
    } else if (user.gender == kJMSGUserGenderFemale) {
        gender = @"女";
    } else {
        gender = @"未知";
    }
    BTUserInfoModel *pro4 = [BTUserInfoModel profileWithInfo:gender infoType:UserCompany  name:@"性别"];
   
    //5.地域
    NSString *region = user.region ? user.region : @"未设置";
    BTUserInfoModel *pro5 = [BTUserInfoModel profileWithInfo:region infoType:UserDepartment  name:@"地区"];
    //6.个性签名
    NSString *worker = user.signature ? user.signature : @"未设置";
    BTUserInfoModel *pro6 = [BTUserInfoModel profileWithInfo:worker infoType:UserWorker name:@"签名"];
    
    
    [self.twoArr addObject:pro4];
    [self.twoArr addObject:pro5];
    [self.twoArr addObject:pro6];
    [self.allArr addObject:_twoArr];
}

- (void)showSelectGenderView:(BOOL)flag {
    if (!flag) {
        [UIView animateWithDuration:0.5 animations:^{
            [_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height, _genderPicker.bounds.size.width, _genderPicker.bounds.size.height)];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            [_genderPicker setFrame:CGRectMake(0, self.view.bounds.size.height - _genderPicker.bounds.size.height, _genderPicker.bounds.size.width, _genderPicker.bounds.size.height)];
        }];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerDataArr count];
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerDataArr objectAtIndex:row];
}

#pragma mark --选择更改性别
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0 && row ==0) {
        [JMSGUser updateMyInfoWithParameter:@(1) userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
            [self loadUserinfo];
            [self.tableView reloadData];
        }];
    } else if (component == 0 && row == 1) {
        [JMSGUser updateMyInfoWithParameter:@(2) userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
            [self loadUserinfo];
            [self.tableView reloadData];
        }];
    } else {
        [JMSGUser updateMyInfoWithParameter:@(0) userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
            [self loadUserinfo];
            [self.tableView reloadData];
        }];
    }
    [self showSelectGenderView:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *arr=self.allArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"profileCell"];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"profileCell"];
    }
    
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *profile = arr[indexPath.row];
    if(profile.user){
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [profile.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (data) {
                imageV.image =  [[UIImage alloc] initWithData:data];
            } else {
                imageV.image = BT_LOADIMAGE(@"com_ic_defaultIcon");
            }
        }];
        cell.accessoryView=imageV;
    }
    cell.textLabel.text = profile.name;
    cell.detailTextLabel.text = profile.info;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark 设置单元格 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *profile = arr[indexPath.row];
    if(profile.image) {
        return 80;
    }
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *userInfo = arr[indexPath.row];
    //设置头像图片
    if(userInfo.user){
        UIActionSheet *sheet=[[UIActionSheet alloc]initWithTitle:@"选择图片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册中选择", nil];
        [sheet showInView:self.view];
        
        return;
    }
    
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self showSelectGenderView:YES];
        return;
    }
    
    //不需要设置账号号
    if(userInfo.infoType==UserWeixinNum) return;
    
    BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
    edit.delegate=self;
    edit.indexPath=indexPath;
    if([userInfo.info isEqualToString:@"未设置"]){
        edit.str=nil;
    }else{
        edit.str=userInfo.info;
    }
    edit.title=userInfo.name;
    BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark actionSheet的代理方法
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==2) return;
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate =self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
    switch (buttonIndex) {
        case 0: //拍照
        {
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
        }
            break;
            
        case 1: //从相册中选择
        {
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
            break;
            
    }
}

#pragma mark 图片选择完成的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSArray *arr = self.allArr[0];
    BTUserInfoModel *pro = arr[0];
    pro.image=UIImageJPEGRepresentation(image, 1.0);
    [self saveHeadImage:UIImageJPEGRepresentation(image, 0.7f)];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 保存头像图片的方法
-(void)saveHeadImage:(NSData*)data
{
    WS(weakSelf);
    [MBProgressHUD showMessage:@"保存头像中..." toView:self.view];
    [JMSGUser updateMyInfoWithParameter:data userFieldType:kJMSGUserFieldsAvatar completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            [weakSelf loadUserinfo];
            [weakSelf.tableView reloadData];
            [MBProgressHUD showSuccess:@"保存成功" toView:weakSelf.view];
            [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateUserAvator object:nil];
        } else {
            [MBProgressHUD showError:@"保存失败" toView:weakSelf.view];
        }
    }];
    
}
#pragma mark 编辑控制器的代理方法
-(void)EditingFinshed:(BTIMEditUserInfoViewController *)edit indexPath:(NSIndexPath *)indexPath newInfo:(NSString *)newInfo
{
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *userInfo = arr[indexPath.row];
    userInfo.info = newInfo; //重新设置个人信息
    
    if ([userInfo.name isEqualToString:@"昵称"]) {
        [JMSGUser updateMyInfoWithParameter:userInfo.info userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
            
        }];
    }

    if ([userInfo.name isEqualToString:@"签名"]) {
        [JMSGUser updateMyInfoWithParameter:userInfo.info userFieldType:kJMSGUserFieldsSignature completionHandler:^(id resultObject, NSError *error) {
            
        }];
    }
    
    if ([userInfo.name isEqualToString:@"地区"]) {
        [JMSGUser updateMyInfoWithParameter:userInfo.info userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
            
        }];
    }
    
    [self.tableView reloadData];
}

#pragma mark setter & getter
-(NSMutableArray *)allArr
{
    if(!_allArr){
        _allArr=[NSMutableArray array];
    }
    return _allArr;
}
-(NSMutableArray *)oneArr
{
    if(!_oneArr){
        _oneArr=[NSMutableArray array];
    }
    return _oneArr;
}
-(NSMutableArray *)twoArr
{
    if(!_twoArr){
        _twoArr=[NSMutableArray array];
    }
    return _twoArr;
}

- (UIPickerView *)genderPicker {
    if (!_genderPicker) {
        _genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kApplicationWidth, 100)];
        _genderPicker.dataSource = self;
        _genderPicker.delegate = self;
        _genderPicker.tag = 200;
    }
    return _genderPicker;
}

@end
