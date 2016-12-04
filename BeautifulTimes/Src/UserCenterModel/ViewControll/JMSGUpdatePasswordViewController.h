//
//  JMSGUpdatePasswordViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/5.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSGUpdatePasswordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *pressBtn;
@property (weak, nonatomic) IBOutlet UITextField *oldpassword;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordFieldAgain;
@property (weak, nonatomic) IBOutlet UILabel *separateLine1;

@property (weak, nonatomic) IBOutlet UILabel *separateLine2;
@property (weak, nonatomic) IBOutlet UILabel *separateLine3;

@end
