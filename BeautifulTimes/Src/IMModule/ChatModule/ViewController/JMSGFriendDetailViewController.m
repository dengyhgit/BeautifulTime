//
//  JMSGFriendDetailViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFriendDetailViewController.h"
#import "JMSGPersonInfoCell.h"
#import "JMSGChatViewController.h"

#define kSeparateLineFrame CGRectMake(0, 150-0.5,kApplicationWidth, 0.5)
#define kHeadViewFrame CGRectMake((kApplicationWidth - 70)/2, (150-70)/2, 70, 70)
#define kNameLabelFrame CGRectMake(0, 150-40, kApplicationWidth, 40)

@interface JMSGFriendDetailViewController ()<UIAlertViewDelegate> {
    NSMutableArray *_titleArr;
    NSMutableArray *_imgArr;
    NSMutableArray *_infoArr;
}

@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation JMSGFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    [self setupSubview];
    [self loadUserInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubview {
    _detailTableView.dataSource = self;
    _detailTableView.delegate = self;
    _detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.detailTableView.frame.size.width, 150)];
    _detailTableView.tableHeaderView = tableHeadView;
    UILabel *separateline = [[UILabel alloc] initWithFrame:kSeparateLineFrame];
    [separateline setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
    [tableHeadView addSubview:separateline];
    [tableHeadView addSubview:self.headView];
    [tableHeadView addSubview:self.nameLabel];
}

- (void)loadUserInfoData {
    _titleArr = [NSMutableArray arrayWithObjects:@"性别", @"地区", @"个性签名", nil];
    _imgArr = [NSMutableArray arrayWithObjects:@"gender", @"location_21", @"signature", nil];
    
    if (self.userInfo.isFriend) {
        [_titleArr insertObject:@"备注" atIndex:0];
        [_imgArr insertObject:@"signature" atIndex:0];
    }
    _infoArr = [[NSMutableArray alloc]init];
    [MBProgressHUD showMessage:@"正在加载！" toView:self.view];
    WS(weakSelf);
    [JMSGUser userInfoArrayWithUsernameArray:@[self.userInfo.username] completionHandler:^(id resultObject, NSError *error) {
        __strong __typeof(weakSelf) strongSelf = weakSelf;
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
        if (error) {
            [_headView setImage:[UIImage imageNamed:@"headDefalt"]];
            [MBProgressHUD showMessage:@"获取数据失败！" view:self.view];
            return;
        }
        JMSGUser *user = resultObject[0];
        self.userInfo = user;
        [self.userInfo thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error == nil) {
                if (data != nil) {
                    [_headView setImage:[UIImage imageWithData:data]];
                } else {
                    [_headView setImage:[UIImage imageNamed:@"headDefalt"]];
                }
            } else {
                
            }
        }];

        _nameLabel.text = self.userInfo.displayName;
        
        if (self.userInfo.isFriend) {
            [_infoArr addObject:self.userInfo.noteName?self.userInfo.noteName:@"未设置"];
        }
        
        if (self.userInfo.gender == kJMSGUserGenderUnknown) {
            [_infoArr addObject:@"未知"];
        } else if (self.userInfo.gender == kJMSGUserGenderMale) {
            [_infoArr addObject:@"男"];
        } else {
            [_infoArr addObject:@"女"];
        }
        
        if (self.userInfo.region) {
            [_infoArr addObject:user.region];
        } else {
            [_infoArr addObject:@""];
        }
        
        if (self.userInfo.signature) {
            [_infoArr addObject:user.signature];
        } else {
            [_infoArr addObject:@""];
        }
        
        [strongSelf.detailTableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_titleArr count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == [_titleArr count]) {
        static NSString *cellIdentifier = @"JMSGFriendDetailMessgeCell";
        JMSGFriendDetailMessgeCell *cell = (JMSGFriendDetailMessgeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JMSGFriendDetailMessgeCell" owner:self options:nil] lastObject];
        }
        cell.skipToSendMessage = self;
        return cell;
    } else {
        static NSString *cellIdentifier = @"JMSGPersonInfoCell";
        JMSGPersonInfoCell *cell = (JMSGPersonInfoCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JMSGPersonInfoCell" owner:self options:nil] lastObject];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.infoTitleLabel.text=[_titleArr objectAtIndex:indexPath.row];
        if ([_infoArr count] >0) {
            cell.personInfoConten.text=[_infoArr objectAtIndex:indexPath.row];
        }
        cell.arrowImg.hidden = YES;
        cell.titleImgView.image=[UIImage imageNamed:[_imgArr objectAtIndex:indexPath.row]];
        return cell;
    }
}

- (void)skipToSendMessage {
    for (UIViewController *ctl in self.navigationController.childViewControllers) {
        if ([ctl isKindOfClass:[JMSGChatViewController class]]) {
            if (self.isGroupFlag) {
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:kSkipToSingleChatViewState object:_userInfo];
            } else {
                [self.navigationController popToViewController:ctl animated:YES];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [_titleArr count]) {
        return 80;
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.userInfo.isFriend && indexPath.row == 0) {
        UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"修改备注"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                                otherButtonTitles:@"确定", nil];
        alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *userName = [alerView textFieldAtIndex:0];
        userName.placeholder = @"输入备注";
        alerView.tag = 101;
        [alerView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *noteName = [alertView textFieldAtIndex:0].text;
        if (!noteName || [noteName length] <= 0) {
            [MBProgressHUD showMessage:@"请输入备注" view:self.view];
            return ;
        }
        [self.userInfo updateNoteName:noteName completionHandler:^(id resultObject, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            if (!error) {
                _nameLabel.text = noteName;
                [_infoArr replaceObjectAtIndex:0 withObject:noteName];
                [_detailTableView reloadData];
                [MBProgressHUD showMessage:@"修改备注成功" view:self.view];
            }else{
                [MBProgressHUD showMessage:@"修改备注失败" view:self.view];
            }
        }];
    }
}

#pragma mark setter
- (UIImageView *)headView {
    if (!_headView) {
        _headView = [[UIImageView alloc] initWithFrame:kHeadViewFrame];
        _headView.layer.cornerRadius = _headView.frame.size.height/2;
        [_headView.layer setMasksToBounds:YES];
        [_headView setBackgroundColor:[UIColor clearColor]];
        [_headView setContentMode:UIViewContentModeScaleAspectFit];
        [_headView.layer setMasksToBounds:YES];
    }
    return _headView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]initWithFrame:kNameLabelFrame];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:18];
        _nameLabel.textAlignment =NSTextAlignmentCenter;
    }
    return _nameLabel;
}

@end
