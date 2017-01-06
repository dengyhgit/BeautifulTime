//
//  BTAddAlbumViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/1.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddAlbumViewController.h"
#import <Photos/Photos.h>
#import "BTMyAlbumViewController.h"

@interface BTAddAlbumViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *albumTitle;
@property (nonatomic, strong) UITextView *briefIntroduction;
@property (nonatomic, strong) UIImageView *albumCover;

@end

@implementation BTAddAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加相册";
    [self.finishButton setHidden:NO];
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.albumTitle];
    [self.bodyView addSubview:self.briefIntroduction];
    [self.bodyView addSubview:self.albumCover];
    [self addGesture];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.albumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(10);
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@(44));
    }];
    
    [self.albumCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.albumTitle).offset(10 + 44);
        make.left.equalTo(weakSelf.albumTitle).offset(10);
        make.width.equalTo(@(96));
        make.height.equalTo(@(96));
    }];
    
    [self.briefIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.albumCover);
        make.left.equalTo(weakSelf.albumCover).offset(96 + 10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@(96));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    [self addAlbum];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTMyAlbumViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

#pragma mark 添加手势识别器
- (void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
}
#pragma mark 点击的方法
- (void)tapClick:(id)sender {
    [self.bodyView endEditing:YES];
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
    return NO;
}

- (void) keyboardWasHidden:(NSNotification *) notif {
    
    if (![self.albumTitle isFirstResponder]) {
        [self.albumTitle becomeFirstResponder];
    }
}


#pragma mark textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}


#pragma mark - 添加相册
- (void)addAlbum {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumTitle.text];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            
        } else {
        
        }
    }];
}

- (UITextField *)albumTitle {
    if (!_albumTitle) {
        _albumTitle = [[UITextField alloc] init];
        _albumTitle.placeholder = @"相册名称";
        CALayer *layer = [_albumTitle layer];
        layer.borderColor = [UIColor grayColor].CGColor;
        layer.borderWidth = 0.5;
        _albumTitle.delegate = self;
    }
    return _albumTitle;
}

- (UITextView *)briefIntroduction {
    if (!_briefIntroduction) {
        _briefIntroduction = [[UITextView alloc] init];
        _briefIntroduction.delegate = self;
    }
    return _briefIntroduction;
}

- (UIImageView *)albumCover {
    if (!_albumCover) {
        _albumCover = [[UIImageView alloc] init];
    }
    return _albumCover;
}


@end
