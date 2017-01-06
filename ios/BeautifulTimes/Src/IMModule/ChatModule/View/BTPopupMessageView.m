//
//  BTPopupMessageView.m
//  BeautifulTimes
//
//  Created by deng on 16/12/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTPopupMessageView.h"
#import "YHParseEmotionMessage.h"

@interface BTPopupMessageView()

@property (nonatomic, strong) UILabel *messagLabel;

@end

@implementation BTPopupMessageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.messagLabel];
    }
    return self;
}

- (void)bindMessage:(JMSGMessage *)message {
    NSString *senderInfo;
    if (message.targetType == kJMSGConversationTypeSingle) {
        JMSGUser *user = message.fromUser;
        senderInfo = [user displayName];
    } else {
        JMSGGroup *group = (JMSGGroup *)message.target;
        senderInfo = group.name ? group.name : group.gid;
    }
    
    NSString *messageInfo;
    if (message.contentType == kJMSGContentTypeText) {
        JMSGTextContent *content = (JMSGTextContent *)message.content;
        self.messagLabel.attributedText = [YHParseEmotionMessage attributedStringWithText:[NSString stringWithFormat:@"%@：%@", senderInfo, content.text]];
    } else {
        if (message.contentType == kJMSGContentTypeImage) {
            messageInfo = @"发来一张图片";
        } else {
            messageInfo = @"发来一段语音";
        }
        [self.messagLabel setText:[NSString stringWithFormat:@"%@：%@", senderInfo, messageInfo]];
    }
    
    
    [self.messagLabel setTextColor:[UIColor whiteColor]];
}

#pragma mark setter
- (UILabel *)messagLabel {
    if (!_messagLabel) {
        _messagLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width - 20, self.height - 20)];
        [self.messagLabel setTextColor:[UIColor whiteColor]];
    }
    return _messagLabel;
}

@end
