//
//  BTHttpManager.h
//  BeautifulTimes
//
//  Created by deng on 16/12/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTHttpManager : NSObject

+ (void)POST:(NSString * _Nonnull)URLString
  parameters:(id _Nullable)parameters
     success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
     failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

+ (void)GET:(NSString * _Nonnull)URLString
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

+ (void)PUT:(NSString * _Nonnull)URLString
 parameters:(id _Nullable)parameters
    success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failure;

@end
