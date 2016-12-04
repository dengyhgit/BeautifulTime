//
//  BTSendTextView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTSendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionAttachment.h"

@implementation BTSendTextView

-(instancetype)init
{
    self = [super init];
    if(self){
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 0.5;
        self.layer.cornerRadius = 5;
        self.returnKeyType = UIReturnKeySend;
        self.font = BT_FONTSIZE(16);
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

- (void)appendEmotion:(HMEmotion *)emotion
{
    if (emotion.emoji) {
        [self insertText:emotion.emoji];
    }
    else {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        
        HMEmotionAttachment *attach = [[HMEmotionAttachment alloc] init];
        attach.emotion = emotion;
        attach.bounds = CGRectMake(0, -3, self.font.lineHeight, self.font.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        // 记录表情的插入位置
        long insertIndex = self.selectedRange.location;
        
        // 插入表情图片到光标位置
        [attributedText insertAttributedString:attachString atIndex:insertIndex];
        
        // 设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        
        // 重新赋值(光标会自动回到文字的最后面)
        self.attributedText = attributedText;
        
        // 让光标回到表情后面的位置
        self.selectedRange = NSMakeRange(insertIndex + 1, 0);
    }
}

- (NSString *)messageText
{
    NSMutableString *string = [NSMutableString string];
    
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        HMEmotionAttachment *attach = attrs[@"NSAttachment"];
        if (attach) {
            [string appendString:attach.emotion.chs];
        }
        else {
            NSString *substr = [self.attributedText attributedSubstringFromRange:range].string;
            [string appendString:substr];
        }
    }];
    return string;
}

@end
