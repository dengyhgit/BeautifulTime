//
//  BTTool.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTool.h"

static BTTool * tool = nil;

@implementation BTTool

+ (BTTool *)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[BTTool alloc] init];
    });
    return tool;
}

+ (BOOL)createDirectory:(NSString *)path
{
    if (nil == path || 0 == [path length]) {
        return NO;
    }
    
    BOOL isDir;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        return YES;
    }
    else {
        NSError *error;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            return NO;
        }
        else {
            return YES;
        }
    }
    
}

/**
 *  把字符串转成拼音
 *
 *  @param string 要进行转换的字符串
 *
 *  @return 转换后的拼音
 */
+ (NSString *)stringToPinyinWithTone:(NSString *)string
{
    if( [string length] >0)
    {
        NSMutableString *source = [string mutableCopy];
        
        //拼音带音标
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        //转换为普通字母
        //        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
        return source;
    }
    else
        return nil;
    
}

+ (NSString *)firstCharOfStringToPinyinWithTone:(NSString *)string {
    if( [string length] >0)
    {
        NSMutableString *source = [string mutableCopy];
        CFRange range = CFRangeMake(0, 1);
        
        //拼音带音标
        CFStringTransform((__bridge CFMutableStringRef)source, &range, kCFStringTransformMandarinLatin, NO);
        
        //转换为普通字母
        //        CFStringTransform((__bridge CFMutableStringRef)source, &range, kCFStringTransformStripDiacritics, NO);
        return source;
    }
    else
        return nil;
}

+ (NSString *)stringToPinyinWithoutTone:(NSString *)string {
    if( [string length] >0)
    {
        NSMutableString *source = [string mutableCopy];
        
        //拼音带音标
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformMandarinLatin, NO);
        //转换为普通字母
        CFStringTransform((__bridge CFMutableStringRef)source, NULL, kCFStringTransformStripDiacritics, NO);
        return source;
    }
    else
        return nil;
}

+ (BOOL)isBlankLine:(NSString *)source{
    NSString * regex = @"^\\s*$";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:source];
    return result;
}

+ (BOOL)isLetter:(NSString *)source{
    NSString * regex = @"[A-Za-z]+";
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL result = [predicate evaluateWithObject:source];
    if (!result) {
        NSLog(@"当前字符串首字符不是字母%@", source);
    }
    return result;
}

+ (NSString *)getCurrentLanguage
{
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
}

+ (NSString *)getDocumentDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)getLibraryDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

+ (NSString *)getCachesDirectory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return path;
}

// appkey
+ (NSString *)getJMessageAppKey {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appkey = dictionary[@"JMessageAppKey"];
    return appkey;
}

+ (NSString *)getUMAppKey {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appkey = dictionary[@"UMAppKey"];
    return appkey;
}

+ (NSString *)getWXAppKey {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appkey = dictionary[@"WXAppKey"];
    return appkey;
}

+ (NSString *)getWXAppSecret {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *appSecret = dictionary[@"WXAppSecret"];
    return appSecret;
}

+ (NSString *)getAdMobBannerId {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"PrivateInfo" ofType:@"plist"];
    NSDictionary *dictionary = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    NSString *bannerId = dictionary[@"AdMobBannerId"];
    return bannerId;
}

@end
