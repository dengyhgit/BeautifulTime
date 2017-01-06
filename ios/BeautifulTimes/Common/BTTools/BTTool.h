//
//  BTTool.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTool : NSObject

+ (BTTool *)sharedInstance;

// 创建路径
+ (BOOL)createDirectory:(NSString*)path;

// 获取汉字拼音，带声调
+ (NSString *)stringToPinyinWithTone:(NSString *)string;

+ (NSString *)firstCharOfStringToPinyinWithTone:(NSString *)string;

// 获取汉字拼音，不带声调 会很耗时
+ (NSString *)stringToPinyinWithoutTone:(NSString *)string;

/**
 *  是否为空字符串
 *
 *  @param source 需检测的字符串
 *
 *  @return source是空字符串返回YES，否则返回NO
 */
+ (BOOL)isBlankLine:(NSString *)source;

/**
 *  是否为字母（A-Za-z）
 *
 *  @param source 需检测的字符串
 *
 *  @return source是字母返回YES，否则返回NO
 */
+ (BOOL)isLetter:(NSString *)source;

/**
 *  获取当前系统语言
 *
 *  @return 当前语言
 */
+ (NSString *)getCurrentLanguage;

/**
 *  DocumentDirectory
 *
 *  @return DocumentDirectory目录
 */
+ (NSString *)getDocumentDirectory;

/**
 *  LibraryDirectory
 *
 *  @return LibraryDirectory目录
 */
+ (NSString *)getLibraryDirectory;

/**
 *  CachesDirectory
 *
 *  @return CachesDirectory目录
 */
+ (NSString *)getCachesDirectory;

+ (NSString *)getJMessageAppKey;

+ (NSString *)getUMAppKey;

+ (NSString *)getWXAppKey;

+ (NSString *)getWXAppSecret;

+ (NSString *)getAdMobBannerId;

@end
