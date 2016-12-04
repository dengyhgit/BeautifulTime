//
//  JMSGContactModel.h
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JMSGFriendInvitationType) {
    /// 没处理
    JMSGFriendInvitation_none = 0,
    /// 接受了
    JMSGFriendInvitation_accept = 1,
    /// 拒绝了
    JMSGFriendInvitation_reject = 2,
};

@interface JMSGContactModel : NSObject

@property (nonatomic, strong) JMSGUser *user;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *appkey;
@property (nonatomic, strong) NSString *dec;
@property (nonatomic, assign) JMSGFriendInvitationType dealWithType;

@end
