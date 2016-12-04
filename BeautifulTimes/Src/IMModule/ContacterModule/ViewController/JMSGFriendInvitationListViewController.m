//
//  JMSGFriendInvitationViewController.m
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFriendInvitationListViewController.h"
#import "JMSGFriendInvitationCell.h"


#define JMSG_USERDEFAULT_FRIEND_INVITATION ([NSString stringWithFormat:@"userdefault_friend_invitation_list_%@_%@",[JMSGUser myInfo].username,[JMSGUser myInfo].appKey])

@interface JMSGFriendInvitationListViewController ()<UITableViewDataSource,UITableViewDelegate,JMessageDelegate>

@property (strong,nonatomic)NSMutableArray *data;

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation JMSGFriendInvitationListViewController

#pragma mark - 添加好友邀请缓存
+ (void)addCacheForFriendInvitaionWithEvent:(JMSGFriendNotificationEvent *)event {
    
    JMSGContactModel *model =[[JMSGContactModel alloc] init];
    model.name = [event getFromUsername];
    model.dec = [event getReason];
    model.user = [event getFromUser];
    model.dealWithType = JMSGFriendInvitation_none;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:JMSG_USERDEFAULT_FRIEND_INVITATION];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (!array) {
        array = [NSMutableArray array];
    }
    if (model) {
        for (JMSGContactModel *obj in array) {
            if ([obj.user.username isEqualToString:model.user.username]) {
                [array removeObject:obj];
            }
        }
        [array addObject:model];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:JMSG_USERDEFAULT_FRIEND_INVITATION];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - 缓存好友邀请列表
- (void)updateFriendInvitationList {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:JMSG_USERDEFAULT_FRIEND_INVITATION];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (NSMutableArray *)readFriendInvitationArray {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:JMSG_USERDEFAULT_FRIEND_INVITATION];
    if (!data) {
        return nil;
    }
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新朋友";
    
    _data = [NSMutableArray array];
    
    NSMutableArray *array = [self readFriendInvitationArray];
    if (array.count) {
        _data = [NSMutableArray arrayWithArray:array];
    }
    
    [self.view addSubview:self.tableview];
}


#pragma mark - FriendInvitationNotification
- (void)friendInvitiaonChangeNotification:(NSNotification *)notification{
    
    JMSGFriendNotificationEvent *event = (JMSGFriendNotificationEvent *)notification.object;
    
    JMSGContactModel *model =[[JMSGContactModel alloc] init];
    model.dec = [event getReason];
    model.user = [event getFromUser];
    model.dealWithType = JMSGFriendInvitation_none;
    
    [self.data addObject:model];
    [self updateFriendInvitationList];
    
    [self.tableview reloadData];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}
#pragma mark 表单元的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID =@"JMSGFriendInvitationCell";
    JMSGFriendInvitationCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"JMSGFriendInvitationCell" owner:self options:nil]lastObject];
    }
    
    JMSGContactModel *model = self.data[indexPath.row];
    cell.model = model;
    cell.friendInvitationResponseBlock = ^(BOOL isAccept){
        if (isAccept) {
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            [JMSGFriendManager acceptInvitationWithUsername:model.user.username appKey:model.user.appKey completionHandler:^(id resultObject, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                    if (!error) {
                        [self.data removeObjectAtIndex:indexPath.row];
                        [self updateFriendInvitationList];
                        
                        [MBProgressHUD showMessage:@"接受加为好友" view:self.view];
                        [self.tableview reloadData];
                    }
                    else{
                        [MBProgressHUD showMessage:@"操作失败" view:self.view];
                    }
                });
            }];
        }
    };
    return cell;
}
//按钮呈现名称
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//删除操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSGContactModel *model = self.data[indexPath.row];
    if (model.dealWithType != JMSGFriendInvitation_none) {
        [self.data removeObjectAtIndex:indexPath.row];
        [self.tableview reloadData];
        [self updateFriendInvitationList];
        return ;
    }
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    [JMSGFriendManager rejectInvitationWithUsername:model.user.username appKey:model.user.appKey reason:nil completionHandler:^(id resultObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if (!error) {
                [self.data removeObjectAtIndex:indexPath.row];
                [self.tableview reloadData];
                [MBProgressHUD showMessage:@"拒绝加为好友" view:self.view];
                [self updateFriendInvitationList];
            }
            else{
                [MBProgressHUD showMessage:@"操作失败" view:self.view];
            }
        });
    }];
}
#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableview.delegate = self;
        _tableview.dataSource =self;
        _tableview.sectionIndexColor = [UIColor grayColor];
        _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableview.tableFooterView = [UIView new];
    }
    return _tableview;
}
@end
