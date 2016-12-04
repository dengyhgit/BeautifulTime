//
//  BTNetManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/8.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTNetManager.h"

@implementation BTNetManager

+ (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress
{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
       // NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
       // NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
       // NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}

+ (void)uploadFileWithOption:(NSDictionary *)paramDic
               withInferface:(NSString*)requestURL
                    filePath:(NSString*)filePath
                    fileName:(NSString*)fileName
               uploadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               uploadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    progress:(void (^)(float progress))progress
{
    NSURL *url = [[NSURL alloc] initWithString:filePath];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    AFHTTPRequestOperation *fileUploadOperation = [requestManager POST:requestURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  name                    指定在服务器中获取对应文件或文本时的key
         *  fileName                指定上传文件的原始文件名
         *  mimeType                指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:url name:@"uploadFile" fileName:fileName mimeType:@"image/png" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation, error);
        
    }];
    
    [fileUploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float p = (float)totalBytesWritten / totalBytesExpectedToWrite;
        progress(p);
    }];
}

+ (void)uploadFileWithOption:(NSDictionary *)paramDic
               withInferface:(NSString*)requestURL
                    fileData:(NSData*)fileData
                    fileName:(NSString*)fileName
               uploadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               uploadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                    progress:(void (^)(float progress))progress
{
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *fileUploadOperation = [requestManager POST:requestURL parameters:paramDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  name                    指定在服务器中获取对应文件或文本时的key
         *  fileName                指定上传文件的原始文件名
         *  mimeType                指定商家文件的MIME类型
         */
        [formData appendPartWithFileData:fileData name:@"uploadFile" fileName:fileName mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        success(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(operation, error);
        
    }];
    
    [fileUploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        float p = (float)totalBytesWritten / totalBytesExpectedToWrite;
        progress(p);
    }];
}

@end
