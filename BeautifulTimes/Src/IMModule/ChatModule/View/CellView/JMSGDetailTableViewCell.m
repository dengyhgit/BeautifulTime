//
//  JMSGDetailTableViewCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGDetailTableViewCell.h"

@implementation JMSGDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UILabel *line =[[UILabel alloc] initWithFrame:CGRectMake(0, 56,kApplicationWidth, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(0xd0d0cf)];
    [self addSubview:line];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
