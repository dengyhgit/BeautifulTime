//
//  JMSGFriendInvitationCell.m
//  JMessageDemo
//
//  Created by xudong.rao on 16/7/26.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFriendInvitationCell.h"


@implementation JMSGFriendInvitationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)acceptAction:(id)sender {
    if (_friendInvitationResponseBlock) {
        _friendInvitationResponseBlock(YES);
    }
}

-(void)setModel:(JMSGContactModel *)model{
    _model = model;
    
    _nameLabel.text = model.name;
    _decLabel.text = [model.dec length]>0 ? model.dec : [NSString stringWithFormat:@"%@添加你为好友",model.name];
    self.dealWithType = _model.dealWithType;
}
-(void)setDealWithType:(JMSGFriendInvitationType)dealWithType {
    _dealWithType = dealWithType;
    UIColor *color = [UIColor colorWithRed:11.0/255.0 green:131.0/255.0 blue:1.0/255.0 alpha:1];
    
    if (dealWithType == JMSGFriendInvitation_accept) {
        [self.acceptButton setTitle:@"已添加" forState:UIControlStateNormal];
        [self.acceptButton setBackgroundColor:[UIColor clearColor]];
        [self.acceptButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.acceptButton.enabled = NO;
    }
    else if (dealWithType == JMSGFriendInvitation_reject){
//        [self.rejectButton setTitle:@"已拒绝" forState:UIControlStateNormal];
//        [self.rejectButton setBackgroundColor:[UIColor clearColor]];
//        self.rejectButton.enabled = NO;
//        self.acceptButton.hidden = YES;
    }
    else{
        [self.acceptButton setTitle:@"接受" forState:UIControlStateNormal];
        [self.acceptButton setBackgroundColor:color];
        [self.acceptButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.acceptButton.enabled = YES;
        
//        [self.rejectButton setTitle:@"拒绝" forState:UIControlStateNormal];
//        [self.rejectButton setBackgroundColor:color];
//        self.rejectButton.enabled = YES;
//        self.rejectButton.hidden = NO;
    }
}
@end
