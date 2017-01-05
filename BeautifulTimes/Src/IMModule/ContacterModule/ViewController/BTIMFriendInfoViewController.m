//
//  BTIMFriendInfoViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/3/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMFriendInfoViewController.h"
#import "BTUserInfoModel.h"
#import "BTIMSettingCell.h"
#import "BTIMSettingModel.h"
#import "BTIMEditUserInfoViewController.h"
#import "BTIMNavViewController.h"

@interface BTIMFriendInfoViewController () <BTEditUserInfoViewDelegate>

@property (weak, nonatomic)  UIImageView *headView;
@property (nonatomic,strong) NSMutableArray *allArr;  //里面存放的arr数组
@property (nonatomic,strong) NSMutableArray *oneArr;
@property (nonatomic,strong) NSMutableArray *twoArr;

@end

@implementation BTIMFriendInfoViewController

-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"好友信息";
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0);
    [self loadFriendInfo];
}

- (void)loadFriendInfo {
    [self.oneArr removeAllObjects];
    [self.twoArr removeAllObjects];
    [self.allArr removeAllObjects];
    
//    NSData *data = self.contacter.headIcon ? UIImageJPEGRepresentation(self.contacter.headIcon, 1.0) : UIImageJPEGRepresentation(BT_LOADIMAGE(@"com_ic_defaultIcon"), 1.0);
//    BTUserInfoModel *pro1 = [BTUserInfoModel profileWithImage:data name:@"头像"];
    
    NSString *nickName = self.user.nickname ? self.user.nickname : @"未设置";
    BTUserInfoModel *pro2 = [BTUserInfoModel profileWithInfo:nickName infoType:UserNickName name:@"昵称"];
    
    NSString *account = self.user.username;
    BTUserInfoModel *pro3 = [BTUserInfoModel profileWithInfo:[self cutStr:account] infoType:UserWeixinNum name:@"私语号"];
    
    //添加到第一个数组中
//    [self.oneArr addObject:pro1];
    [self.oneArr addObject:pro2];
    [self.oneArr addObject:pro3];
    [self.allArr addObject:_oneArr];
    
//    //4.公司 
//    NSString *company = vCardTemp.orgName ? vCardTemp.orgName : @"未设置";
//    BTUserInfoModel *pro4=[BTUserInfoModel profileWithInfo:company infoType:UserCompany  name:@"公司"];
//    
//    //5.部门
//    NSString *depart;
//    if (vCardTemp.orgUnits.count > 0) {
//        depart = vCardTemp.orgUnits[0];
//    }
//    depart = depart ? depart : @"未设置";
//    BTUserInfoModel *pro5=[BTUserInfoModel profileWithInfo:depart infoType:UserDepartment  name:@"部门"];
//    //6.职位
//    NSString *worker = vCardTemp.title ? vCardTemp.title : @"未设置";
//    BTUserInfoModel *pro6=[BTUserInfoModel profileWithInfo:worker infoType:UserWorker name:@"职位"];
//    
//    //7.电话
//    // myVCard.telecomsAddresses 这个get方法，没有对电子名片的xml数据进行解析
//    // 使用note字段充当电话
//    NSString *tel = vCardTemp.note ? vCardTemp.note:@"未设置";
//    BTUserInfoModel *pro7=[BTUserInfoModel profileWithInfo:tel infoType:UserTel name:@"电话"];
//    //7.邮件
//    // 用mailer充当邮件
//    NSString *email = vCardTemp.mailer ? vCardTemp.mailer : @"未设置";
//    BTUserInfoModel *pro8=[BTUserInfoModel profileWithInfo:email infoType:UserEmail name:@"邮箱"];
//    [self.twoArr addObject:pro4];
//    [self.twoArr addObject:pro5];
//    [self.twoArr addObject:pro6];
//    [self.twoArr addObject:pro7];
//    [self.twoArr addObject:pro8];
    [self.allArr addObject:_twoArr];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.allArr.count) {
        return 1;
    }
    NSArray *arr = self.allArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.allArr.count) {
        BTIMSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kfriendProfileCell"];
        if (!cell) {
            cell = [[BTIMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kfriendProfileCell"];
        }
        BTIMSettingModel *sendMessage = [BTIMSettingModel settingWithTitle:@"发送消息" detailTitle:nil];
        sendMessage.isLoginOut = YES;
        cell.settingModel = sendMessage;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendProfileCell"];
    if(!cell){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"friendProfileCell"];
    }
    
    NSArray *arr=self.allArr[indexPath.section];
    BTUserInfoModel *profile=arr[indexPath.row];
    if(profile.image){
        UIImageView *imageV=[[UIImageView alloc]initWithImage:[UIImage imageWithData:profile.image]];
        imageV.frame = CGRectMake(0, 0, 50, 50);
        cell.accessoryView=imageV;
    }
    cell.textLabel.text = profile.name;
    cell.detailTextLabel.text = profile.info;
    if (indexPath.section == 0  && indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark 设置单元格 的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == self.allArr.count) {
        return 44;
    }
    NSArray *arr=self.allArr[indexPath.section];
    BTUserInfoModel *profile=arr[indexPath.row];
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
    if (indexPath.section == self.allArr.count) {
//        BTChatViewController *chatVc = [[BTChatViewController alloc] init];
//        chatVc.contacter = self.contacter;
//        chatVc.title = self.contacter.friendName;
//        [self.navigationController pushViewController:chatVc animated:YES];
        return;
    }
    NSArray *arr = self.allArr[indexPath.section];
    BTUserInfoModel *userInfo = arr[indexPath.row];
    if (indexPath.section == 0  && indexPath.row == 1) {
        BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
        edit.delegate = self;
        edit.indexPath = indexPath;
        if([userInfo.info isEqualToString:@"未设置"]){
            edit.str=nil;
        }else{
            edit.str=userInfo.info;
        }
        edit.title=userInfo.name;
        BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark 编辑控制器的代理方法
-(void)EditingFinshed:(BTIMEditUserInfoViewController *)edit indexPath:(NSIndexPath *)indexPath newInfo:(NSString *)newInfo
{
//    BTXMPPTool *xmppTool = [BTXMPPTool sharedInstance];
//    [xmppTool setNickname:newInfo forUser:self.contacter.jid];
//    self.contacter.nickName = newInfo;
    [self loadFriendInfo];
    [self.tableView reloadData];
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    return arr[0];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
