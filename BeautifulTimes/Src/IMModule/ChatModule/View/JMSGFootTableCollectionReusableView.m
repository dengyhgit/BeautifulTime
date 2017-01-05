//
//  JMSGFootTableCollectionReusableView.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGFootTableCollectionReusableView.h"
#import "JMSGFootTableViewCell.h"

@implementation JMSGFootTableCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    _footTableView.tableFooterView = [UIView new];
    [_footTableView registerNib:[UINib nibWithNibName:@"JMSGFootTableViewCell" bundle:nil] forCellReuseIdentifier:@"JMSGFootTableViewCell"];
    _footTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _footTableView.scrollEnabled = NO;
}

@end
