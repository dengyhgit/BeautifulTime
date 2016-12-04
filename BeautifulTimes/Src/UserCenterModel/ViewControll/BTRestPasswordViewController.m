//
//  BTRestPasswordViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTRestPasswordViewController.h"
#import "BTTextField.h"
#import "UIImage+Addition.h"

#define margin 20
#define textFieldHeight 30

@interface BTRestPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) BTTextField *oldPassword;
@property (nonatomic, strong) BTTextField *password;
@property (nonatomic, strong) BTTextField *confirmPassword;
@property (nonatomic, strong) UIButton *confirmBnt;

@end

@implementation BTRestPasswordViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"修改密码";
    [self.bodyView addSubview:self.oldPassword];
    [self addbottomLineWith:CGRectMake(margin, 50 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.password];
    [self addbottomLineWith:CGRectMake(margin, 100 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.confirmPassword];
    [self addbottomLineWith:CGRectMake(margin, 150 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.confirmBnt];
    [self addGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(margin);
        make.left.equalTo(weakSelf.bodyView).offset(margin);
        make.right.equalTo(weakSelf.bodyView).offset(-margin);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oldPassword).offset(margin + textFieldHeight);
        make.left.equalTo(weakSelf.oldPassword);
        make.right.equalTo(weakSelf.oldPassword);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password).offset(margin + textFieldHeight);
        make.left.equalTo(weakSelf.password);
        make.right.equalTo(weakSelf.password);
        make.height.equalTo(@(textFieldHeight));
    }];

    [self.confirmBnt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.confirmPassword).offset(30 + textFieldHeight);
        make.left.equalTo(weakSelf.confirmPassword);
        make.right.equalTo(weakSelf.confirmPassword);
        make.height.equalTo(@(40));
    }];
}

#pragma mark 添加手势识别器
-(void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
}
#pragma mark 点击的方法
-(void)tapClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark 添加下划线的方法
-(void)addbottomLineWith:(CGRect)bounds {
    UIImageView *line=[[UIImageView alloc]initWithFrame:bounds];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.oldPassword.text.length != 0 && self.password.text.length != 0){
        self.confirmBnt.enabled=YES;
    }
    if(textField.text.length <= 1) {
        self.confirmBnt.enabled = NO;
    }
    
    return YES;
}
#pragma mark 点击登陆的方法
-(void)confirmClick
{
//    BTXMPPTool *xmppTool=[BTXMPPTool sharedInstance];
//    xmppTool.registerOperation=NO;  //注册的方法
//    
//    WS(weakSelf);
//    
//    //显示旋转矿
//    [self.view endEditing:YES];
//    
//    [xmppTool login:^(XMPPResultType xmppType) {
//        [weakSelf handle:xmppType];
//    }];
}

#pragma mark 登录成功后进入主界面
-(void)enterHome
{
    self.oldPassword.text=nil;
    self.password.text=nil;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
}

#pragma mark 截取字符串空格的方法
-(NSString*)trim:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [str lowercaseString]; //转成小写
}

- (UIButton *)confirmBnt {
    if (!_confirmBnt) {
        _confirmBnt = [[UIButton alloc] init];
        _confirmBnt.enabled=NO;
        [_confirmBnt setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateNormal];
        [_confirmBnt setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateHighlighted];
        [_confirmBnt setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateDisabled];
        [_confirmBnt setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_content"] forState:UIControlStateNormal];
        [_confirmBnt setTitle:@"修改" forState:UIControlStateNormal];
        [_confirmBnt.layer setMasksToBounds:YES];
        [_confirmBnt.layer setCornerRadius:5.0];
        [_confirmBnt addTarget:self action:@selector(confirmClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmBnt;
}

- (BTTextField *)oldPassword {
    if (!_oldPassword) {
        _oldPassword = [[BTTextField alloc] init];
        _oldPassword.delegate=self;
        _oldPassword.image=@"bt_login_pw_icon";
        _oldPassword.contentPlaceholder=@"请输入旧密码";
    }
    return _oldPassword;
}

- (BTTextField *)password {
    if (!_password) {
        _password = [[BTTextField alloc] init];
        _password.secureTextEntry=YES;
        _password.delegate=self;
        _password.image=@"bt_login_pw_icon";
        _password.contentPlaceholder=@"请输入密码";
    }
    return _password;
}

- (BTTextField *)confirmPassword {
    if (!_confirmPassword) {
        _confirmPassword = [[BTTextField alloc] init];
        _confirmPassword.secureTextEntry=YES;
        _confirmPassword.delegate=self;
        _confirmPassword.image=@"bt_login_pw_icon";
        _confirmPassword.contentPlaceholder=@"请确认密码";
    }
    return _confirmPassword;
}


@end
