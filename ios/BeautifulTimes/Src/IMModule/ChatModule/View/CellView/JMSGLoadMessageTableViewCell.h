//
//  JMSGLoadMessageTableViewCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSGLoadMessageTableViewCell : UITableViewCell
{
    UIActivityIndicatorView *loadIndicator;
}

- (void)startLoading;

@end