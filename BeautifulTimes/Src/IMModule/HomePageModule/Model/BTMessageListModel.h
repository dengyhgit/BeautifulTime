//
//  BTMessageListModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTMessageListModel : NSObject

//聊天用户的头像头像
@property (nonatomic,copy) NSData *headerIcon;
//标题
@property (nonatomic,copy) NSString *uname;
//子标题
@property (nonatomic,copy) NSString *body;
//时间
@property (nonatomic,copy) NSDate  *time;
//jid
//@property (nonatomic,strong) XMPPJID *jid; //聊天用户的jid
//数字提醒按钮
@property (nonatomic,copy) NSString *badgeValue;


@end
