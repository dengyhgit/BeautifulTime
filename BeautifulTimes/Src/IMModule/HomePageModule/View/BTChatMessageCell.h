//
//  BTChatMessageCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMessageListModel.h"

@interface BTChatMessageCell : UITableViewCell

- (void)bindData:(JMSGConversation *)conversation;

@end
