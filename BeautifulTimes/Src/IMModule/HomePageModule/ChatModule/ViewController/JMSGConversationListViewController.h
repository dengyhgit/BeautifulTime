//
//  JMSGConversationListViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGChatTable.h"
@interface JMSGConversationListViewController : UIViewController <
UISearchBarDelegate,
UISearchControllerDelegate,
UITableViewDataSource,
UITableViewDelegate,
UISearchDisplayDelegate,
TouchTableViewDelegate,
UIGestureRecognizerDelegate,
JMessageDelegate,
JMSGConversationDelegate>

@property (weak, nonatomic) IBOutlet JMSGChatTable *chatTableView;

@end
