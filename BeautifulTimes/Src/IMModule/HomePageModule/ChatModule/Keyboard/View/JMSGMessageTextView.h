//
//  JMSGMessageTextView.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMEmotion.h"

typedef NS_ENUM(NSUInteger, JPIMInputViewType) {
    JPIMInputViewTypeNormal = 0,
    JPIMInputViewTypeText,
    JPIMInputViewTypeEmotion,
    JPIMInputViewTypeShareMenu,
};

@interface JMSGMessageTextView : UITextView


@property (nonatomic, copy) NSString *placeHolder;

@property (nonatomic, strong) UIColor *placeHolderTextColor;

/**
 *  获取自身文本占据有多少行
 *
 *  @return 返回行数
 */
- (NSUInteger)numberOfLinesOfText;

/**
 *  获取每行的高度
 *
 *  @return 根据iPhone或者iPad来获取每行字体的高度
 */
+ (NSUInteger)maxCharactersPerLine;

/**
 *  获取某个文本占据自身适应宽带的行数
 *
 *  @param text 目标文本
 *
 *  @return 返回占据行数
 */
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;

/**
 *  拼接表情
 */
- (void)appendEmotion:(HMEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)messageText;

@end
