//
//  BTSettingViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMSettingViewController.h"
#import "BTIMSettingModel.h"
#import "BTIMSettingCell.h"
#import "BTHomePageViewController.h"
#import "BTBaseNavigationController.h"
#import "AppDelegate.h"
#import "BTVersionInfoViewController.h"
#import "JMSGUpdatePasswordViewController.h"

@interface BTIMSettingViewController ()

@property (nonatomic,strong) NSMutableArray *allArr;

@end

@implementation BTIMSettingViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 5, 0);
    self.title=@"设置";
    [self loadDataModel];
}

#pragma mark 加载数据模型
-(void)loadDataModel
{
//    BTIMSettingModel *newMsg = [BTIMSettingModel settingWithTitle:@"新消息通知" detailTitle:nil];
//    BTIMSettingModel *conseal = [BTIMSettingModel settingWithTitle:@"隐私" detailTitle:nil];
    BTIMSettingModel *resetPasswod = [BTIMSettingModel settingWithTitle:@"修改密码" detailTitle:nil];
    NSArray *twoArr = @[resetPasswod];
    [self.allArr addObject:twoArr];

    BTIMSettingModel *abount = [BTIMSettingModel settingWithTitle:@"关于私语" detailTitle:nil];
    NSArray *threeArr = @[abount];
    [self.allArr addObject:threeArr];

    BTIMSettingModel *loginOut = [BTIMSettingModel settingWithTitle:@"退出登录" detailTitle:nil];
    loginOut.isLoginOut = YES;
    NSArray *fourArr = @[loginOut];
    [self.allArr addObject:fourArr];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr=self.allArr[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTIMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSettingCell"];
    if (!cell) {
        cell = [[BTIMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kSettingCell"];
    }
    NSArray *arr = self.allArr[indexPath.section];
    BTIMSettingModel *model = arr[indexPath.row];
    cell.settingModel = model;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = self.allArr[indexPath.section];
    BTIMSettingModel *model = arr[indexPath.row];
    if(model.isLoginOut){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否退出当前账号？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    } else if (indexPath.section == 1) {
        BTVersionInfoViewController *vc = [[BTVersionInfoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        JMSGUpdatePasswordViewController *vc = [[JMSGUpdatePasswordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma marks UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [MBProgressHUD showMessage:@"正在退出登录！" view:self.view];
        [JMSGUser logout:^(id resultObject, NSError *error) {
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            BTHomePageViewController *homeViewController = [[BTHomePageViewController alloc] init];
            BTBaseNavigationController *homeNavigationController = [[BTBaseNavigationController alloc] initWithRootViewController:homeViewController];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [AppDelegate getInstance].window.rootViewController = homeNavigationController;
            [self removeFromParentViewController];
        }];
    }
}

-(NSMutableArray *)allArr
{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

@end
