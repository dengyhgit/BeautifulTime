//
//  YHParseEmotionMessage.m
//  BeautifulTimes
//
//  Created by deng on 17/1/4.
//  Copyright © 2017年 dengyonghao. All rights reserved.
//

#import "YHParseEmotionMessage.h"
#import "HMRegexResult.h"
#import "HMEmotion.h"
#import "HMEmotionTool.h"
#import "HMEmotionAttachment.h"
#import "RegexKitLite.h"

@implementation YHParseEmotionMessage

+ (NSArray *)regexResultsWithText:(NSString *)text
{
    // 用来存放所有的匹配结果
    NSMutableArray *regexResults = [NSMutableArray array];
    
    // 匹配表情
    NSString *emotionRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    [text enumerateStringsMatchedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = YES;
        [regexResults addObject:rr];
    }];
    
    // 匹配非表情
    [text enumerateStringsSeparatedByRegex:emotionRegex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        HMRegexResult *rr = [[HMRegexResult alloc] init];
        rr.string = *capturedStrings;
        rr.range = *capturedRanges;
        rr.emotion = NO;
        [regexResults addObject:rr];
    }];
    
    // 排序
    [regexResults sortUsingComparator:^NSComparisonResult(HMRegexResult *rr1, HMRegexResult *rr2) {
        long loc1 = rr1.range.location;
        long loc2 = rr2.range.location;
        return [@(loc1) compare:@(loc2)];
    }];
    return regexResults;
}

+ (NSAttributedString *)attributedStringWithText:(NSString *)text
{
    // 1.匹配字符串
    NSArray *regexResults = [self regexResultsWithText:text];
    
    // 2.根据匹配结果，拼接对应的图片表情和普通文本
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    // 遍历
    [regexResults enumerateObjectsUsingBlock:^(HMRegexResult *result, NSUInteger idx, BOOL *stop) {
        HMEmotion *emotion = nil;
        if (result.isEmotion) { // 表情
            emotion = [HMEmotionTool emotionWithDesc:result.string];
        }
        
        if (emotion) { // 如果有表情
            // 创建附件对象
            HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
            
            // 传递表情
            attach.emotion = emotion;
            attach.bounds = CGRectMake(0, -3, BT_FONTSIZE(16).lineHeight, BT_FONTSIZE(16).lineHeight);
            
            // 将附件包装成富文本
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            [attributedString appendAttributedString:attachString];
        } else { // 非表情（直接拼接普通文本）
            NSMutableAttributedString *substr = [[NSMutableAttributedString alloc] initWithString:result.string];
            [attributedString appendAttributedString:substr];
        }
    }];
    
    // 设置字体
    [attributedString addAttribute:NSFontAttributeName value:BT_FONTSIZE(16) range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

@end
