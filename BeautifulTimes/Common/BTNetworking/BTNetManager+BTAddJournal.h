//
//  BTNetManager+BTAddJournal.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/10.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTNetManager.h"

@interface BTNetManager (BTAddJournal)

+ (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                          successCallback:(DictionaryResponseBlock)successCallback
                                             failCallback:(errorBlock)failCallback;

@end
