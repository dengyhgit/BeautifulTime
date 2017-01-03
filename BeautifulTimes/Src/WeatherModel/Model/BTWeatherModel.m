//
//  BTWeatherModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTWeatherModel.h"

#define WeatherRootKey @"HeWeather data service 3.0"

@implementation BTWeatherModel

- (id)initWithCoder:(NSCoder *)decoder{
    if (self = [super init]){
        self.city  = [decoder decodeObjectForKey:@"city"];
        self.updateTime  = [decoder decodeObjectForKey:@"updateTime"];
        self.pm25 = [decoder decodeObjectForKey:@"pm25"];
        self.maxTemperature = [decoder decodeObjectForKey:@"maxTemperature"];
        self.minTemperature = [decoder decodeObjectForKey:@"minTemperature"];
        self.wind = [decoder decodeObjectForKey:@"wind"];
        self.dayWeatherIcon = [decoder decodeObjectForKey:@"dayWeatherIcon"];
        self.nightWeatherIcon = [decoder decodeObjectForKey:@"nightWeatherIcon"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.updateTime forKey:@"updateTime"];
    [encoder encodeObject:self.pm25 forKey:@"pm25"];
    [encoder encodeObject:self.maxTemperature forKey:@"maxTemperature"];
    [encoder encodeObject:self.minTemperature forKey:@"minTemperature"];
    [encoder encodeObject:self.wind forKey:@"wind"];
    [encoder encodeObject:self.dayWeatherIcon forKey:@"dayWeatherIcon"];
    [encoder encodeObject:self.nightWeatherIcon forKey:@"nightWeatherIcon"];
}

- (void)bindDat:(id)data {
    NSDictionary *retDict = (NSDictionary *)data;
    self.city = retDict[WeatherRootKey][0][@"basic"][@"city"];
    self.pm25 = retDict[WeatherRootKey][0][@"aqi"][@"city"][@"pm25"];
    self.updateTime = retDict[WeatherRootKey][0][@"basic"][@"update"][@"loc"];
    self.maxTemperature = retDict[WeatherRootKey][0][@"daily_forecast"][0][@"tmp"][@"max"];
    self.minTemperature = retDict[WeatherRootKey][0][@"daily_forecast"][0][@"tmp"][@"min"];
    self.dayWeatherIcon = retDict[WeatherRootKey][0][@"daily_forecast"][0][@"cond"][@"txt_d"];
    self.nightWeatherIcon = retDict[WeatherRootKey][0][@"daily_forecast"][0][@"cond"][@"txt_n"];
}

@end
