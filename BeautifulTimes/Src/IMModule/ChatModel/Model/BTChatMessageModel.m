//
//  BTChatMessageModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatMessageModel.h"
#import "HMRegexResult.h"
#import "HMEmotion.h"
#import "HMEmotionTool.h"
#import "HMEmotionAttachment.h"
#import "RegexKitLite.h"

@implementation BTChatMessageModel

-(void)setMessage:(NSString *)message
{
    _message = [message copy];
    [self createAttributedText];
}

- (NSArray *)regexResultsWithText:(NSString *)text
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

- (void)createAttributedText
{
    if (self.message == nil) {
       return;
    }
    //TODO:这里太费时间了，用异步去做会不会引起问题呢
    if ([self.message hasSuffix:@".btpng"]) {
//        dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//        dispatch_async(concurrentQueue, ^{
//            dispatch_sync(concurrentQueue, ^{
//                
//            });
//            dispatch_sync(dispatch_get_main_queue(), ^{
//
//            });
//        });
        NSString *cachesPath = [BTTool getCachesDirectory];
        NSString *savePath = [cachesPath stringByAppendingPathComponent:self.message];
       
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:savePath];
        if (image) {
            NSTextAttachment * textAttachment = [[NSTextAttachment alloc]init];//添加附件,图片
            
            
            textAttachment.image = [self drawImage:image];
            NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:textAttachment];
            self.attributedBody = imageStr;
        } else {
            self.attributedBody = [self attributedStringWithText:@"正在加载图片..."];
        }
    } else {
        self.attributedBody = [self attributedStringWithText:self.message];
    }
}

//这是一个非常耗时的操作，操作次数多的时候不推荐使用
- (UIImage *)drawImage:(UIImage *)image {
    CGFloat scale = 160 / image.size.width;
    
    //设置重新绘制的大小
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scale, image.size.height * scale));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scale, image.size.height * scale)];
    //得到绘制后的Image
    UIImage *transformedImg=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return transformedImg;
}


- (NSAttributedString *)attributedStringWithText:(NSString *)text
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

//- (void)bindData:(XMPPMessageArchiving_Message_CoreDataObject *)xmppMessage {
//    self.message = xmppMessage.body;
//    self.time = [NSString stringWithFormat:@"%@",xmppMessage.timestamp];
//    self.recipient = xmppMessage.bareJidStr;
//    self.isCurrentUser = [[xmppMessage outgoing] boolValue];
//}

@end
