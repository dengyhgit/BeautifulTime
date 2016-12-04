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
    UIPageControl *pageControl;
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
    // Dispose of any resources that can be recreated.
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
    self.guideScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH * 4, BT_SCREEN_HEIGHT - 100);
    self.guideScrollView.pagingEnabled = YES;
    for (int i = 0; i<4; i++) {
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
                imageView.image = BT_UIIMAGE(@"guide_3.jpg");
            }
                break;
            case 3:
            {
                imageView.image = BT_UIIMAGE(@"guide_4");
                // UIImageView上添加按钮点击事件无效，需要设置imageView的userInteractionEnabled属性
                imageView.userInteractionEnabled = YES;
                UIImage *enterHomeImage = BT_UIIMAGE(@"enterHome");
                self.enterHomeButton.frame = CGRectMake(0, 0, enterHomeImage.size.width, enterHomeImage.size.height);
                
                if (BT_SCREEN_HEIGHT == 375) {
                    self.enterHomeButton.center = CGPointMake(BT_SCREEN_WIDTH/2, BT_SCREEN_HEIGHT - (114+50)/2);
                }
                else if (BT_SCREEN_HEIGHT == 414) {
                    self.enterHomeButton.center = CGPointMake(BT_SCREEN_WIDTH/2, BT_SCREEN_HEIGHT - (192+76)/2);
                }
                else {
                    self.enterHomeButton.center = CGPointMake(BT_SCREEN_WIDTH/2, BT_SCREEN_HEIGHT - (98+48)/2);
                }
                [self.enterHomeButton setImage:enterHomeImage forState:UIControlStateNormal];
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
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, BT_SCREEN_HEIGHT - 80, BT_SCREEN_WIDTH, 30)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 20, 32, 32)];
    backButton.exclusiveTouch = YES;
    [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    backButton.hidden = ![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch];
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


#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    
    [pageControl setCurrentPage:offset.x / bounds.size.width];
}

- (void)pageTurn:(UIPageControl *)sender
{
    CGSize viewSize = self.guideScrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [self.guideScrollView scrollRectToVisible:rect animated:YES];
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