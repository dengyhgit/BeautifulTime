//
//  JMSGCreateGroupViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGCreateGroupViewController.h"

@interface JMSGCreateGroupViewController ()

@property (nonatomic, strong) UITextField *groupTextField;

@end

@implementation JMSGCreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupSubview];
    [self setupNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)setupSubview {
    UIView *searchView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kApplicationWidth, 60)];
    [searchView setBackgroundColor:[UIColor whiteColor]];
    self.title = @"创建群聊";
    UILabel *groupNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 60, 50)];
    groupNameLabel.text = @"群名称:";
    groupNameLabel.textAlignment = NSTextAlignmentCenter;
    [searchView addSubview:groupNameLabel];
    [searchView addSubview:self.groupTextField];
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59, kApplicationWidth, 1)];
    [line setBackgroundColor:[UIColor grayColor]];
    [searchView addSubview:line];
    [self.view addSubview:searchView];
}

- (void)setupNavigationBar {
    UIButton *leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:kNavigationLeftButtonRect];
    [leftBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setImage:[UIImage imageNamed:@"goBack"] forState:UIControlStateNormal];
    [leftBtn setImageEdgeInsets:kGoBackBtnImageOffset];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightbtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setFrame:CGRectMake(0, 0, 50, 50)];
    [rightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [rightbtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbtn];
}

- (void)backClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightBtnClick {
    if ([_groupTextField.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入群名称！" view:self.view];
        return;
    }
    [_groupTextField resignFirstResponder];
    [MBProgressHUD showMessage:@"正在创建群组！" toView:self.view];
    //SDK：创建群
    [JMSGGroup createGroupWithName:_groupTextField.text desc:@"" memberArray:@[[JMSGUser myInfo].username] completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if (!error) {
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:kCreatGroupState object:resultObject];
        } else if (error.code == 808003) {
            [MBProgressHUD showMessage:@"创建群组数量达到上限！" view:self.view];
        } else {
            [MBProgressHUD showMessage:@"创建群组失败！" view:self.view];
        }
    }];
}

#pragma mark setter&getter
- (UITextField *)groupTextField {
    if (!_groupTextField) {
        _groupTextField =[[UITextField alloc] initWithFrame:CGRectMake(60, 5, 150, 50)];
        _groupTextField.placeholder = @"请输入群名称";
    }
    return _groupTextField;
}

@end
