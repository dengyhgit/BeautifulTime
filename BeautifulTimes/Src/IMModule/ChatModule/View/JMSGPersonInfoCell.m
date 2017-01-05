//
//  JMSGPersonInfoCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGPersonInfoCell.h"
@implementation JMSGPersonInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_personInfoConten setTextColor:UIColorFromRGB(0x808080)];
    _personInfoConten.textAlignment = NSTextAlignmentRight;
    [_personInfoConten setEnabled:NO];
    [_personInfoConten setNumberOfLines:0];
    
    UIView *subLine = [UIView new];
    [self  addSubview:subLine];
    [subLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self);
    }];
    subLine.backgroundColor = kSeparationLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
