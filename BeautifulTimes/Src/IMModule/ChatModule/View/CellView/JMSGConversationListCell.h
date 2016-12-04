//
//  JMSGConversationListCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JMSGConversationListCell : UITableViewCell
@property(strong, nonatomic) NSString *conversationId;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *messageNumberLabel;
@property (weak, nonatomic) IBOutlet UIView *cellLine;

- (void)setCellDataWithConversation:(JMSGConversation *)conversation;

@end
