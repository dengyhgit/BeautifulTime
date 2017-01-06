//
//  JMSGFriendDetailMessgeCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SkipToSendMessageDelegate <NSObject>

/*跳转到聊天消息*/
- (void)skipToSendMessage;

@end

@interface JMSGFriendDetailMessgeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (strong, nonatomic) id<SkipToSendMessageDelegate> skipToSendMessage;

@end
