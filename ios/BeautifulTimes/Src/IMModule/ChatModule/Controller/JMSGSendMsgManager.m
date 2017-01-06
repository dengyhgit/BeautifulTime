//
//  JMSGSendMsgManager.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGSendMsgManager.h"
#import "JMSGSendMsgController.h"

@implementation JMSGSendMsgManager
+ (JMSGSendMsgManager *)ins {
    static JMSGSendMsgManager *sendMsgManage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sendMsgManage = [[JMSGSendMsgManager alloc] init];
    });
    return sendMsgManage;
}

- (id)init {
    self = [super init];
    if (self) {
        _sendMsgListDic  = @{}.mutableCopy;
        _textDraftDic = @{}.mutableCopy;
    }
    return self;
}

- (void)addMessage:(JMSGMessage *)imgMsg withConversation:(JMSGConversation *)conversation {
    NSString *key = nil;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        key = ((JMSGUser *)conversation.target).username;
    } else {
        key = ((JMSGGroup *)conversation.target).gid;
    }
    
    if (_sendMsgListDic[key] == nil) {
        JMSGSendMsgController *sendMsgCtl = [[JMSGSendMsgController alloc] init];
        sendMsgCtl.msgConversation = conversation;
        [sendMsgCtl addDelegateForConversation:conversation];
        [sendMsgCtl prepareImageMessage:imgMsg];
        _sendMsgListDic[key] = sendMsgCtl;
    } else {
        JMSGSendMsgController *sendMsgCtl = _sendMsgListDic[key];
        [sendMsgCtl prepareImageMessage:imgMsg];
    }
}

- (void)updateConversation:(JMSGConversation *)conversation withDraft:(NSString *)draftString {
    NSString *key = nil;
    key = [JMSGStringUtils conversationIdWithConversation:conversation];
    _textDraftDic[key] = draftString;
}

- (NSString *)draftStringWithConversation:(JMSGConversation *)conversation {
    NSString *key = nil;
    key = [JMSGStringUtils conversationIdWithConversation:conversation];
    return _textDraftDic[key] ? _textDraftDic[key] : @"";
}
@end
