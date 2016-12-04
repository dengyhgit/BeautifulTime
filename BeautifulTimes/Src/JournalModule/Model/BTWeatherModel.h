//
//  BTWeatherModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTWeatherModel : NSObject

@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *updateTime;
@property (nonatomic, strong) NSString *pm25;
@property (nonatomic, strong) NSString *maxTemperature;
@property (nonatomic, strong) NSString *minTemperature;
@property (nonatomic, strong) NSString *wind;
@property (nonatomic, strong) NSString *dayWeatherIcon;
@property (nonatomic, strong) NSString *nightWeatherIcon;


@end
