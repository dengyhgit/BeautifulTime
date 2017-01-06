//
//  BTAboutMeCellModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAboutMeCellModel.h"

@implementation BTAboutMeCellModel

+(instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title detailTitle:(NSString *)detailTitle vcClass:(Class)vcClass
{
    BTAboutMeCellModel *item = [[BTAboutMeCellModel alloc] init];
    item.title = title;
    item.detailTitle = detailTitle;
    item.icon = icon;
    item.vcClass = vcClass;
    return item;
}

+(instancetype)itemWithUser:(JMSGUser *)user title:(NSString*)title detailTitle:(NSString*)detailTitle vcClass:(Class)vcClass {
    BTAboutMeCellModel *item = [[BTAboutMeCellModel alloc] init];
    item.user = user;
    item.title = title;
    item.detailTitle = detailTitle;
    item.vcClass = vcClass;
    return item;
}

@end
