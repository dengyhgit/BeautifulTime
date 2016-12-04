//
//  JMSGShowTimeCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGShowTimeCell.h"

@implementation JMSGShowTimeCell

- (void)awakeFromNib {
    [self setBackgroundColor:[UIColor clearColor]];
    self.messageTimeLabel.font = [UIFont systemFontOfSize:14];
    self.messageTimeLabel.textColor = [UIColor grayColor];
    self.messageTimeLabel.textAlignment = NSTextAlignmentCenter;
    self.messageTimeLabel.numberOfLines = 0;
    self.messageTimeLabel.lineBreakMode = NSLineBreakByCharWrapping;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)setCellData:(id)model {
    self.model = model;
    [self setContentFram];
}

- (void)layoutSubviews {
    
}


- (void)setContentFram {
    UIFont *font =[UIFont systemFontOfSize:14];
    CGSize maxSize = CGSizeMake(200, 2000);
    
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize realSize = [[JMSGStringUtils getFriendlyDateString:[self.model.messageTime doubleValue]] boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    [self.messageTimeLabel setFrame:CGRectMake(self.messageTimeLabel.frame.origin.x, self.messageTimeLabel.frame.origin.y, realSize.width,realSize.height)];
    self.messageTimeLabel.text= [NSString stringWithFormat:@"%@",self.model.messageTime];
}

@end
