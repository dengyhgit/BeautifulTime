//
//  JMSGGroupListViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGGroupListViewController.h"
//#import "JMSGChatViewController.h"
#import "JMSGChatViewController.h"

static NSString *kGroupListCell = @"kGroupListCell";

@interface JMSGGroupListViewController () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dateSource;

@end

@implementation JMSGGroupListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMyGroupList];
    [self.view addSubview:self.tableView];
    self.title = @"群组列表";
}

- (void)viewDidLayoutSubviews {
    WS(weakSelf);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getMyGroupList {
    WS(weakSelf);
    [MBProgressHUD showMessage:@"加载中..." view:self.view];
    [JMSGGroup myGroupArray:^(id resultObject, NSError *error) {
        if (error) {
            return ;
        }
        if (resultObject) {
            NSArray *array = (NSArray *)resultObject;
            for (int i = 0; i < array.count; i ++) {
                [JMSGGroup groupInfoWithGroupId:[NSString stringWithFormat:@"%@", array[i]] completionHandler:^(id resultObject, NSError *error) {
                    if (error) {
                        return ;
                    }
                    if (resultObject) {
                        JMSGGroup *group = (JMSGGroup *)resultObject;
                        [weakSelf.dateSource addObject:group];
                        if (weakSelf.dateSource.count == array.count) {
                            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                            BTMAINTHREAD(^{
                                [weakSelf.tableView reloadData];
                            });
                        }
                    }
                }];
            }
        }
    }];
}

#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dateSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kGroupListCell];
    if(!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kGroupListCell];
    }
    
    JMSGGroup *group = self.dateSource[indexPath.row];
//    NSLog(@"-----------%@", group.name);
//    NSLog(@"-----------%@", group.gid);
    cell.textLabel.text = [group.name isEqualToString:@""] || !group.name ? group.gid : group.name;
    cell.detailTextLabel.text =group.desc;
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    JMSGGroup *group = self.dateSource[indexPath.row];
    
    __block JMSGChatViewController *sendMessageCtl =[[JMSGChatViewController alloc] init];
    WS(weakSelf);
    sendMessageCtl.superViewController = self;
    sendMessageCtl.hidesBottomBarWhenPushed = YES;
    //SDK：创建群聊会话
    [JMSGConversation createGroupConversationWithGroupId:group.gid completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        if (error == nil) {
            sendMessageCtl.conversation = (JMSGConversation *)resultObject;
            BTMAINTHREAD(^{
                [strongSelf.navigationController pushViewController:sendMessageCtl animated:YES];
            });
        } else {
        }
    }];
    
}

#pragma mark setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
        _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

- (NSMutableArray *)dateSource {
    if (!_dateSource) {
        _dateSource = [[NSMutableArray alloc] init];
    }
    return _dateSource;
}

@end
