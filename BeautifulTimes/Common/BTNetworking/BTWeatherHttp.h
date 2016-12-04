//
//  BTWeatherHttp.h
//  BeautifulTimes
//
//  Created by deng on 16/12/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTBlockType.h"

@interface BTWeatherHttp : NSObject

+ (void)reqeustWeatherInfo:(NSString *)cityName
                      successCallback:(DictionaryResponseBlock)successCallback
                         failCallback:(errorBlock)failCallback;

@end
