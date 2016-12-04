//
//  BTAboutMeCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAboutMeCell.h"
#import "BTAboutMeView.h"

@interface BTAboutMeCell ()

@property (nonatomic,weak) BTAboutMeView *aboutMeView;

@end

@implementation BTAboutMeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //.添加子视图
        [self addView];
    }
    
    return self;
}
-(void)addView
{
    BTAboutMeView *aboutMeView=[[BTAboutMeView alloc]initWithFrame:self.bounds];
    self.aboutMeView = aboutMeView;
    [self.contentView addSubview:aboutMeView];
}

//设置模型
-(void)setItem:(BTAboutMeCellModel *)item
{
    _item = item;
    self.aboutMeView.item = item;
}

@end
