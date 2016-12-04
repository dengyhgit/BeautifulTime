//
//  BTWeatherModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTWeatherModel.h"

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

@end
