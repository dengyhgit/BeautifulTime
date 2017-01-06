//
//  JMSGFriendInvitationCell.h
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGContactModel.h"

@interface JMSGFriendInvitationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *acceptButton;

@property (weak, nonatomic) IBOutlet UIImageView *headIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *decLabel;

@property (nonatomic, strong) JMSGContactModel *model;
@property (nonatomic, assign) JMSGFriendInvitationType dealWithType;

- (IBAction)acceptAction:(id)sender;

@property (nonatomic, copy) void(^friendInvitationResponseBlock)(BOOL isAccept);

@end
