//
//  BTNetManager+BTAddJournal.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/10.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTNetManager+BTAddJournal.h"

#define WEATHERINFO_HOST @"https://api.heweather.com"
#define API_PATH_WEATHER @"/x3/weather"
#define API_AK @"2ceb7210fc614a1a8211b304dbd86ab0"

//http://www.heweather.com/my/service
//cbyniypeu    :  832b67b1d8d44bbfab99c55b7a76e26b
//1179132021   :  2ceb7210fc614a1a8211b304dbd86ab0
//1084854344   :  ddc5ef38379f4d89840cb0eb12800bde

@implementation BTNetManager (BTAddJournal)

+ (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                          successCallback:(DictionaryResponseBlock)successCallback
                                             failCallback:(errorBlock)failCallback
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    [infoDic setObject:API_AK forKey:@"key"];
    [infoDic setObject:cityName forKey:@"city"];
    
    AFHTTPRequestOperationManager *manager= [self configureAFHTTPRequestManagerWithURL:WEATHERINFO_HOST];
    AFHTTPRequestOperation *operation = [manager GET:API_PATH_WEATHER parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result =  (NSDictionary*)responseObject;
        successCallback(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallback(error);
    }];
    return operation;
}

+ (AFHTTPRequestOperationManager *)configureAFHTTPRequestManagerWithURL:(NSString *)url
{
    AFHTTPRequestOperationManager* manager = nil;
    
    if ([url isKindOfClass:[NSURL class]]) {
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:(NSURL *)url];
    }
    else {
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
    }
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    return manager;
}

@end
