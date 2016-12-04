//
//  BTSettingCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/18.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMSettingCell.h"
#import "BTIMSettingView.h"

@interface BTIMSettingCell ()

@property (nonatomic,weak) BTIMSettingView *settingView;

@end

@implementation BTIMSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupFirst];
    }
    return self;
}

//添加子视图
-(void)setupFirst
{
    BTIMSettingView *setting = [[BTIMSettingView alloc] initWithFrame:self.bounds];
    
    [self.contentView addSubview:setting];
    self.settingView = setting;
}
-(void)setSettingModel:(BTIMSettingModel *)settingModel
{
    _settingModel = settingModel;
    self.settingView.settingModel = settingModel;
}

@end
