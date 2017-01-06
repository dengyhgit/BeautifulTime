//
//  BTSettingModel.h
//  BeautifulTimes
//
//  Created by deng on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTIMSettingModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *detailTitle;
@property (nonatomic,assign) BOOL isLoginOut;  //默认是no

+ (instancetype)settingWithTitle:(NSString*)title detailTitle:(NSString*)detailTitle;

@end
