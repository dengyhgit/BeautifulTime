//
//  JMSGGroupDetailViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGGroupDetailViewController.h"
#import "JMSGGroupMemberCollectionViewCell.h"
#import "JMSGPersonViewController.h"
#import "JMSGFriendDetailViewController.h"
#import "JMSGFootTableCollectionReusableView.h"
#import "JMSGFootTableViewCell.h"

@interface JMSGGroupDetailViewController ()<
    UICollectionViewDataSource,
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    UITableViewDataSource,
    UITableViewDelegate,
    UITabBarDelegate> {
    BOOL _isInEditToDeleteMember;
}

@property (weak, nonatomic) IBOutlet UICollectionView *groupMemberGrip;
@property (nonatomic, strong) UIActionSheet * selectActionSheet;

@end

@implementation JMSGGroupDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _isInEditToDeleteMember = NO;
    self.title = @"聊天详情";
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        _memberArr = [[NSMutableArray alloc] initWithArray:@[_conversation.target]];
        [self setupGroupMemberGrip];
    }else {
        [self getAllMember];
        [self setupGroupMemberGrip];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)refreshMemberGrid {
    [self getAllMember];
    [_groupMemberGrip reloadData];
}

- (void)setupGroupMemberGrip {
    [_groupMemberGrip registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gradientCell"];
    [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JMSGGroupMemberCollectionViewCell" bundle:nil]
     forCellWithReuseIdentifier:@"JMSGGroupMemberCollectionViewCell"];

    [_groupMemberGrip registerNib:[UINib nibWithNibName:@"JMSGFootTableCollectionReusableView" bundle:nil]
     forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
            withReuseIdentifier:@"JMSGFootTableCollectionReusableView"];
    _groupMemberGrip.backgroundColor = [UIColor whiteColor];
    _groupMemberGrip.delegate = self;
    _groupMemberGrip.dataSource = self;

    _groupMemberGrip.backgroundView = [UIView new];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGripMember:)];
    [_groupMemberGrip.backgroundView addGestureRecognizer:tap];
}

- (void)tapGripMember:(id)sender {
    [self removeEditStatus];
}

- (void)removeEditStatus {
    _isInEditToDeleteMember = NO;
    [_groupMemberGrip reloadData];
}

-(void)getAllMember {
    //SDK：
    _memberArr = [[NSMutableArray alloc] initWithArray:[((JMSGGroup *)(_conversation.target)) memberArray]];
}

#pragma mark - CollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section != 0) {
        return 0;
    }

    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        return _memberArr.count + 1;
    }

    JMSGGroup *group = (JMSGGroup *)_conversation.target;
    if ([group.owner isEqualToString:[JMSGUser myInfo].username]) {
        return _memberArr.count + 2;
    } else {
        return _memberArr.count +1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(52, 80);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(kApplicationWidth, 200);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"JMSGGroupMemberCollectionViewCell";
    JMSGGroupMemberCollectionViewCell *cell = (JMSGGroupMemberCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if (indexPath.item == _memberArr.count) {
        [cell setAddMember];
        return cell;
    }
    if (indexPath.item == _memberArr.count + 1) {
        [cell setDeleteMember];
        return cell;
    }
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = _memberArr[indexPath.item];
        [cell setDataWithUser:user withEditStatus:_isInEditToDeleteMember];
    } else {
        JMSGGroup *group = _conversation.target;
        JMSGUser *user = _memberArr[indexPath.item];
        if ([group.owner isEqualToString:user.username]) {
            [cell setDataWithUser:user withEditStatus:NO];
        } else {
            [cell setDataWithUser:user withEditStatus:_isInEditToDeleteMember];
        }
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    JMSGFootTableCollectionReusableView *footTable = nil;
    static NSString *footerIdentifier = @"JMSGFootTableCollectionReusableView";
    footTable = [_groupMemberGrip dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                    withReuseIdentifier:footerIdentifier
                                                                                           forIndexPath:indexPath];
    footTable.footTableView.delegate = self;
    footTable.footTableView.dataSource =self;
    [footTable.footTableView reloadData];
    return footTable;
}

- (void)tapToEditGroupName {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"输入群名称"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    alerView.tag = kAlertViewTagRenameGroup;
    [alerView show];
    [self removeEditStatus];
}

- (void)tapToClearChatRecord {
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"清空聊天记录"
                                                     message:@""
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    alerView.tag = kAlertViewTagClearChatRecord;
    [alerView show];
    [self removeEditStatus];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }

    switch (alertView.tag) {
        case kAlertViewTagClearChatRecord:
        {
            if (buttonIndex ==1) {
                //SDK：删除所有信息
                [self.conversation deleteAllMessages];
                [[NSNotificationCenter defaultCenter] postNotificationName:kDeleteAllMessage object:nil];
            }
        }
        break;
        case kAlertViewTagAddMember:
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                return;
            }
            if (_conversation.conversationType == kJMSGConversationTypeSingle) {
                [self createGroupWithAlertView:alertView];
            } else {
                __weak __typeof(self)weakSelf = self;
                [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
                //SDK：添加群组成员
                [((JMSGGroup *)(self.conversation.target)) addMembersWithUsernameArray:@[[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    if (error == nil) {
                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                        [strongSelf refreshMemberGrid];
                    } else {
                        LogInfo(@"addMembersFromUsernameArray fail with error %@",error);
                        [MBProgressHUD showMessage:@"添加成员失败" view:weakSelf.view];
                    }
                }];
            }
        }
        break;
        case kAlertViewTagAddMember + 1:
        {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""] || [[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                return;
            }
            if (_conversation.conversationType == kJMSGConversationTypeSingle) {
                [self createGroupWithAlertView:alertView];
            } else {
                __weak __typeof(self)weakSelf = self;
                [MBProgressHUD showMessage:@"获取成员信息" toView:self.view];
                //SDK：添加群组成员
                [((JMSGGroup *)(self.conversation.target)) addMembersWithUsernameArray:@[[alertView textFieldAtIndex:0].text] appKey:[alertView textFieldAtIndex:1].text completionHandler:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    if (error == nil) {
                        __strong __typeof(weakSelf)strongSelf = weakSelf;
                        [strongSelf refreshMemberGrid];
                    } else {
                        LogInfo(@"addMembersFromUsernameArray fail with error %@",error);
                        [MBProgressHUD showMessage:@"添加成员失败" view:weakSelf.view];
                    }
                }];
            }
        }
            break;
        case kAlertViewTagQuitGroup:
        {
            if (buttonIndex ==1) {
                __weak __typeof(self)weakSelf = self;
                [MBProgressHUD showMessage:@"正在推出群组！" toView:self.view];
                JMSGGroup *deletedGroup = ((JMSGGroup *)(self.conversation.target));

                [deletedGroup exit:^(id resultObject, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                    if (error == nil) {
                        LogInfo(@"推出群组成功");
                        [MBProgressHUD showMessage:@"推出群组成功" view:weakSelf.view];
                      
                        //SDK：删除群聊会话
                        [JMSGConversation deleteGroupConversationWithGroupId:deletedGroup.gid];
                        [self.navigationController popToViewController:self.sendMessageCtl.superViewController animated:YES];
                    } else {
                        LogInfo(@"推出群组失败");
                        [MBProgressHUD showMessage:@"推出群组失败" view:weakSelf.view];
                    }
                }];
            }
        }
        break;
        default:
            [MBProgressHUD showMessage:@"更新群组名称" toView:self.view];
            JMSGGroup *needUpdateGroup = (JMSGGroup *)(self.conversation.target);

            //SDK：
            [JMSGGroup updateGroupInfoWithGroupId:needUpdateGroup.gid
                                       name:[alertView textFieldAtIndex:0].text
                                       desc:needUpdateGroup.desc
                          completionHandler:^(id resultObject, NSError *error) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            
                            if (error == nil) {
                              [MBProgressHUD showMessage:@"更新群组名称成功" view:self.view];
                              [self refreshMemberGrid];
                            } else {
                              [MBProgressHUD showMessage:@"更新群组名称失败" view:self.view];
                            }
                          }];
        break;
    }
    return;
}

- (void)createGroupWithAlertView:(UIAlertView *)alertView {
    [MBProgressHUD showMessage:@"加好友进群组" toView:self.view];
    __block JMSGGroup *tmpgroup =nil;
    typeof(self) __weak weakSelf = self;
    [JMSGGroup createGroupWithName:@"" desc:@"" memberArray:@[((JMSGUser *)self.conversation.target).username,[alertView textFieldAtIndex:0].text] completionHandler:^(id resultObject, NSError *error) {
      [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
      typeof(weakSelf) __strong strongSelf = weakSelf;
      tmpgroup = (JMSGGroup *)resultObject;
      
      if (error == nil) {
        [JMSGConversation createGroupConversationWithGroupId:tmpgroup.gid completionHandler:^(id resultObject, NSError *error) {
          if (error == nil) {
            [MBProgressHUD showMessage:@"创建群成功" view:self.view];
            JMSGConversation *groupConversation = (JMSGConversation *)resultObject;
            strongSelf.sendMessageCtl.conversation = groupConversation;
            strongSelf.sendMessageCtl.isConversationChange = YES;
            //SDK：删除Delegate监听
            [JMessage removeDelegate:strongSelf.sendMessageCtl withConversation:_conversation];
            [JMessage addDelegate:strongSelf.sendMessageCtl withConversation:groupConversation];
            strongSelf.sendMessageCtl.targetName = tmpgroup.name;
            strongSelf.sendMessageCtl.title = tmpgroup.name;
            [strongSelf.sendMessageCtl setupView];
            [[NSNotificationCenter defaultCenter] postNotificationName:kConversationChange object:resultObject];
            [strongSelf.navigationController popViewControllerAnimated:YES];
          } else {
            LogInfo(@"creategroupconversation error with error : %@",error);
          }
        }];
      } else {
        [MBProgressHUD showMessage:[JMSGStringUtils errorAlert:error] view:self.view];
      }
    }];
}

- (void)collectionView:(UICollectionView * _Nonnull)collectionView didSelectItemAtIndexPath:(NSIndexPath * _Nonnull)indexPath {
    if (indexPath.item == _memberArr.count) {
        _isInEditToDeleteMember = NO;
        [_groupMemberGrip reloadData];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"添加跨应用成员"];
        [actionSheet addButtonWithTitle:@"添加普通成员"];
        [actionSheet addButtonWithTitle:@"取消"];
        //设置取消按钮
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showFromRect:self.view.superview.bounds inView:self.view.superview animated:NO];
        
        if (self.selectActionSheet) {
            self.selectActionSheet = nil;
        }
        
        self.selectActionSheet = actionSheet;
        
        return;
    }
  
    if (indexPath.item == _memberArr.count + 1) {// 删除群成员
        _isInEditToDeleteMember = !_isInEditToDeleteMember;
        [_groupMemberGrip reloadData];
        return;
    }

    //  点击群成员头像
    JMSGUser *user = _memberArr[indexPath.item];
    JMSGGroup *group = _conversation.target;
    if (_isInEditToDeleteMember) {
        if ([user.username isEqualToString:group.owner]) {
            return;
        }
        JMSGUser *userToDelete = _memberArr[indexPath.item];
        [self deleteMemberWithUserName:userToDelete];
    } else {
        if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
            JMSGPersonViewController *personCtl =[[JMSGPersonViewController alloc] init];
            personCtl.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:personCtl animated:YES];
        } else {
            JMSGFriendDetailViewController *friendCtl = [[JMSGFriendDetailViewController alloc]initWithNibName:@"JMSGFriendDetailViewController" bundle:nil];
            friendCtl.userInfo = user;
            friendCtl.isGroupFlag = YES;
            [self.navigationController pushViewController:friendCtl animated:YES];
        }
    }
    return ;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加跨应用好友进群"
                                                              message:@"输入userName和AppKey"
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                                    otherButtonTitles:@"确定", nil];
            alerView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
            UITextField *userName = [alerView textFieldAtIndex:0];
            userName.placeholder = @"userName";
            UITextField *appKey = [alerView textFieldAtIndex:1];
            //        appKey.placeholder = @"AppKey";
            appKey.text = @"d56cf91c2f4652901c3c4c13";
            alerView.tag = kAlertViewTagAddMember + 1;
            [alerView show];
        }
            break;
            
        case 1:
        {
            UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友进群"
                                                          message:@"输入好友用户名!"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
            alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
            alerView.tag = kAlertViewTagAddMember;
            [alerView show];
        }
            break;
            
        default:
            break;
    }
}

- (void)deleteMemberWithUserName:(JMSGUser *)user {
    if ([_memberArr count] == 1) {
        return;
    }
    [MBProgressHUD showMessage:@"正在删除成员！" toView:self.view];
    //SDK：移除群成员
    [((JMSGGroup *)(self.conversation.target)) removeMembersWithUsernameArray:@[user.username] appKey:user.appKey completionHandler:^(id resultObject, NSError *error) {
        if (error == nil) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"删除成员成功！" view:self.view];
            [self refreshMemberGrid];
        } else {
            LogInfo(@"JCHATGroupSettingCtl   fail to removeMembersFromUsernameArrary");
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [MBProgressHUD showMessage:@"删除成员错误！" view:self.view];
        }
    }];
}

- (void)quitGroup {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"退出群聊"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alerView.tag = kAlertViewTagQuitGroup;
    [alerView show];
    [self removeEditStatus];
}

#pragma -mark FootTableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        return 3;
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JMSGFootTableViewCell";
    JMSGFootTableViewCell *cell = (JMSGFootTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        switch (indexPath.row) {
            case 0:
            {
                [cell layoutNoDisturbView];
                JMSGUser *user = _memberArr[0];//单聊只有一个对象
                NSLog(@"%@",user.isNoDisturb ? @"yes" : @"no");
                [cell.nodisturbSwitch setOn:user.isNoDisturb animated:YES];
                cell.NoDisturbViewTitleLabel.text = @"消息免打扰";
                
                cell.didSelectNoDisturbBlock = ^(BOOL isNoDisturb){
                    NSLog(@"\n\n==消息免打扰: %@ ==\n\n",isNoDisturb?@"开启":@"关闭");
                    [user setIsNoDisturb:isNoDisturb handler:^(id resultObject, NSError *error) {
                        if (error) {
                            LogInfo(@"\n\n消息免打扰error:\n%@\n\n",error);
                        }
                        else{
                            LogInfo(@"\n\n消息免打扰resultObject:\n%@\n\n",resultObject);
                        }
                    }];
                };
            }
                break;
            case 1:
            {
                [cell layoutNoDisturbView];
                cell.NoDisturbViewTitleLabel.text = @"加入黑名单";
                JMSGUser *user = _memberArr[0];//单聊只有一个对象
                [cell.nodisturbSwitch setOn:user.isInBlacklist animated:YES];
                LogInfo(@"%@",user.isInBlacklist ? @"yes" : @"no");
                cell.didSelectNoDisturbBlock = ^(BOOL isNoDisturb){
                    NSLog(@"\n\n==加入黑名单: %@ ==\n\n",isNoDisturb?@"加入":@"删除");
                    if (isNoDisturb) {
                        [JMSGUser addUsersToBlacklist:[NSArray arrayWithObject:user.username] appKey:user.appKey completionHandler:^(id resultObject, NSError *error) {
                            if (error) {
                                LogInfo(@"\n\n加入黑名单error:\n%@\n\n",error);
                            }
                            else{
                                LogInfo(@"\n\n加入黑名单resultObject:\n%@\n\n",resultObject);
                            }
                        }];
                    }
                    else{
                        [JMSGUser delUsersFromBlacklist:[NSArray arrayWithObject:user.username] appKey:user.appKey completionHandler:^(id resultObject, NSError *error) {
                            if (error) {
                                LogInfo(@"\n\n删除黑名单error:\n%@\n\n",error);
                            }
                            else{
                                LogInfo(@"\n\n删除黑名单resultObject:\n%@\n\n",resultObject);
                            }
                        }];
                    }
                };
            }
                break;
            case 2:
                [cell layoutToClearChatRecord];
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
            {
                [cell layoutNoDisturbView];
                JMSGGroup *group = ((JMSGGroup *)(self.conversation.target));
                LogInfo(@"%@",group.isNoDisturb ? @"yes" : @"no");
                [cell.nodisturbSwitch setOn:group.isNoDisturb animated:YES];
                cell.didSelectNoDisturbBlock = ^(BOOL isNoDisturb){
                    NSLog(@"\n\n==消息免打扰: %@ ==\n\n",isNoDisturb?@"开启":@"关闭");                    [group setIsNoDisturb:isNoDisturb handler:^(id resultObject, NSError *error) {
                        if (error) {
                            LogInfo(@"\n\n消息免打扰error:\n%@\n\n",error);
                        }
                        else{
                            LogInfo(@"\n\n消息免打扰resultObject:\n%@\n\n",resultObject);
                        }
                    }];
                };
            }
                break;
            case 1:
                [cell setDataWithGroupName:((JMSGGroup *)_conversation.target).displayName];
                break;
            case 2:
                [cell layoutToClearChatRecord];
                break;
            case 3:
                cell.delegate = self;
                [cell layoutToQuitGroup];
                break;
            default:
                break;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        switch (indexPath.row) {
            case 2:
                [self tapToClearChatRecord];
                break;
                
            default:
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                [self tapToEditGroupName];
                break;
            case 2:
                [self tapToClearChatRecord];
                break;
            case 3:
                break;
            default:
                break;
        }
    }
}

- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

@end
