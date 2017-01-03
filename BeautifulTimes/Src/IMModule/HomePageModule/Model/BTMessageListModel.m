//
//  BTMessageListModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTMessageListModel.h"
#import "NSDate+BTAddition.h"

@implementation BTMessageListModel

//设置时间
-(NSString *)time
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//#warning 真机调试 必须加上这句
    fmt.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    NSDate *creatDate = [fmt dateFromString:_time];
    
    //判断是否为今年
    if (creatDate.isThisYear) {//今年
        if (creatDate.isToday) {
            NSDateComponents *cmps = [creatDate deltaWithNow];
            if (cmps.hour >= 1) {//至少是一个小时之前发布的
                return [NSString stringWithFormat:@"%ld小时前",(long)cmps.hour];
            }else if(cmps.minute >= 1){//1~59分钟之前发布的
                return [NSString stringWithFormat:@"%ld分钟前",(long)cmps.minute];
            }else{//1分钟内发布的
                return @"刚刚";
            }
        }else if(creatDate.isYesterday){//昨天发的
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:creatDate];
        }else{//至少是前天发布的
            fmt.dateFormat = @"yyyy-MM-dd HH:mm";
            return [fmt stringFromDate:creatDate];
        }
    }else           //  往年
    {
        fmt.dateFormat = @"yyyy-MM-dd";
        return [fmt stringFromDate:creatDate];
    }
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    int count = [badgeValue intValue];
    if(count > 99){
        _badgeValue = [NSString stringWithFormat:@"99+"];
    }else{
        _badgeValue = badgeValue;
    }
}

@end
