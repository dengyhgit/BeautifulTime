//
//  JMSGConversationListCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGConversationListCell.h"
#import "JMSGSendMsgManager.h"
#import "YHParseEmotionMessage.h"

@implementation JMSGConversationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.time.textColor = [UIColor grayColor];
    self.nickName.textColor = UIColorFromRGB(0x3f80dd);
    self.message.textColor = UIColorFromRGB(0x808080);
    
    [self.messageNumberLabel.layer setMasksToBounds:YES];
    self.messageNumberLabel.layer.cornerRadius = 11;
    self.messageNumberLabel.layer.borderWidth = 1;
    self.messageNumberLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    self.messageNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.messageNumberLabel setBackgroundColor:UIColorFromRGB(0xfa3e32)];
    self.messageNumberLabel.textColor = [UIColor whiteColor];
    
    UIView *cellLine = [UIView new];
    [self addSubview:cellLine];
    [cellLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self);
    }];
    _cellLine.backgroundColor = kSeparationLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (selected){
        self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
    [super setHighlighted:highlighted animated:animated];
    
    if (highlighted){
        self.messageNumberLabel.backgroundColor = UIColorFromRGB(0xfa3e32);
    }
}

- (void)setCellDataWithConversation:(JMSGConversation *)conversation {
    self.headView.layer.cornerRadius = 23;
    [self.headView.layer setMasksToBounds:YES];
    self.nickName.text = conversation.title;
    self.conversationId = [self conversationIdWithConversation:conversation];
    
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = conversation.target;
        [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (error == nil) {
                if (data != nil) {
                    [self.headView setImage:[UIImage imageWithData:data]];
                } else {
                    [self.headView setImage:[UIImage imageNamed:@"headDefalt"]];
                }
            }
        }];
    } else {
        //SDK：异步获取会话头像
        [conversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
            if (![objectId isEqualToString:_conversationId]) {
                return ;
            }
            if (error == nil) {
                if (data != nil) {
                    [self.headView setImage:[UIImage imageWithData:data]];
                } else {
                    [self.headView setImage:[UIImage imageNamed:@"talking_icon_group"]];
                }
            }
        }];
    }
    
    
    if ([conversation.unreadCount integerValue] > 0) {
        [self.messageNumberLabel setHidden:NO];
        self.messageNumberLabel.text = [NSString stringWithFormat:@"%@", conversation.unreadCount];
    } else {
        [self.messageNumberLabel setHidden:YES];
    }
    
    if (conversation.latestMessage.timestamp != nil ) {
        double time = [conversation.latestMessage.timestamp doubleValue];
        self.time.text = [JMSGStringUtils getFriendlyDateString:time / 1000 forConversation:YES];
    } else {
        self.time.text = @"";
    }
    
    if ([[[JMSGSendMsgManager ins] draftStringWithConversation:conversation] isEqualToString:@""]) {
        self.message.attributedText = [YHParseEmotionMessage attributedStringWithText:conversation.latestMessageContentText];
    } else {
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"[草稿] %@",[[JMSGSendMsgManager ins] draftStringWithConversation:conversation]]];
        [attriString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor redColor]
                            range:NSMakeRange(0, 4)];
        
        self.message.attributedText = attriString;
    }
}

- (NSString *)conversationIdWithConversation:(JMSGConversation *)conversation {
    NSString *conversationId = nil;
    if (conversation.conversationType == kJMSGConversationTypeSingle) {
        JMSGUser *user = conversation.target;
        conversationId = [NSString stringWithFormat:@"%@_%ld",user.username, (long) kJMSGConversationTypeSingle];
    } else {
        JMSGGroup *group = conversation.target;
        conversationId = [NSString stringWithFormat:@"%@_%ld",group.gid,(long) kJMSGConversationTypeGroup];
    }
    return conversationId;
}


@end
