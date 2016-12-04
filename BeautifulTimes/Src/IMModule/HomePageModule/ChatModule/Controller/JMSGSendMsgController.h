//
//  JMSGSendMsgController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JMSGSendMsgController : NSObject<JMessageDelegate>

@property(strong, nonatomic)JMSGConversation *msgConversation;
@property(strong, nonatomic)NSMutableArray *draftImageMessageArr;

- (void)prepareImageMessage:(JMSGMessage *)imgMsg;
- (void)removeDelegate;
- (void)addDelegateForConversation:(JMSGConversation *)conversation;

@end
