//
//  JMSGLoadMessageTableViewCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGLoadMessageTableViewCell.h"

@implementation JMSGLoadMessageTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self != nil) {
        loadIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kApplicationWidth/2 - 10, 10, 20, 20)];
        [loadIndicator startAnimating];
        loadIndicator.hidesWhenStopped = NO;
        loadIndicator.color = [UIColor grayColor];
        [self addSubview:loadIndicator];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)startLoading {
    [loadIndicator startAnimating];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
