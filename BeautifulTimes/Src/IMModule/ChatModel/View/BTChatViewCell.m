//
//  BTChatViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatViewCell.h"
#import "BTChatViewShow.h"

@interface BTChatViewCell ()

@property (nonatomic,weak)  BTChatViewShow *viewShow;

@end

@implementation BTChatViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){

        [self setupFirst];
        
    }
    return self;
}

-(void)setupFirst
{
    BTChatViewShow *viewShow=[[BTChatViewShow alloc]init];
    [self.contentView addSubview:viewShow];
    self.viewShow = viewShow;
    self.viewShow.userInteractionEnabled = NO;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    BTChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[BTChatViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (void)setFrameModel:(BTMessageFrameModel *)frameModel
{
    self.viewShow.frameModel = frameModel;
}

@end
