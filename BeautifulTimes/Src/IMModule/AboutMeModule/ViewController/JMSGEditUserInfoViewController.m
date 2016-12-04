//
//  JMSGEditUserInfoViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/6.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGEditUserInfoViewController.h"

#define kCharNumberColor UIColorFromRGB(0xbbbbbb)
#define kBaseLineColor UIColorFromRGB(0x3f80de)
#define kNameTextFieldColor UIColorFromRGB(0x2d2d2d)
#define kSuggestTextColor UIColorFromRGB(0xbbbbbb)
#define kNavigationTittleFrame CGRectMake(0, 0, 150, 44)

static int const nameLengthLime = 30;

@interface JMSGEditUserInfoViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JMSGEditUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.charNumber setTextColor:kCharNumberColor];
    self.baseLine.backgroundColor = kBaseLineColor;
    [self.nameTextField setTextColor:kNameTextFieldColor];
    [self.suggestLabel setTextColor:kSuggestTextColor];
    [self.nameTextField becomeFirstResponder];
    [self choseWillShowView];
    [self setupNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)choseWillShowView {
    JMSGUser *user = [JMSGUser myInfo];
    switch (_updateType) {
        case kJMSGUserFieldsNickname:
        {
            self.deleteButton.hidden = NO;
            self.charNumber.hidden = NO;
            self.suggestLabel.text = @"好名字可以让你的朋友更加容易记住你";
            self.nameTextField.placeholder = user.nickname?:@"请输入你的姓名";
            [self.nameTextField addTarget:self action:@selector(textFieldDidChangeName) forControlEvents:UIControlEventEditingChanged];
            self.titleLabel.text = @"修改昵称";
        }
            break;
        case kJMSGUserFieldsSignature:
        {
            self.suggestLabel.hidden = YES;
            [self.nameTextField addTarget:self action:@selector(textFieldDidChangeName) forControlEvents:UIControlEventEditingChanged];
            self.nameTextField.placeholder = user.signature?:@"请输入你的签名";
            self.titleLabel.text = @"修改签名";
        }
            break;
        case kJMSGUserFieldsRegion:
        {
            self.deleteButton.hidden = YES;
            self.charNumber.hidden = YES;
            self.suggestLabel.hidden = YES;
            self.titleLabel.text = @"修改地区";
            self.nameTextField.placeholder = user.region?:@"请输入你所在的地区";
        }
            break;
        default:
            break;
    }
    self.navigationItem.titleView = self.titleLabel;
}

- (void)setupNavigationBar {
    UIBarButtonItem *rightbutton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(clickToSave)];
    self.navigationItem.rightBarButtonItem = rightbutton;
}

- (void)clickToSave {
    WS(weakSelf);
    //SDK：修改用户信息
    [JMSGUser updateMyInfoWithParameter:self.nameTextField.text userFieldType:self.updateType completionHandler:^(id resultObject, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (error == nil) {
            [MBProgressHUD showMessage:@"修改成功" view:weakSelf.view];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showMessage:@"修改失败" view:weakSelf.view];
        }
    }];
}

- (void)textFieldChange {
    self.charNumber.text = [NSString stringWithFormat:@"%ld", (long)self.nameTextField.text.length];
}

- (void)textFieldDidChangeName {
    if (self.nameTextField.text.length > 30) {
        self.nameTextField.text = [self.nameTextField.text substringWithRange:NSMakeRange(0, nameLengthLime)];
        [MBProgressHUD showMessage:[NSString stringWithFormat:@"最多输入 %ld 个字符",(long)nameLengthLime] view:self.view];
        return;
    }
    self.charNumber.text = [NSString stringWithFormat:@"%d",nameLengthLime - (int)self.nameTextField.text.length];
}

- (IBAction)deleteText:(id)sender {
    if (_updateType == kJMSGUserFieldsSignature) {
        self.nameTextField.text = @"";
        self.charNumber.text = @"0";
    } else {
        self.nameTextField.text = @"";
        self.charNumber.text = [NSString stringWithFormat:@"%ld",(long)nameLengthLime];
    }
}

#pragma mark setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:kNavigationTittleFrame];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
