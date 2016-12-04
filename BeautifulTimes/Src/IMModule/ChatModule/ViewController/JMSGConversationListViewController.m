//
//  JMSGConversationListViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGConversationListViewController.h"
#import "JMSGConversationListCell.h"
#import "JMSGChatViewController.h"
#import "JMSGCreateGroupViewController.h"

@interface JMSGConversationListViewController ()
{
    __block NSMutableArray *_conversationArr;
    UIButton *_rightBarButton;
    NSInteger _unreadCount;
    UILabel *_titleLabel;
}

@property (nonatomic, strong) UIImageView *addBgView;

@end

@implementation JMSGConversationListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.title = @"会话";
    [self setupNavigation];
    [self addNotifications];
    [self setupBubbleView];
    [self setupChatTable];
    //数据库升级
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    if (!appDelegate.isDBMigrating) {
        [self addDelegate];
    } else {
        [MBProgressHUD showMessage:@"正在升级数据库" toView:self.view];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getConversationList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupNavigation {
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarButton setFrame:CGRectMake(0, 0, 50, 30)];
    [_rightBarButton addTarget:self action:@selector(addBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarButton setImage:JMSG_UIIMAGE(@"createConversation") forState:UIControlStateNormal];
    [_rightBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15 * [UIScreen mainScreen].scale)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectClose)
                                                 name:kJPFNetworkDidCloseNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkConnectSetup)
                                                 name:kJPFNetworkDidSetupNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectSucceed)
                                                 name:kJPFNetworkDidLoginNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnecting)
                                                 name:kJPFNetworkIsConnectingNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dBMigrateFinish)
                                                 name:kDBMigrateFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(creatGroupSuccessToPushView:)
                                                 name:kCreatGroupState
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(skipToSingleChatView:)
                                                 name:kSkipToSingleChatViewState
                                               object:nil];
}

//add view
- (void)setupBubbleView {
    _addBgView = [[UIImageView alloc] initWithFrame:CGRectMake(kApplicationWidth - 100, 1, 100, 130)];
    [_addBgView setBackgroundColor:JMSG_CLEARCOLOR];
    [_addBgView setUserInteractionEnabled:YES];
    UIImage *frameImg = JMSG_UIIMAGE(@"frame");
    frameImg = [frameImg resizableImageWithCapInsets:UIEdgeInsetsMake(30, 10, 30, 64) resizingMode:UIImageResizingModeTile];
    [_addBgView setImage:frameImg];
    [_addBgView setHidden:YES];
    [self.view addSubview:self.addBgView];
    [self.view bringSubviewToFront:self.addBgView];
    [self addBtn];
}

- (void)setupChatTable {
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _chatTableView.touchDelegate = self;
    [_chatTableView registerNib:[UINib nibWithNibName:@"JMSGConversationListCell" bundle:nil] forCellReuseIdentifier:@"JMSGConversationListCell"];
}

- (void)addDelegate {
    [JMessage addDelegate:self withConversation:nil];
}

- (void)skipToSingleChatView :(NSNotification *)notification {
    JMSGUser *user = [[notification object] copy];
    __block JMSGChatViewController *sendMessageCtl =[[JMSGChatViewController alloc] init];//!!
    WS(weakSelf);
    sendMessageCtl.superViewController = self;
    //SDK：创建单聊会话
    [JMSGConversation createSingleConversationWithUsername:user.username completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            LogInfo(@"createSingleConversationWithUsername success");
            sendMessageCtl.conversation = resultObject;
            JMSGMAINTHREAD(^{
                sendMessageCtl.hidesBottomBarWhenPushed = YES;
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            LogInfo(@"createSingleConversationWithUsername error:%@", error);
        }
    }];
}

- (void)dBMigrateFinish {
    NSLog(@"Migrate is finish  and get allconversation");
    JMSGMAINTHREAD(^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    [self addDelegate];
    [self getConversationList];
}

#pragma mark --创建群成功Push group viewctl
- (void)creatGroupSuccessToPushView:(NSNotification *)object{
    __block JMSGChatViewController *sendMessageCtl =[[JMSGChatViewController alloc] init];
    WS(weakSelf);
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    //SDK：创建群聊会话
    [JMSGConversation createGroupConversationWithGroupId:((JMSGGroup *)[object object]).gid completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = (JMSGConversation *)resultObject;
            JMSGMAINTHREAD(^{
                LogInfo(@"createGroupConversationwithgroupid success");
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
            LogInfo(@"createGroupConversationwithgroupid fail");
        }
    }];
    
}

- (void)netWorkConnectClose {
    _titleLabel.text =@"未连接";
}

- (void)netWorkConnectSetup {
    _titleLabel.text =@"收取中...";
}

- (void)connectSucceed {
    _titleLabel.text =@"会话";
}

- (void)isConnecting {
    _titleLabel.text =@"连接中...";
}

#pragma mark JMSGMessageDelegate
- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    LogInfo(@"Action -- onReceivemessage %@",message);
    [self getConversationList];
}

- (void)onConversationChanged:(JMSGConversation *)conversation {
    LogInfo(@"Action -- onConversationChanged");
    [self getConversationList];
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    LogInfo(@"Action -- onGroupInfoChanged");
    [self getConversationList];
}

- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event {
    NSLog(@"\n\n === Notification Event === \n\n event 2 =:%@ \n\n === Notification Event === \n",@(event.eventType));
}

- (void)getConversationList {
    [self.addBgView setHidden:YES];
    //SDK：conversation 列表
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        JMSGMAINTHREAD(^{
            if (error == nil) {
                LogInfo(@"get allConversation success");
                _conversationArr = [self sortConversation:resultObject];
                _unreadCount = 0;
                for (NSInteger i=0; i < [_conversationArr count]; i++) {
                    JMSGConversation *conversation = [_conversationArr objectAtIndex:i];
                    _unreadCount = _unreadCount + [conversation.unreadCount integerValue];
                }
                [self saveBadge:_unreadCount];
            } else {
                _conversationArr = nil;
                LogInfo(@"get allConversation error:%@", error);
            }
            [self.chatTableView reloadData];
        });
    }];
}

#pragma mark --排序conversation
- (NSMutableArray *)sortConversation:(NSMutableArray *)conversationArr {
    NSArray *sortResultArr = [conversationArr sortedArrayUsingFunction:sortType context:nil];
    return [NSMutableArray arrayWithArray:sortResultArr];
}

NSInteger sortType(id object1,id object2,void *cha) {
    JMSGConversation *model1 = (JMSGConversation *)object1;
    JMSGConversation *model2 = (JMSGConversation *)object2;
    if([model1.latestMessage.timestamp integerValue] > [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedAscending;
    } else if([model1.latestMessage.timestamp integerValue] < [model2.latestMessage.timestamp integerValue]) {
        return NSOrderedDescending;
    }
    return NSOrderedSame;
}

//添加 addBgView 的子view
- (void)addBtn {
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
            [btn setTitle:@"发起群聊" forState:UIControlStateNormal];
        }
        if (i == 1) {
            [btn setTitle:@"添加朋友" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [btn setTitle:@"跨应用会话" forState:UIControlStateNormal];
        }
        
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i + 100;
        [btn setFrame:CGRectMake(10, i * 30 + 30, 80, 30)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [btn setBackgroundImage:[JMSGViewUtil colorImage:UIColorFromRGB(0x4880d7) frame:btn.frame] forState:UIControlStateHighlighted];
        [self.addBgView addSubview:btn];
    }
}

- (void)btnClick :(UIButton *)btn {
    [self.addBgView setHidden:YES];
    if (btn.tag == 100) {
        //直接跳转到创建群聊页面
        JMSGCreateGroupViewController *createGroupVC =[[JMSGCreateGroupViewController alloc] init];
        UINavigationController *createGroupNav =[[UINavigationController alloc] initWithRootViewController:createGroupVC];
        [self.navigationController presentViewController:createGroupNav animated:YES completion:nil];
        
    } else if (btn.tag == 101) {
        
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友"
                                                          message:@"输入好友用户名!"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
        alerView.tag = 20011;
        [alerView show];
    } else {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"创建跨应用会话"
                                                          message:@"输入用户名和对方的AppKey"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        UITextField *userName = [alerView textFieldAtIndex:0];
        userName.placeholder = @"用户名";
        UITextField *appKey = [alerView textFieldAtIndex:1];
        //        appKey.placeholder = @"AppKey";
        appKey.text = @"d56cf91c2f4652901c3c4c13";
        alerView.tag = 20022;
        [alerView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[alertView textFieldAtIndex:0] resignFirstResponder];
        __block JMSGChatViewController *sendMessageCtl = [[JMSGChatViewController alloc] init];
        sendMessageCtl.superViewController = self;
        sendMessageCtl.hidesBottomBarWhenPushed = YES;
        WS(weakSelf);
        
        if (alertView.tag == 20011) {
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
                [MBProgressHUD showMessage:@"请输入用户名" view:self.view];
                return;
            }
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            //SKD：创建单聊会话
            [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text completionHandler:^(id resultObject, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    sendMessageCtl.conversation = resultObject;
                    [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                } else {
                    LogInfo(@"createSingleConversationWithUsername fail");
                    [MBProgressHUD showMessage:@"添加的用户不存在" view:self.view];
                }
            }];
        } else {
            [[alertView textFieldAtIndex:1] resignFirstResponder];
            if ([[alertView textFieldAtIndex:0].text isEqualToString:@""] || [[alertView textFieldAtIndex:1].text isEqualToString:@""]) {
                [MBProgressHUD showMessage:@"请输入用户名和AppKey" view:self.view];
                return;
            }
            [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
            //SKD：创建跨应用会话
            [JMSGConversation createSingleConversationWithUsername:[alertView textFieldAtIndex:0].text appKey:[alertView textFieldAtIndex:1].text  completionHandler:^(id resultObject, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
                if (!error) {
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    __strong __typeof(weakSelf) strongSelf = weakSelf;
                    sendMessageCtl.conversation = resultObject;
                    [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
                } else {
                    LogInfo(@"创建跨应用会话失败");
                    [MBProgressHUD showMessage:@"添加的跨应用用户不存在" view:self.view];
                }
            }];
        }
    }
}

- (void)addBtnClick:(UIButton *)btn {
    
    
    if (btn.selected) {
        btn.selected = NO;
        [self.addBgView setHidden:YES];
    } else {
        btn.selected = YES;
        [self.addBgView setHidden:NO];
    }
    [self.view bringSubviewToFront:self.addBgView];
}

- (void)tableView:(UITableView *)tableView
     touchesBegan:(NSSet *)touches
        withEvent:(UIEvent *)event {
    [self.addBgView setHidden:YES];
    _rightBarButton.selected = NO;
}

#pragma mark tableview delegate
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        //SDK：删除单聊会话
        //        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username];
        [JMSGConversation deleteSingleConversationWithUsername:((JMSGUser *)conversation.target).username appKey:conversation.targetAppKey];
    } else {
        //SDK：删除群聊会话
        [JMSGConversation deleteGroupConversationWithGroupId:((JMSGGroup *)conversation.target).gid];
    }
    
    [_conversationArr removeObjectAtIndex:indexPath.row];
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_conversationArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"JMSGConversationListCell";
    JMSGConversationListCell *cell = (JMSGConversationListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    JMSGConversation *conversation =[_conversationArr objectAtIndex:indexPath.row];
    [cell setCellDataWithConversation:conversation];
    cell.selected = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [_conversationArr count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMSGChatViewController *chatVC = [[JMSGChatViewController alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    chatVC.superViewController = self;
    JMSGConversation *conversation = [_conversationArr objectAtIndex:indexPath.row];
    
    //此处只为测试接口，不考虑性能
    //SDK：异步获取所有消息记录
    [conversation allMessages:^(id resultObject, NSError *error) {
        NSArray *array = (NSArray *)resultObject;
        LogInfo(@"消息数：%ld", (long)array.count);
    }];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = conversation.target;
        // SDK：获取单聊会话
        conversation = [JMSGConversation singleConversationWithUsername:user.username appKey:conversation.targetAppKey];
        if (!conversation) {
            LogInfo(@"%s", "singleConversationWithUsername is bad");
        }
    } else {
        JMSGGroup *group = conversation.target;
//        JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:@"@人消息"];
//        //SDK：创建消息对象
//        [JMSGUser userInfoArrayWithUsernameArray:@[@"dyh01"] completionHandler:^(id resultObject, NSError *error) {
//            NSArray *users = (NSArray *)resultObject;
//            JMSGMessage *message = [JMSGMessage createGroupMessageWithContent:textContent groupId:group.gid at_list:@[users.firstObject]];
//            [conversation sendMessage:message];
//        }];
        
        // SDK：获取群聊会话
        conversation = [JMSGConversation groupConversationWithGroupId:group.gid];
        if (!conversation) {
            LogInfo(@"%s", "groupConversationWithGroupId is bad");
        }
    }
    chatVC.conversation = conversation;
    [self.navigationController pushViewController:chatVC animated:YES];
    NSInteger badge = _unreadCount - [conversation.unreadCount integerValue];
    [self saveBadge:badge];
}

//小红点
- (void)saveBadge:(NSInteger)badge {
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%zd",badge] forKey:kBADGE];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
