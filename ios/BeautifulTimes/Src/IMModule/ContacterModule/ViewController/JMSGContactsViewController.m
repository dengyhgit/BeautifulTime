//
//  JCHATContactsViewController.m
//  JPush IM
//
//  Created by Apple on 14/12/24.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JMSGContactsViewController.h"
#import "JMSGContacterCell.h"
#import "JMSGGroupListViewController.h"
#import "JMSGContactModel.h"
#import "JMSGFriendInvitationListViewController.h"
#import "JMSGChatViewController.h"


static NSString *kcellContacterIndentifier = @"contacterIndentifier";

@interface JMSGContactsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UIAlertViewDelegate>
{
    BOOL isCurrentVC;
    BOOL isHaveNewInvitation;
    UIButton *_rightBarButton;
}

@property (nonatomic,strong) NSMutableArray *keys ;
@property (strong,nonatomic)NSMutableDictionary *data;
@property (nonatomic,strong) NSMutableArray *otherKey;
@property (nonatomic, strong) UITableView *tableview;

//查找好友
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *allData;

@end
@implementation JMSGContactsViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(friendInvitiaonChangeNotification:)
                                                     name:kFriendInvitationNotification
                                                   object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    [self setupNavigation];
    if (!self.isSharePhote) {
        [self setupSearchBar];
    }
    [self.view addSubview:self.tableview];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isCurrentVC = YES;
    [self setAddFriendBadgeValue:nil];
    [self getFriendData];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    isCurrentVC = NO;
}

-(void)setAddFriendBadgeValue:(NSString *)value{
    //    NSArray *tabBarItems = self.navigationController.tabBarController.tabBar.items;
    //    UITabBarItem *personCenterTabBarItem = [tabBarItems objectAtIndex:1];
    //    personCenterTabBarItem.badgeValue = value;//显示消息条数为 2
}

#pragma mark - FriendInvitationNotification
- (void)friendInvitiaonChangeNotification:(NSNotification *)notification{
    
    JMSGFriendNotificationEvent *event = (JMSGFriendNotificationEvent *)notification.object;
    if (event.eventType == kJMSGEventNotificationDeletedFriend || event.eventType == kJMSGEventNotificationAcceptedFriendInvitation) {
        [self getFriendData];
        return ;
    }
    if (event.eventType == kJMSGEventNotificationReceiveFriendInvitation ) {
        [self setAddFriendBadgeValue: isCurrentVC ? nil : @"1"];
        isHaveNewInvitation = YES;
        [_tableview reloadData];
    }
    [JMSGFriendInvitationListViewController addCacheForFriendInvitaionWithEvent:event];
}

- (void)setupNavigation {
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBarButton setFrame:CGRectMake(0, 0, 50, 30)];
    [_rightBarButton addTarget:self action:@selector(addFriendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBarButton setImage:BT_UIIMAGE(@"createConversation") forState:UIControlStateNormal];
    [_rightBarButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -15 * [UIScreen mainScreen].scale)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

-(void)addFriendBtnClick:(UIButton *)sender {
    UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"添加好友"
                                                      message:@"输入用户名"
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                            otherButtonTitles:@"确定", nil];
    alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *userName = [alerView textFieldAtIndex:0];
    userName.placeholder = @"用户名";
    [alerView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[alertView textFieldAtIndex:1] resignFirstResponder];
        
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""]) {
            [MBProgressHUD showMessage:@"请输入用户名" view:self.view];
            return;
        }
        [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
        [JMSGFriendManager sendInvitationRequestWithUsername:[alertView textFieldAtIndex:0].text appKey:nil reason:nil completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if (!error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [MBProgressHUD showMessage:@"发送邀请成功" view:self.view];
            } else {
                [MBProgressHUD showMessage:@"发送邀请失败" view:self.view];
            }
        }];
    }
}

#pragma mark 获得好朋友
-(void)getFriendData
{
    [JMSGFriendManager getFriendList:^(id resultObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error) {
                NSArray *array = (NSArray *)resultObject;
                
                NSMutableArray *modelArray = [NSMutableArray array];
                for (int i = 0; i < array.count; i++) {
                    JMSGContactModel *model = [[JMSGContactModel alloc] init];
                    model.user = array[i];
                    [modelArray addObject:model];
                }
                [_data removeAllObjects];
                self.allData = modelArray;
                _data = [self dictionaryOrderByCharacterWithOriginalArray:modelArray];
                _keys = [NSMutableArray arrayWithArray:[_data allKeys]];
                [_tableview reloadData];
            }
        });
    }];
}


#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    self.searchController.searchBar.frame = CGRectMake(0, 0, kApplicationWidth, 36);
    self.searchController.searchBar.barStyle = UIBarStyleDefault;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    //取消首字母吧大写
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.layer.borderWidth = 0;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth, 36)];
    searchView.backgroundColor = [[UIColor alloc] initWithRed:189 green:189 blue:195 alpha:0.7f];
    [searchView addSubview:self.searchController.searchBar];
    self.tableview.tableHeaderView = searchView;
}


#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.searchController.active || self.isSharePhote) {
        return 1;
    } else {
        return self.keys.count + 1;//新朋友、群聊 在同一个section
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.searchList.count;
    }
    if (section == 0 && self.isSharePhote) {
        
        NSArray *arr=[self.data objectForKey:self.keys.firstObject];
        
        return arr.count;
    }
    if (section == 0 && !self.isSharePhote) {
        return  2;//新朋友、群聊
    } else {
    
    }
    NSString *key;
    if (self.isSharePhote) {
        key = self.keys[section];
    } else {
        key = self.keys[section-1];
    }
    
    NSArray *arr=[self.data objectForKey:key];
    
    return arr.count;
}

#pragma mark 设置每个区的标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return nil;
    }
    if (section == 0) {
        return  nil;//群组
    }
    
    NSString *title=self.keys[section-1];
    return title;
}

#pragma mark 表单元的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSGContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellContacterIndentifier];
    if (!cell) {
        cell = [[JMSGContacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellContacterIndentifier];
    }
    
    
    cell.badgeIcon.hidden = YES;
    
    if (self.searchController.active) {
        JMSGContactModel *model = self.searchList[indexPath.row];
        cell.friendName.text = model.name;
        [model.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (data) {
                cell.headIcon.image = [[UIImage alloc] initWithData:data];
            }
        }];
        return cell;
    }
    
    if (indexPath.section == 0 && !self.isSharePhote) {
        cell.friendName.text = indexPath.row == 0 ? @"新朋友" : @"群聊";
        if (indexPath.row == 0 && isHaveNewInvitation ) {
            cell.badgeIcon.hidden = NO;
        }
        cell.headIcon.image = [UIImage imageNamed:@"headDefalt"];
    }
    else{
        NSString *key;
        if (self.isSharePhote) {
            key = self.keys[indexPath.section];
        } else {
            key = self.keys[indexPath.section - 1];
        }
        NSArray *arr = [self.data objectForKey:key];
        JMSGContactModel *model = arr[indexPath.row];
        cell.friendName.text = model.name;
        [model.user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (data) {
                cell.headIcon.image = [[UIImage alloc] initWithData:data];
            }
        }];
    }
    return cell;
}
//编辑状态
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//按钮呈现名称
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
//删除操作
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //数组、数据库中得数据相应删除
    //数组数据相应删除
    NSInteger section = indexPath.section-1;
    NSString *key = self.keys[section];
    NSArray *arr = [self.data objectForKey:key];
    JMSGContactModel *model = arr[indexPath.row];
    
    [MBProgressHUD showMessage:@"请稍后..." toView:self.view];
    [JMSGFriendManager removeFriendWithUsername:model.user.username appKey:model.user.appKey completionHandler:^(id resultObject, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if (!error) {
                [self.keys removeObjectAtIndex:section];
                [self.data removeObjectForKey:key];
                [self.tableview reloadData];
                [MBProgressHUD showMessage:@"删除好友成功" view:self.view];
            }
            else{
                [MBProgressHUD showMessage:@"删除好友失败" view:self.view];
            }
        });
    }];
}

#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.isSharePhote) {
        NSInteger section = indexPath.section;
        NSString *key = self.keys[section];
        NSArray *arr = [self.data objectForKey:key];
        JMSGContactModel *model = arr[indexPath.row];
        NSData *imageData = UIImageJPEGRepresentation(self.sharePhoto, 0.5);
        [JMSGMessage sendSingleImageMessage:imageData toUser:model.user.username];
        [MBProgressHUD showSuccess:@"分享成功" toView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        return ;
    }
    if (self.searchController.active) {
        
        JMSGChatViewController *chatVC = [[JMSGChatViewController alloc] init];
        chatVC.hidesBottomBarWhenPushed = YES;
        JMSGContactModel *model = self.searchList[indexPath.row];
        // SDK：获取单聊会话
        WS(weakSelf);
        [JMSGConversation createSingleConversationWithUsername:model.user.username completionHandler:^(id resultObject, NSError *error) {
            if (!error) {
                JMSGConversation *conversation = (JMSGConversation *)resultObject;
                chatVC.conversation = conversation;
                weakSelf.searchController.active = NO;
                [self.tableview reloadData];
                [weakSelf.navigationController pushViewController:chatVC animated:YES];
            }
        }];
        
    } else {
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                isHaveNewInvitation = NO;
                JMSGFriendInvitationListViewController *VC = [[JMSGFriendInvitationListViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
            else if (indexPath.row == 1){
                JMSGGroupListViewController *VC = [[JMSGGroupListViewController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];
            }
        }
        else{
            JMSGChatViewController *chatVC = [[JMSGChatViewController alloc] init];
            chatVC.hidesBottomBarWhenPushed = YES;
            NSInteger section = indexPath.section-1;
            NSString *key = self.keys[section];
            NSArray *arr = [self.data objectForKey:key];
            JMSGContactModel *model = arr[indexPath.row];
            // SDK：获取单聊会话
            [JMSGConversation createSingleConversationWithUsername:model.user.username completionHandler:^(id resultObject, NSError *error) {
                if (!error) {
                    JMSGConversation *conversation = (JMSGConversation *)resultObject;
                    chatVC.conversation = conversation;
                    [self.navigationController pushViewController:chatVC animated:YES];
                }
            }];
        }
    }
}

#pragma mark 返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

#pragma mark 返回标示图的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.searchController.active) {
        return nil;
    } else {
        return self.keys;
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [NSMutableArray arrayWithArray:[self.allData filteredArrayUsingPredicate:preicate]];
    [self.tableview reloadData];
}

#pragma mark - 联系人分类
- (NSMutableDictionary *)dictionaryOrderByCharacterWithOriginalArray:(NSArray *)array {
    if (array.count == 0) {
        return nil;
    }
    for (JMSGContactModel *obj  in array) {
        if (![obj.name isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    UILocalizedIndexedCollation *indexedCollation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *modelArrayObjects = [NSMutableArray arrayWithCapacity:indexedCollation.sectionTitles.count];
    //创建27个分组
    for (int i = 0; i < indexedCollation.sectionTitles.count; i++) {
        NSMutableArray *obj = [NSMutableArray array];
        [modelArrayObjects addObject:obj];
    }
    //按字母顺序进行分组
    for (int i = 0; i < array.count ; i++) {
        JMSGContactModel *model = array[i];
        NSInteger index = [indexedCollation sectionForObject:model.name collationStringSelector:@selector(uppercaseString)];
        [[modelArrayObjects objectAtIndex:index] addObject:model];
    }
    //去掉空数组
    for (int i = 0; i < modelArrayObjects.count; i++) {
        NSMutableArray *obj = modelArrayObjects[i];
        if (obj.count == 0) {
            [modelArrayObjects removeObject:obj];
        }
    }
    NSMutableDictionary *contactDic = [NSMutableDictionary dictionary];
    
    //获取索引字母
    for (NSMutableArray *oneObjArray in modelArrayObjects) {
        JMSGContactModel *model = oneObjArray[0];
        NSString *str = [model.name mutableCopy];
        NSString *key =[self firstCharacterWithString:str];
        [contactDic setObject:oneObjArray forKey:key];
    }
    
    return contactDic;
}
//获取字符串（或汉字）首字母
- (NSString *)firstCharacterWithString:(NSString *)string {
    NSMutableString *str = [NSMutableString stringWithString:string];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    NSString *pingyin = [str capitalizedString];
    NSString *key = [pingyin substringToIndex:1];
    return key;
}

#pragma mark setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableview.delegate = self;
        _tableview.dataSource =self;
        _tableview.sectionIndexColor = [UIColor grayColor];
        _tableview.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    return _tableview;
}

-(NSMutableArray *)keys
{
    if(_keys==nil) {
        _keys=[NSMutableArray array];
    }
    return _keys;
}
-(NSMutableDictionary *)data
{
    if(!_data){
        _data = [NSMutableDictionary dictionary];
    }
    return _data;
}

-(NSMutableArray *)otherKey
{
    if(_otherKey==nil){
        _otherKey=[NSMutableArray array];
    }
    return _otherKey;
}

- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
    }
    return _searchController;
}

- (NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc] init];
    }
    return _searchList;
}

- (NSMutableArray *)allData {
    if (!_allData) {
        _allData = [[NSMutableArray alloc] init];
    }
    return _allData;
}

@end
