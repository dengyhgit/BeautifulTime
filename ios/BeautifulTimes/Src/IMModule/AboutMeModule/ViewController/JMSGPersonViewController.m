//
//  JMSGPersonViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGPersonViewController.h"
#import "JMSGPersonInfoCell.h"
#import "JMSGChatTable.h"
#import "JMSGEditUserInfoViewController.h"

@interface JMSGPersonViewController () <TouchTableViewDelegate,UIAlertViewDelegate,UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    NSArray *_titleArr;
    NSArray *_imgArr;
    NSMutableArray *_infoArr;
    NSArray *_pickerDataArr;
    NSNumber *_genderNumber;
    BOOL _selectFlagGender;
}

@property (nonatomic, strong) UIPickerView *genderPicker;
@property (nonatomic, strong) JMSGChatTable *personTabl;

@end

@implementation JMSGPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectFlagGender = NO;
    _genderNumber = [NSNumber numberWithInt:1];
    self.title = @"个人信息";
    [self loadUserInfoData];
    [self.view addSubview:self.personTabl];
    [self.view addSubview:self.genderPicker];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initData {
    _titleArr = @[@"昵称", @"性别", @"地区", @"个性签名"];
    _imgArr = @[@"wo_20", @"gender", @"location_21", @"signature"];
    _pickerDataArr = @[@"男", @"女"];
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
        _genderNumber = [NSNumber numberWithInt:1];
        _infoArr[1] = @"男";
    } else if (component == 0 && row == 1) {
        _genderNumber = [NSNumber numberWithInt:2];
        _infoArr[1] = @"女";
    } else {
        _genderNumber = [NSNumber numberWithInt:0];
    }
    
    [_personTabl reloadData];
}

- (void)showResultInfo:(id)resultObject error:(NSError *)error {
    if (error == nil) {
        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        JMSGUser *user = [JMSGUser myInfo];
        if (user.gender == kJMSGUserGenderMale) {
            cell.personInfoConten.text = @"男";
        } else if (user.gender == kJMSGUserGenderFemale) {
            cell.personInfoConten.text = @"女";
        } else {
            cell.personInfoConten.text = @"未知";
        }
        [MBProgressHUD showMessage:@"修改成功" view:self.view];
    } else {
        [MBProgressHUD showMessage:@"修改失败！" view:self.view];
    }
}

- (void)loadUserInfoData {
    _infoArr = [[NSMutableArray alloc] init];
    //SDK：获得用户信息
    JMSGUser *user = [JMSGUser myInfo];
    user.nickname ? [_infoArr addObject:user.nickname] : [_infoArr addObject:user.username];
    
    if (user.gender == kJMSGUserGenderUnknown) {
        [_infoArr addObject:@"未知"];
    } else if (user.gender == kJMSGUserGenderMale) {
        [_infoArr addObject:@"男"];
    } else {
        [_infoArr addObject:@"女"];
    }
    user.region ? [_infoArr addObject:user.region] : [_infoArr addObject:@""];
    user.signature ? [_infoArr addObject:user.signature] : [_infoArr addObject:@""];
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    if (_selectFlagGender) {
        //SDK：修改用户信息
        [JMSGUser updateMyInfoWithParameter:_genderNumber userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
            if (error == nil) {
            } else {
            }
        }];
        _selectFlagGender = NO;
    }
    [self showSelectGenderView:NO];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_titleArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    static NSString *cellIdentifier = @"JMSGPersonInfoCell";
    JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JMSGPersonInfoCell" owner:self options:nil] lastObject];
    }
    cell.infoTitleLabel.text = [_titleArr objectAtIndex:indexPath.row];
    cell.personInfoConten.text = [_infoArr objectAtIndex:indexPath.row];
    cell.titleImgView.image = [UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        _selectFlagGender = YES;
        [self showSelectGenderView:YES];
    } else {
        JMSGEditUserInfoViewController *changeNameVC = [[JMSGEditUserInfoViewController alloc] init];
        
        if (indexPath.row == 0) {
            changeNameVC.updateType = kJMSGUserFieldsNickname;
        } else if(indexPath.row == 2) {
            changeNameVC.updateType = kJMSGUserFieldsRegion;
        } else if(indexPath.row == 3) {
            changeNameVC.updateType = kJMSGUserFieldsSignature;
        }
        [self.navigationController pushViewController:changeNameVC animated:YES];
    }
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    JMSGUser *user = [JMSGUser myInfo];
    if (buttonIndex == 1) {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请输入" view:self.view];
            return;
        }
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        if (![[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"正在修改" toView:self.view];
            if (alertView.tag == 0) {
                //SDK：修改用户信息
                [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsNickname completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.nickname;
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag == 1) {
                //SDK：修改用户信息
                [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsGender completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    if (error == nil) {
                        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        if (user.gender == kJMSGUserGenderMale) {
                            cell.personInfoConten.text = @"男";
                        } else if (user.gender == kJMSGUserGenderFemale) {
                            cell.personInfoConten.text = @"女";
                        } else {
                            cell.personInfoConten.text = @"未知";
                        }
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag == 2) {
                //SDK：修改用户信息
                [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsRegion completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.region;
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            } else if (alertView.tag == 3) {
                //SDK：修改用户信息
                [JMSGUser updateMyInfoWithParameter:[alertView textFieldAtIndex:0].text userFieldType:kJMSGUserFieldsSignature completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (error == nil) {
                        [MBProgressHUD showMessage:@"修改成功" view:self.view];
                        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *) [_personTabl cellForRowAtIndexPath:[NSIndexPath indexPathForRow:alertView.tag inSection:0]];
                        cell.personInfoConten.text = user.signature;
                    } else {
                        [MBProgressHUD showMessage:@"修改失败" view:self.view];
                    }
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        CGSize size = [JMSGStringUtils stringSizeWithWidthString:_infoArr[3] withWidthLimit:180 withFont:[UIFont systemFontOfSize:17]];
        return size.height + 36;
    }
    return 57;
}

#pragma mark setter
- (UIPickerView *)genderPicker {
    if (!_genderPicker) {
        _genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kApplicationWidth, 100)];
        _genderPicker.dataSource = self;
        _genderPicker.delegate = self;
        _genderPicker.tag = 200;
    }
    return _genderPicker;
}

- (JMSGChatTable *)personTabl {
    if (!_personTabl) {
        _personTabl = [[JMSGChatTable alloc] initWithFrame:CGRectMake(0, 0, kApplicationWidth, kScreenHeight - kNavigationBarHeight - kStatusBarHeight)];
        _personTabl.touchDelegate = self;
        _personTabl.backgroundColor = [UIColor whiteColor];
        _personTabl.scrollEnabled = NO;
        _personTabl.dataSource = self;
        _personTabl.delegate = self;
        _personTabl.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _personTabl;
}

@end
