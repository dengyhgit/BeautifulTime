//
//  JMSGMessageContentView.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSGMessageContentView :UIImageView

@property(assign, nonatomic)BOOL isReceivedSide;
@property(strong, nonatomic)UILabel *textContent;
@property(strong, nonatomic)UIImageView *voiceConent;
@property(strong, nonatomic)JMSGMessage *message;
- (void)setMessageContentWith:(JMSGMessage *)message;

@end
