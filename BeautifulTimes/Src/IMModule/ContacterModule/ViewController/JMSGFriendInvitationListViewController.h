//
//  JMSGFriendInvitationViewController.h
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGContactModel.h"




@interface JMSGFriendInvitationListViewController : UIViewController



/**添加好友邀请缓存*/
+ (void)addCacheForFriendInvitaionWithEvent:(JMSGFriendNotificationEvent *)model;

@end
