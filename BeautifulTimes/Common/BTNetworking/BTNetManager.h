//
//  BTNetManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "BTBlockType.h"

@interface BTNetManager : NSObject

/**
 *  下载文件
 *
 *  @param paramDic   参数
 *  @param requestURL 接口路径
 *  @param savedPath  文件保存路径
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   下载进度
 */
+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;


/**
 *  上传文件
 *
 *  @param paramDic   参数
 *  @param requestURL 接口URL
 *  @param filePath   文件路径
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progress   下载进度
 */
+ (void)uploadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     filePath:(NSString*)filePath
                     fileName:(NSString*)fileName
               uploadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               uploadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;

+ (void)uploadFileWithOption:(NSDictionary *)paramDic
               withInferface:(NSString*)requestURL
                    fileData:(NSData*)fileData
                    fileName:(NSString*)fileName
               uploadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               uploadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    progress:(void (^)(float progress))progress;

@end
