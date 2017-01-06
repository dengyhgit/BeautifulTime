//
//  JMSGMessageTableView.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGMessageTableView.h"

@implementation JMSGMessageTableView

- (void)setContentSize:(CGSize)contentSize
{
    if(_isFlashToLoad){// 去除发消息滚动的影响
        if (!CGSizeEqualToSize(self.contentSize, CGSizeZero))
        {
            if (contentSize.height > self.contentSize.height)
            {
                CGPoint offset = self.contentOffset;
                offset.y += (contentSize.height - self.contentSize.height);
                self.contentOffset = offset;
            }
        }
    }
    _isFlashToLoad = NO;
    [super setContentSize:contentSize];
}

- (void)loadMoreMessage {
    _isFlashToLoad = YES;
    [self reloadData];
}
@end
