//
//  BTIMTabBarController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/21.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTIMTabBarController.h"
#import "BTIMNavViewController.h"
#import "BTIMAboutMeViewController.h"
#import "BTTabBarView.h"
#import "JMSGContactsViewController.h"
#import "JMSGConversationListViewController.h"

@interface BTIMTabBarController ()<BTTabBarViewDelegate>

@property (nonatomic,strong) BTTabBarView *tabBarView;
@property (nonatomic,strong) JMSGConversationListViewController  *homeVC;
@property (nonatomic,strong) JMSGContactsViewController *contacter;
@property (nonatomic,strong) BTIMAboutMeViewController *aboutMe;

@end

@implementation BTIMTabBarController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //这样才会显示tabBar上面的按钮
    for(UIView *child in self.tabBar.subviews){
        if([child isKindOfClass:[UIControl class]]){
            [child removeFromSuperview];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBar addSubview:self.tabBarView];
    [self setupChilControllers];
}

#pragma mark 实现自定义标签试图的代理方法
-(void)tabBar:(BTTabBarView *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex=to;
}
#pragma mark 添加自控制器
-(void)setupChilControllers
{
    JMSGConversationListViewController *homeVC = [[JMSGConversationListViewController alloc]init];
    self.homeVC = homeVC;
    [self setupChildViewController:homeVC title:@"私语" imageName:@"tab_recent_nor" selectedImageName:@"tab_recent_press"];

    JMSGContactsViewController *contacter=[[JMSGContactsViewController alloc]init];
    self.contacter=contacter;
    [self setupChildViewController:contacter title:@"通讯录" imageName:@"com_ic_contacter" selectedImageName:@"com_ic_contacter_h"];

    BTIMAboutMeViewController *aboutMe = [[BTIMAboutMeViewController alloc]init];
    self.aboutMe = aboutMe;
    [self setupChildViewController:aboutMe title:@"我" imageName:@"tab_buddy_nor" selectedImageName:@"tab_buddy_press"];
}

#pragma mark 初始化视图控制器的方法
-(void)setupChildViewController:(UIViewController*)childVc title:(NSString *)title imageName:(NSString*)imageName selectedImageName:(NSString*)selectedImageName
{
    childVc.title = title;
    childVc.tabBarItem.image = BT_LOADIMAGE(imageName);  //正常图片
    childVc.tabBarItem.selectedImage = BT_LOADIMAGE(selectedImageName); //选中的图片
    BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:childVc];
    //添加到标签栏控制器里面
    [self addChildViewController:nav];
    //把UIBarItem属性传递给自定义的view
    [self.tabBarView addTabBarButtonItem:childVc.tabBarItem];
}

//返回白色的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BTTabBarView *)tabBarView {
    if (!_tabBarView) {
        _tabBarView = [[BTTabBarView alloc] initWithFrame:self.tabBar.bounds];
        _tabBarView.delegate = self;
    }
    return _tabBarView;
}

@end
