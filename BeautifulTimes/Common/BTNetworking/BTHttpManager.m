//
//  BTHttpManager.m
//  BeautifulTimes
//
//  Created by deng on 16/12/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTHttpManager.h"

typedef NS_ENUM(NSUInteger, BTHttpMethod) {
    kBTHttpMethodPost,
    kBTHttpMethodPut,
    kBTHttpMethodGet,
};

@interface BTHttpManager()

@end

@implementation BTHttpManager

#pragma mark - http request

+ (void)POST:(NSString *)urlString
  parameters:(id)parameters
     success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
     failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {

    [BTHttpManager p_HttpRequest:kBTHttpMethodPost urlString:urlString parameters:parameters success:success failure:failure];
}

+ (void)GET:(NSString *)urlString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
    failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    [BTHttpManager p_HttpRequest:kBTHttpMethodGet urlString:urlString parameters:parameters success:success failure:failure];
}

+ (void)PUT:(NSString *)urlString
 parameters:(id)parameters
    success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
    failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    [BTHttpManager p_HttpRequest:kBTHttpMethodPut urlString:urlString parameters:parameters success:success failure:failure];
}

#pragma mark - private method
+ (void)p_HttpRequest:(BTHttpMethod)httpMethod
                            urlString:(NSString *)urlString
                           parameters:(id)parameters
                              success:(void (^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
                              failure:(void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure {
    
    void (^ successResponseBlock)(NSURLSessionDataTask *task, id responseObject) = ^(NSURLSessionDataTask *task, id responseObject){
        
        success(task, responseObject);
    };
    
    void (^ failureResponseBlock)(NSURLSessionDataTask *task, NSError *error) = ^(NSURLSessionDataTask *task, NSError *error) {
       
        failure(nil, error);
    };
    
    AFHTTPSessionManager *manager = [BTHttpManager createHeader];
    switch (httpMethod) {
        case kBTHttpMethodGet:
            [manager GET:urlString parameters:parameters progress:nil success:successResponseBlock failure:failureResponseBlock];
            break;
        case kBTHttpMethodPost:
            [manager POST:urlString parameters:parameters progress:nil success:successResponseBlock failure:failureResponseBlock];
            break;
        case kBTHttpMethodPut:
            [manager PUT:urlString parameters:parameters success:successResponseBlock failure:failureResponseBlock];
            break;
    }
    
}

+ (AFHTTPSessionManager *)createHeader {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
    [manager.securityPolicy setValidatesDomainName:NO];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
    return manager;
}

@end
