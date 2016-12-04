//
//  JMSGChatTable.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGChatTable.h"

@implementation JMSGChatTable

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if ([self.touchDelegate conformsToProtocol:@protocol(TouchTableViewDelegate)] &&
        [self.touchDelegate respondsToSelector:@selector(tableView:touchesBegan:withEvent:)])
    {
        [self.touchDelegate tableView:self touchesBegan:touches withEvent:event];
    }
}

@end
