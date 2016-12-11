//
//  AppDelegate.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "AppDelegate.h"
#import "BTGuideViewController.h"
#import "BTHomePageViewController.h"
#import "BTBaseNavigationController.h"
#import "BTHomePageViewController.h"
#import "Journal.h"
#import "BTIMTabBarController.h"
#import "BTUserLoginViewController.h"
#import "BTAddTimelineViewController.h"
#import "BTAddJournalViewController.h"

static AppDelegate *singleton = nil;

@interface AppDelegate () <JMessageDelegate>{
    UIAlertView *alertView;
}

@end

@implementation AppDelegate

+ (AppDelegate*)getInstance {
    return singleton;
}

- (BTCoreDataHelper*)cdh {
    if (!_coreDataHelper) {
        _coreDataHelper = [BTCoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [JMessage setLogOFF];
//    [JMessage setDebugMode];
    
    [JMessage addDelegate:self withConversation:nil];
    
    [JMessage setupJMessage:launchOptions
                     appKey:JMSSAGE_APPKEY
                    channel:CHANNEL
           apsForProduction:NO
                   category:nil];
    
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [self registerJPushStatusNotification];
    
    
    singleton = self;
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch]) {
//        [self enterGuidePage];
//    }
//    else {
//        [self enterHomePage];
//    }
    [self enterHomePage];
    return YES;
}

// 3d touch
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    [self initPages];
    
    UINavigationController *nav = (UINavigationController *)self.window.rootViewController;
    
    if([shortcutItem.type isEqualToString:@"journal"]){
        BTAddJournalViewController *vc = [[BTAddJournalViewController alloc] init];
        [nav pushViewController:vc animated:NO];
    }else if ([shortcutItem.type isEqualToString:@"timeline"]){
        BTAddTimelineViewController *vc = [[BTAddTimelineViewController alloc] init];
        [nav pushViewController:vc animated:NO];
    } else {
        BTIMTabBarController *tab = [[BTIMTabBarController alloc]init];
        [nav pushViewController:tab animated:YES];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required - 处理收到的通知
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self cdh];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[self cdh] saveContext];
}

#pragma mark 初始化页面栈
- (void)initPages
{
    BTHomePageViewController *homeViewController = [[BTHomePageViewController alloc] init];
    BTBaseNavigationController *homeNavigationController = [[BTBaseNavigationController alloc] initWithRootViewController:homeViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = homeNavigationController;
    [self.window makeKeyAndVisible];
}

//进入新手引导页
- (void)enterGuidePage {
    self.window.rootViewController = nil;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BTGuideViewController *guideVC = [[BTGuideViewController alloc] init];
    guideVC.hidesBottomBarWhenPushed = YES;
    self.window.rootViewController = guideVC;
    [self.window makeKeyAndVisible];
}

//进入首页
- (void)enterHomePage {
    NSNumber *themeType = [[NSUserDefaults standardUserDefaults] objectForKey:@"BTThemeType"];
    if (themeType == nil) {
        themeType = [NSNumber numberWithInt:BTThemeType_BT_BLUE];
        [[BTThemeManager getInstance] setThemeStyle:(BTThemeType)themeType.longValue];
    }
    else {
        [[BTThemeManager getInstance] setThemeStyle:(BTThemeType)themeType.longValue];
    }
    [self initPages];
}

-(UIViewController*)currentTopVc
{
    UINavigationController* VC = self.window.rootViewController.navigationController;
    UIViewController* topVC = VC.topViewController;
    return topVC;
}

- (void)registerJPushStatusNotification {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(receivePushMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
}

#pragma mark notification from JPush
- (void)receivePushMessage:(NSNotification *)notification {

}

- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event{
    SInt32 eventType = (JMSGEventNotificationType)event.eventType;
    switch (eventType) {
        case kJMSGEventNotificationReceiveFriendInvitation:
        case kJMSGEventNotificationAcceptedFriendInvitation:
        case kJMSGEventNotificationDeclinedFriendInvitation:
        case kJMSGEventNotificationDeletedFriend:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kFriendInvitationNotification object:event];
        }
            break;
        case kJMSGEventNotificationLoginKicked:
        case kJMSGEventNotificationServerAlterPassword:{
        case kJMSGEventNotificationUserLoginStatusUnexpected:
            if (!alertView) {
                alertView =[[UIAlertView alloc] initWithTitle:@"登录状态出错"
                                                      message:event.eventDescription
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
            break;
        default:
            break;
    }
    
}


#pragma mark alertview delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:userID];
    [[NSUserDefaults standardUserDefaults] synchronize];
    BTHomePageViewController *vc = [[BTHomePageViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    BTBaseNavigationController *navLogin = [[BTBaseNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navLogin;
    self.window.rootViewController = navLogin;
    return;
}

@end
