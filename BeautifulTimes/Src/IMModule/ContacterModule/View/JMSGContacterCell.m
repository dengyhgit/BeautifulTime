//
//  JMSGContacterCell.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGContacterCell.h"

static CGFloat const OFFSET = 5.0f;
static CGFloat const ICONWIDTH = 30.0f;
static CGFloat const ICONHEIGHT = 30.0f;

@interface JMSGContacterCell ()

@end

@implementation JMSGContacterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.friendName];
        [self.contentView addSubview:self.badgeIcon];
        
        [self.headIcon setImage:[UIImage imageNamed:@"headDefalt"]];
        WS(weakSelf);
        
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(OFFSET);
            make.left.equalTo(weakSelf).offset(OFFSET);
            make.width.equalTo(@(ICONWIDTH));
            make.height.equalTo(@(ICONHEIGHT));
        }];
        
        [self.friendName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.headIcon);
            make.left.equalTo(weakSelf.headIcon).offset(ICONWIDTH + OFFSET);
            make.right.equalTo(weakSelf).offset(-OFFSET);
            make.height.equalTo(@(20));
        }];
        
        [self.badgeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(10));
            make.height.equalTo(@(10));
            
            make.centerY.equalTo(weakSelf.headIcon.mas_top).offset(OFFSET);
            make.left.equalTo(weakSelf.headIcon.mas_right).offset(-OFFSET);
        }];
        self.badgeIcon.layer.cornerRadius = 5.0;
        self.badgeIcon.layer.masksToBounds = YES;
        self.badgeIcon.hidden = YES;
    }
    return self;
}

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
    }
    return _headIcon;
}

- (UILabel *)friendName {
    if (!_friendName) {
        _friendName = [[UILabel alloc] init];
        _friendName.font = BT_FONTSIZE(15);
    }
    return _friendName;
}
- (UIImageView *)badgeIcon {
    if (!_badgeIcon) {
        _badgeIcon = [[UIImageView alloc] init];
        _badgeIcon.backgroundColor = [UIColor redColor];
    }
    return _badgeIcon;
}
@end
