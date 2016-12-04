//
//  BTIMEditUserInfoViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMEditUserInfoViewController.h"
#import "BTTextField.h"
#import "BTEditUserInfoCell.h"

@interface BTIMEditUserInfoViewController ()

@property (nonatomic,weak) BTTextField *input;

@end

@implementation BTIMEditUserInfoViewController

-(instancetype)init
{
    self=[super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
    [self setupNavButton];
}


-(void)setupNavButton
{
    //1.添加左边的按钮
    UIButton *leftBtn=[[UIButton alloc]init];
    leftBtn.frame=CGRectMake(0, 0, 40, 30);
    leftBtn.titleEdgeInsets=UIEdgeInsetsMake(0, -10, 0, 10);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    leftBtn.titleLabel.font=BT_FONTSIZE(14);
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    //2.添加右边的按钮
    UIButton *rightBtn=[[UIButton alloc]init];
    rightBtn.frame=CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    rightBtn.titleLabel.font=BT_FONTSIZE(14);
    [rightBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 关闭控制器
-(void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 保存的方法
-(void)save
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if([self.delegate respondsToSelector:@selector(EditingFinshed:indexPath:newInfo:)]){
        [self.delegate EditingFinshed:self indexPath:self.indexPath newInfo:self.input.text];
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTEditUserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kSettingCell"];
    if (!cell) {
        cell = [[BTEditUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kEditUserInfoCell"];
    }
    cell.str=self.str;
    self.input=cell.input;
    [self.input becomeFirstResponder];
    return cell;
}

#pragma mark 当时图开始滚动的时候  隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

@end
