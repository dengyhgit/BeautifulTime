//
//  JMSGChatModel.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/8.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface JMSGChatModel : NSObject

@property (nonatomic, strong) JMSGMessage * message;
@property (nonatomic, strong) NSNumber *messageTime;
@property (nonatomic, assign) NSInteger photoIndex;
@property (nonatomic, assign) float contentHeight;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, strong) NSString *timeId;
@property (nonatomic, assign) BOOL isTime;
@property (nonatomic, assign) BOOL isErrorMessage;
@property (nonatomic, strong) NSError *messageError;

- (float)getTextHeight;
- (void)setupImageSize;
- (void)setChatModelWith:(JMSGMessage *)message conversationType:(JMSGConversation *)conversation;
- (void)setErrorMessageChatModelWithError:(NSError *)error;

@end
