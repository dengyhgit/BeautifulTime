//
//  BTChatMessageCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatMessageCell.h"
#import "BTBadgeButton.h"

@interface BTChatMessageCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) BTBadgeButton *badgeButton;

@end

@implementation BTChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.badgeButton];
        
        WS(weakSelf);
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(10);
            make.left.equalTo(weakSelf).offset(8);
            make.width.equalTo(@(44));
            make.height.equalTo(@(44));
        }];
        
        [self.badgeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headIcon).offset(-10);
            make.right.equalTo(weakSelf.headIcon).offset(10);
        }];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(-5);
            make.width.equalTo(@(100));
            make.height.equalTo(@(20));
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headIcon);
            make.left.equalTo(weakSelf.headIcon).offset(44 + 10);
            make.height.equalTo(@(20));
            make.right.equalTo(weakSelf.time).offset(-(100 + 5));
        }];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.title).offset(20 + 8);
            make.left.equalTo(weakSelf.headIcon).offset(44 + 10);
            make.height.equalTo(@(16));
            make.right.equalTo(weakSelf).offset(-5);
        }];
    }
    return self;
}

- (void)bindData:(JMSGConversation *)conversation {
    JMSGUser *user = conversation.target;
    WS(weakSelf);
    [user thumbAvatarData:^(NSData *data, NSString *objectId, NSError *error) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        if (image) {
            weakSelf.headIcon.image = image;
        } else {
            weakSelf.headIcon.image = BT_LOADIMAGE(@"com_ic_defaultIcon");
        }
    }];
    
    self.title.text = user.displayName;
    self.content.text = conversation.latestMessageContentText;
    self.badgeButton.badgeValue = [NSString stringWithFormat:@"%d", conversation.unreadCount.intValue];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
        [_headIcon setBorderWithWidth:0 color:nil cornerRadius:4];
    }
    return _headIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = BT_FONTSIZE(17);
    }
    return _title;
}

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = BT_FONTSIZE(13);
        _content.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_c"];
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
    }
    return _time;
}

- (BTBadgeButton *)badgeButton {
    if (!_badgeButton) {
        _badgeButton = [[BTBadgeButton alloc] init];
    }
    return _badgeButton;
}

@end
