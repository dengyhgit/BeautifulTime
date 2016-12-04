//
//  JMSGShowTimeCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGChatModel.h"

@interface JMSGShowTimeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *messageTimeLabel;
@property (strong, nonatomic)  JMSGChatModel *model;

- (void)setCellData :(JMSGChatModel *)model;

@end
