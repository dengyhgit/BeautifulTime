//
//  BTAdressBookCell.m
//  BeautifulTimes
//
//  Created by deng on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAdressBookCell.h"

@interface BTAdressBookCell ()

@end

@implementation BTAdressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.isSelect];
        
        WS(weakSelf);
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView).offset(20);
            make.right.equalTo(weakSelf.contentView).offset(-20);
            make.height.equalTo(@(20));
        }];
        
        [self.isSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.right.equalTo(weakSelf.contentView).offset(-5);
            make.width.equalTo(@(23));
            make.height.equalTo(@(23));
        }];
    }
    return self;
}

- (void)bindData:(BTAddressBook *)addressBook {
    self.name.text = addressBook.name;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
    }
    return _name;
}

- (UIImageView *)isSelect {
    if (!_isSelect) {
        _isSelect = [[UIImageView alloc] init];
        _isSelect.image = BT_LOADIMAGE(@"com_blue_image_select");
        _isSelect.hidden = YES;
    }
    return _isSelect;
}

@end
