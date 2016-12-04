//
//  BTIMNavViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMNavViewController.h"
#import "UIImage+Addition.h"
#import "BTHomePageViewController.h"
#import "BTBaseNavigationController.h"
#import "AppDelegate.h"

@interface BTIMNavViewController ()

@end

@implementation BTIMNavViewController

+ (void)initialize
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"com_bg_nav")] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navBar.shadowImage = [[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark 当push的时候调用这个方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{

    if(self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES; //当push 的时候隐藏底部兰
    }
    else {
        viewController.navigationItem.leftBarButtonItem = [self creatBackButton];
    }
    [super pushViewController:viewController animated:animated];
}


-(UIBarButtonItem *)creatBackButton
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:BT_LOADIMAGE(@"com_ic_nav_backhome") style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClick)];
    return backButton;
}

- (void)backButtonClick
{
    BTHomePageViewController *homeViewController = [[BTHomePageViewController alloc] init];
    BTBaseNavigationController *homeNavigationController = [[BTBaseNavigationController alloc] initWithRootViewController:homeViewController];
//    [AppDelegate getInstance].window.rootViewController = nil;
    [AppDelegate getInstance].window.rootViewController = homeNavigationController;
    [self removeFromParentViewController];
}

//返回白色的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
