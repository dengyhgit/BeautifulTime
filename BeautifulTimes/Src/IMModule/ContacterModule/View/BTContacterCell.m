//
//  BTContacterCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/23.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTContacterCell.h"

static CGFloat const OFFSET = 5.0f;
static CGFloat const ICONWIDTH = 30.0f;
static CGFloat const ICONHEIGHT = 30.0f;

@interface BTContacterCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *friendName;

@end


@implementation BTContacterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.friendName];
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
        
    }
    return self;
}

- (void)bindData:(JMSGUser *)user {
    WS(weakSelf);
    [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        if (!error) {
            if (!data) {
                weakSelf.headIcon.image = BT_LOADIMAGE(@"com_ic_defaultIcon");
            } else {
                weakSelf.headIcon.image = [[UIImage alloc] initWithData:data];
            }
        }
    }];
    
    if (user.nickname) {
        self.friendName.text = user.nickname;
    } else {
        self.friendName.text = user.username ;
    }
    
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

@end
