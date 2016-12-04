//
//  BTEditUserInfoCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTEditUserInfoCell.h"
#import "BTEditUserInfoView.h"

@interface BTEditUserInfoCell ()

@property (nonatomic,weak) BTEditUserInfoView *editView;

@end

@implementation BTEditUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupFirst];
    }
    return self;
}
-(void)setupFirst
{
    BTEditUserInfoView *editView = [[BTEditUserInfoView alloc]initWithFrame:self.bounds];
    [self.contentView addSubview:editView];
    self.editView=editView;
    self.input=editView.textField;
}

-(void)setStr:(NSString *)str
{
    _str=[str copy];
    self.editView.str=str;
}
@end
