//
//  BTChatMessageModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTChatMessageModel : NSObject

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSAttributedString *attributedBody;
@property (nonatomic, copy) NSString *time ;
@property (nonatomic, copy) NSString *sender; //发送方
@property (nonatomic, copy) NSString *recipient ;//接收人
@property (nonatomic, strong) UIImage *friendHeadIcon;   //聊天用户的头像
@property (nonatomic, strong) NSData *ownHeadIcon;    //用户自己的头像
@property (nonatomic, assign) BOOL hiddenTime;     //是否隐藏时间
@property (nonatomic, assign) BOOL isCurrentUser;  //如果是YES就是当前用户  如果是NO就是聊天的用户

//- (void)bindData:(JMSGConversation *)conversation;

@end
