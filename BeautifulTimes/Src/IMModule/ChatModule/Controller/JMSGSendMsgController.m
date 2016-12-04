//
//  JMSGSendMsgController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGSendMsgController.h"

@implementation JMSGSendMsgController
- (id)init {
    self = [super init];
    if (self) {
        _draftImageMessageArr  = @[].mutableCopy;
    }
    return self;
}

- (void)addDelegateForConversation:(JMSGConversation *)conversation {
    [JMessage addDelegate:self withConversation:conversation];
}

- (void)removeDelegate {
    //SDK：删除Delegate监听
    [JMessage removeDelegate:self withConversation:_msgConversation];
    
}

#pragma mark JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
    if (message.contentType != kJMSGContentTypeImage) {
        return;
    }
    if (![_msgConversation isMessageForThisConversation:message]) {
        return;
    }
    [_draftImageMessageArr removeObjectAtIndex:0];
    if ([_draftImageMessageArr count] > 0) {
        [self sendStart];
    }
}

- (void)prepareImageMessage:(JMSGMessage *)imgMsg {
    [_draftImageMessageArr addObject:imgMsg];
    if ([_draftImageMessageArr count] == 1) {
        [self sendStart];
    }
}

- (void)sendStart {
    //SDK：发送消息
    [_msgConversation sendMessage: _draftImageMessageArr[0]];
}

@end
