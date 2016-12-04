//
//  JMSGFriendDetailViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGFriendDetailMessgeCell.h"

@interface JMSGFriendDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SkipToSendMessageDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) JMSGUser *userInfo;
@property (assign, nonatomic) BOOL isGroupFlag;

@end
