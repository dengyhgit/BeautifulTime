//
//  BTIMHomePageViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/21.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTIMHomePageViewController.h"
#import "BTChatMessageCell.h"
#import "BTMessageListModel.h"
#import "BTContacterModel.h"
#import "BTChatViewController.h"
#import "AppDelegate.h"

static NSString *cellIdentifier = @"chatMessageListCell";

@interface BTIMHomePageViewController () <UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) int messageCount;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchList;

@end

@implementation BTIMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self.view addSubview:self.tableView];
    [self readChatData];
    
    //监听消息来得通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessage:) name:SendMsgName object:nil];
    //监听删除好友时发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriendHandle:) name:DeleteFriend object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readChatData
{
    [JMSGConversation allConversations:^(id resultObject, NSError *error) {
        if (!error) {
            NSArray *arr = (NSArray *)resultObject;
            self.dataSource = [arr mutableCopy];
            for(JMSGConversation *conv in arr){
                self.messageCount += conv.unreadCount.intValue;
            }
            //如果消息数大于0
            if(self.messageCount>0){
                //如果消息总数大于99
                if(self.messageCount >= 99){
                    self.tabBarItem.badgeValue = @"99+";
                }else{
                    self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",self.messageCount];
                }
                
            }
            [self.tableView reloadData];
        }
    }];
    
}

#pragma mark 收到新消息时更新状态
- (void)updateMessage:(NSNotification*)note {
//    NSDictionary *dict = [note object];
//    NSString *uname = [dict objectForKey:@"uname"];
//    NSString *body = [dict objectForKey:@"body"];
//    XMPPJID *jid = [dict objectForKey:@"jid"];
//    NSDate *time = [dict objectForKey:@"time"];
//    NSString *user = [dict objectForKey:@"user"];
    
//    BOOL isCurrentChatingFriend = NO;
//    if ([self.navigationController.viewControllers.lastObject isKindOfClass:[BTChatViewController class]]) {
//        BTChatViewController *VC = (BTChatViewController*)self.navigationController.viewControllers.lastObject;
//        if ([VC.contacter.jid.user isEqual:jid.user]) {
//            isCurrentChatingFriend = YES;
//        }
//    }
    
//    if([user isEqualToString:@"other"] && !isCurrentChatingFriend){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.messageCount++;
//            if(self.messageCount >= 99){
//                self.tabBarItem.badgeValue = @"99+";
//            }else{
//                self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
//            }
//        });
//    }
    
    

//    if([[BTMessageListDBTool sharedInstance] selectUname:uname]){
//        dispatch_async(dispatch_get_main_queue(), ^{
//            for(int i = 0; i < self.dataSource.count; i++){
//                BTMessageListModel *model = self.dataSource[i];
//                if([model.uname isEqualToString:uname]){
//                    model.body = body;
//                    model.time = time;
//                
//                    //如果是正在和我聊天的用户 才设置badgeValue
//                    if([user isEqualToString:@"other"] && !isCurrentChatingFriend){
//                        int currentV = [model.badgeValue intValue] + 1;
//                        model.badgeValue = [NSString stringWithFormat:@"%d",currentV];
//                    }
//                    [self.dataSource removeObjectAtIndex:i];
//                    [self.dataSource insertObject:model atIndex:0];
//                    [self.tableView reloadData];
////                    [[BTMessageListDBTool sharedInstance] updateWithName:uname detailName:body time:time badge:model.badgeValue];
//                    break;
//                }
//            }
//        });

//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            BTMessageListModel *model = [[BTMessageListModel alloc]init];
//            model.uname = uname;
//            model.body = body;
////            model.jid = jid;
//            model.time = time;
//            if([user isEqualToString:@"other"]){
//                model.badgeValue = @"1";
//            }else{
//                model.badgeValue = nil;
//            }
//            
//            [self.dataSource insertObject:model atIndex:0];
//            [self.tableView reloadData];
////            [[BTMessageListDBTool sharedInstance] addHead:nil uname:uname detailName:body time:time badge:model.badgeValue xmppjid:jid];
//        });
//    }
}

#pragma mark 好友被删除时更新记录
- (void)deleteFriendHandle:(NSNotification*)note {
    NSString *uname = [note object];
    //初始化模型的索引
    NSInteger index = 0;
    for(BTMessageListModel *model in self.dataSource){
        if([model.uname isEqualToString:uname]){
            [self.dataSource removeObjectAtIndex:index];
//            [[BTMessageListDBTool sharedInstance] deleteWithName:uname];
            [self.tableView reloadData];
        }
        index++;
    }
}

#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    self.searchController.searchBar.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, 36);
    self.searchController.searchBar.barStyle = UIBarStyleDefault;
    self.searchController.searchBar.backgroundColor = [UIColor whiteColor];
    //取消首字母吧大写
    self.searchController.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchController.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchController.searchBar.placeholder = @"搜索";
    self.searchController.searchBar.layer.borderWidth = 0;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, 36)];
    searchView.backgroundColor = [[UIColor alloc] initWithRed:189 green:189 blue:195 alpha:0.7f];
    [searchView addSubview:self.searchController.searchBar];
    self.tableView.tableHeaderView = searchView;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataSource count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BTChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.searchController.active) {
        [cell bindData:self.searchList[indexPath.row]];
    }
    else{
        [cell bindData:self.dataSource[indexPath.row]];
    }
    return cell;
}

#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JMSGConversation *conv = self.dataSource[indexPath.row];
    
    self.messageCount = self.messageCount - conv.unreadCount.intValue;
    if(self.messageCount > 0){
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d",self.messageCount];
    }else{
        self.tabBarItem.badgeValue = nil;
    }
    [self.tableView reloadData];
    
    BTChatViewController *chatVc = [[BTChatViewController alloc] init];
    chatVc.conversation = conv;
    [self.navigationController pushViewController:chatVc animated:YES];
}


#pragma mark 滑动删除单元格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 改变删除单元格按钮的文字
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark 单元格删除的点击事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTMessageListModel *model = self.dataSource[indexPath.row];
//    NSString *name = model.uname;
    //当点击删除按钮的时候执行
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //删除对应的红色提醒按钮
        int badge=[model.badgeValue intValue];
        if(badge>0){
            _messageCount=_messageCount-badge;
            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",_messageCount];
        }
        
        NSInteger count=indexPath.row;
        //删除模型
        [self.dataSource removeObjectAtIndex:count];
        [self.tableView reloadData];
//        [[BTMessageListDBTool sharedInstance] deleteWithName:name];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"uname CONTAINS[cd] %@", searchString];
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    self.searchList = [NSMutableArray arrayWithArray:[self.dataSource filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}


#pragma -mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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

@end
