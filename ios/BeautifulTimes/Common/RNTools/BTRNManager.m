//
//  BTRNManager.m
//  BeautifulTimes
//
//  Created by deng on 17/1/13.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "BTRNManager.h"
#import "RCTBridge.h"
#import "AppDelegate.h"

@implementation BTRNManager

RCT_EXPORT_MODULE(BTRNManager)

RCT_EXPORT_METHOD(DismissViewController:(BOOL)animated){
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[AppDelegate getInstance] currentTopVc] dismissViewControllerAnimated:animated completion:nil];
    });
}

@end
