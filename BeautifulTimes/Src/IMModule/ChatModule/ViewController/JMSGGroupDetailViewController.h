//
//  JMSGGroupDetailViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGChatViewController.h"

typedef NS_ENUM(NSInteger, AlertViewTag) {
    //清除聊天记录
    kAlertViewTagClearChatRecord = 100,
    //修改群名
    kAlertViewTagRenameGroup = 200,
    //添加成员
    kAlertViewTagAddMember = 300,
    //退出群组
    kAlertViewTagQuitGroup = 400
};

@interface JMSGGroupDetailViewController : UIViewController

@property (nonatomic,weak) JMSGConversation *conversation;
@property (nonatomic,weak) JMSGChatViewController *sendMessageCtl;
@property (nonatomic,strong) NSMutableArray *memberArr;

- (void)quitGroup;

@end
