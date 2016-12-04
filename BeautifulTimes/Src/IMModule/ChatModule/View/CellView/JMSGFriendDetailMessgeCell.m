//
//  JMSGFriendDetailMessgeCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFriendDetailMessgeCell.h"

@implementation JMSGFriendDetailMessgeCell

- (void)awakeFromNib {
    [self.skipBtn.layer setMasksToBounds:YES];
    self.skipBtn.layer.cornerRadius = 4;
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.skipBtn setBackgroundImage:[JMSGViewUtil colorImage:UIColorFromRGB(0x6fd66b) frame:_skipBtn.frame] forState:UIControlStateNormal];
    [self.skipBtn setBackgroundImage:[JMSGViewUtil colorImage:UIColorFromRGB(0x50cb50) frame:_skipBtn.frame] forState:UIControlStateHighlighted];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)skipToSendMessage:(id)sender {
    if (self.skipToSendMessage && [self.skipToSendMessage respondsToSelector:@selector(skipToSendMessage)]) {
        [self.skipToSendMessage skipToSendMessage];
    }
}

@end
