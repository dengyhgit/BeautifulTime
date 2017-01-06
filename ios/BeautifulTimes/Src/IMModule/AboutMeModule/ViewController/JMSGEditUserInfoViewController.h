//
//  JMSGEditUserInfoViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSGEditUserInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIView *baseLine;
@property (weak, nonatomic) IBOutlet UILabel *suggestLabel;
@property (weak, nonatomic) IBOutlet UILabel *charNumber;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (assign, nonatomic) JMSGUserField updateType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *baselineTop;

@end
