//
//  BTMyInformationCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/18.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTMyInformationCell.h"

@interface BTMyInformationCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *userId;

@end

@implementation BTMyInformationCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.nickName];
        [self.contentView addSubview:self.userId];
        
//        WS(weakSelf);
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.userId mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma -mark getters
- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
    }
    return _headIcon;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
    }
    return _nickName;
}

- (UILabel *)userId {
    if (!_userId) {
        _userId = [[UILabel alloc] init];
    }
    return _userId;
}

@end
