//
//  JMSGFileManager.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    FILE_IMAGE=1,
    FILE_AUDIO,
    FILE_VIDIO,
    FILE_UNKNOWN
} FILE_TYPE;

@interface JMSGFileManager : NSObject

/**
 *  初始文件存储路径
 *
 *  @return yes or no
 */
+ (BOOL)initWithFilePath;

+ (NSString *)generatePathWithConversationID:(NSString *)conID withMessageType:(FILE_TYPE)type withFileType:(NSString *)fileType;
+ (BOOL)saveToPath:(NSString *)path withData:(NSData *)data;

+ (NSString*)saveImageWithConversationID:(NSString*)conID andData:(NSData *)imgData;
+ (NSString *)copyFile:(NSString *)sourepath withType:(FILE_TYPE)type From:(NSString *)sourceID to:(NSString *)destinationID;
+ (BOOL)deleteFile:(NSString *)path;
+ (NSString*)saveGlobalBackGround:(NSData *)imgData;

//清空单个会话相关文件
+ (void)deletAllFilesByConversationID:(NSString *)conversationID;

//清空所有会话相关文件
+ (void)deletAllFiles;
+ (void)deletAllFilesAtDocument;
@end
