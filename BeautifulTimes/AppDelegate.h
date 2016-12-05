//
//  AppDelegate.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCoreDataHelper.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong, readonly) BTCoreDataHelper *coreDataHelper;

+ (AppDelegate*)getInstance;

//进入新手引导页
- (void)enterGuidePage;

//进入首页
- (void)enterHomePage;

-(UIViewController*)currentTopVc;

@end

