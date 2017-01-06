//
//  NSDate+BTAddition.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BTAddition)

//判断是否为今天
-(BOOL)isToday;
//判断是否为昨天
-(BOOL)isYesterday;
//判断是否为今年
-(BOOL)isThisYear;
//获得与当前时间的差距
-(NSDateComponents *)deltaWithNow;

- (NSDate *)dateWithYMD;

@end
