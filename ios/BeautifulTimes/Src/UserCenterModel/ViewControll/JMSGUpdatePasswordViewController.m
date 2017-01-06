//
//  JMSGUpdatePasswordViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGUpdatePasswordViewController.h"

@interface JMSGUpdatePasswordViewController ()

@end

@implementation JMSGUpdatePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改密码";
    [self layoutAllView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)layoutAllView {
    [self.pressBtn setBackgroundColor:RGBColor(96, 209, 88)];
    self.pressBtn.layer.cornerRadius = 4;
    self.pressBtn.layer.masksToBounds = YES;
    [self.oldpassword becomeFirstResponder];
    
    _separateLine1.backgroundColor = kSeparationLineColor;
    _separateLine2.backgroundColor = kSeparationLineColor;
    _separateLine3.backgroundColor = kSeparationLineColor;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)updatePasswordClick:(id)sender {
    if ([self.oldpassword.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入原密码" view:self.view];
        return;
    }
    
    if ([self.passwordField.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"请输入密码" view:self.view];
        return;
    } else if ([self.passwordFieldAgain.text isEqualToString:@""]){
        [MBProgressHUD showMessage:@"请确认密码" view:self.view];
    } else if ([self.passwordField.text isEqualToString:@""] && [self.passwordFieldAgain.text isEqualToString:@""]) {
        [MBProgressHUD showMessage:@"新密码与确认密码不相同，请重新输入" view:self.view];
    } else if ([self.passwordField.text isEqualToString:self.passwordFieldAgain.text]){
        [MBProgressHUD showMessage:@"正在修改" toView:self.view];
        
        //SDK：更新密码
        [JMSGUser updateMyPasswordWithNewPassword:self.passwordField.text
                                      oldPassword:self.oldpassword.text
                                completionHandler:^(id resultObject, NSError *error) {
                                    
                                    BTMAINTHREAD(^{
                                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                        
                                    });
                                    if (error == nil) {
                                        [self.navigationController popViewControllerAnimated:YES];
                                        [MBProgressHUD showMessage:@"更新密码成功" view:self.view];
                                    } else {
                                        [MBProgressHUD showMessage:@"更新密码失败" view:self.view];
                                    }
                                }];
    } else {
        [MBProgressHUD showMessage:@"确认密码不一致!" view:self.view];
    }
}

@end
