//
//  BTWeatherHttp.m
//  BeautifulTimes
//
//  Created by deng on 16/12/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTWeatherHttp.h"
#import "BTHttpManager.h"

#define WEATHERINFO_HOST @"https://api.heweather.com/x3/weather"
#define API_PATH_WEATHER @"/x3/weather"
#define API_AK @"2ceb7210fc614a1a8211b304dbd86ab0"

//http://www.heweather.com/my/service
//cbyniypeu    :  832b67b1d8d44bbfab99c55b7a76e26b
//1179132021   :  2ceb7210fc614a1a8211b304dbd86ab0
//1084854344   :  ddc5ef38379f4d89840cb0eb12800bde

@implementation BTWeatherHttp

+ (void)reqeustWeatherInfo:(NSString *)cityName successCallback:(DictionaryResponseBlock)successCallback failCallback:(errorBlock)failCallback {
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];

    [infoDic setObject:API_AK forKey:@"key"];
    [infoDic setObject:cityName forKey:@"city"];
    [BTHttpManager GET:WEATHERINFO_HOST parameters:infoDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successCallback(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failCallback(error);
    }];
}

@end
