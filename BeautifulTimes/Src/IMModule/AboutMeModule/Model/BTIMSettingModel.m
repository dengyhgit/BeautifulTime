//
//  BTSettingModel.m
//  BeautifulTimes
//
//  Created by deng on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMSettingModel.h"

@implementation BTIMSettingModel

+ (instancetype)settingWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle
{
    BTIMSettingModel *setting = [[BTIMSettingModel alloc] init];
    setting.title = title;
    setting.detailTitle = detailTitle;
    return setting;
}

@end
