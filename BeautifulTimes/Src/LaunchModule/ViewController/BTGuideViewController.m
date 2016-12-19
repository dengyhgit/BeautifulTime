//
//  BTGuideViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/10/15.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTGuideViewController.h"
#import "AppDelegate.h"
#import "BTThemeManager.h"

@interface BTGuideViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *guideScrollView;
@property (nonatomic, strong) UIButton *enterHomeButton;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation BTGuideViewController
{
    UIButton *backButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[BTThemeManager getInstance] addThemeListener:self];
}

- (void)enterHome
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch]) {
        // 第一次启动完成
        [[AppDelegate getInstance] enterHomePage];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:firstLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self CLThemeDidNeedUpdateStyle];
}

- (void)dealloc
{
    [[BTThemeManager getInstance] removeThemeListener:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (IOS8_OR_HIGHER)
    {
        [AppDelegate getInstance].window.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT);
        self.view.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT);
    }
    
    // 引导视图
    self.guideScrollView.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT);
    self.guideScrollView.delegate = self;
    self.guideScrollView.backgroundColor = BT_CLEARCOLOR;
    self.guideScrollView.showsHorizontalScrollIndicator = NO;
    self.guideScrollView.showsVerticalScrollIndicator = NO;
    self.guideScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH * 3, BT_SCREEN_HEIGHT - 100);
    self.guideScrollView.pagingEnabled = YES;
    for (int i = 0; i < 3; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * BT_SCREEN_WIDTH, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        switch (i) {
            case 0:
            {
                imageView.image = BT_UIIMAGE(@"guide_1");
            }
                break;
            case 1:
            {
                imageView.image = BT_UIIMAGE(@"guide_2");
            }
                break;
            case 2:
            {
                imageView.image = BT_UIIMAGE(@"guide_3");
                imageView.userInteractionEnabled = YES;
                self.enterHomeButton.frame = CGRectMake(0, self.view.height * 0.83, self.view.width / 3, self.view.height * 0.075);
                self.enterHomeButton.centerX = self.view.centerX;
                [self.enterHomeButton addTarget:self action:@selector(enterHome) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:self.enterHomeButton];
            }
                break;
                
            default:
                break;
        }
        
        [self.guideScrollView addSubview:imageView];
    }
    
    [self.view addSubview:self.guideScrollView];
}

#pragma mark - getter
- (UIButton *)enterHomeButton
{
    if (!_enterHomeButton) {
        _enterHomeButton = [[UIButton alloc] init];
    }
    
    return _enterHomeButton;
}

- (UIScrollView *)guideScrollView
{
    if (!_guideScrollView) {
        _guideScrollView = [[UIScrollView alloc] init];
    }
    
    return _guideScrollView;
}

- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)CLThemeDidNeedUpdateStyle {
    
    self.view.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"com_ic_back"];
    
    [[BTThemeManager getInstance] BTThemeImage:@"com_ic_back" completionHandler:^(UIImage *image) {
        [backButton setImage:image forState:UIControlStateNormal];
    }];
    
    [[BTThemeManager getInstance] BTThemeImage:@"com_ic_back_press" completionHandler:^(UIImage *image) {
        [backButton setImage:image forState:UIControlStateHighlighted];
    }];
}

@end
