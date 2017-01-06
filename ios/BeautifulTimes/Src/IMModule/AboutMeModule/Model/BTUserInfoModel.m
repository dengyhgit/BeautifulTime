//
//  BTUserInfoModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTUserInfoModel.h"

@implementation BTUserInfoModel

+(instancetype)profileWithInfo:(NSString *)info infoType:(UserInfoType)infoType  name:(NSString *)name
{
    BTUserInfoModel *userInfo=[[BTUserInfoModel alloc]init];
    userInfo.info=info;
    userInfo.name=name;
    userInfo.infoType=infoType;
    return userInfo;
}

+(instancetype)profileWithImage:(NSData *)image name:(NSString *)name
{
    BTUserInfoModel *userInfo=[[BTUserInfoModel alloc]init];
    userInfo.name=name;
    userInfo.image=image;
    return userInfo;
}

+ (instancetype)profileWithUser:(JMSGUser *)user name:(NSString *)name{
    BTUserInfoModel *userInfo=[[BTUserInfoModel alloc]init];
    userInfo.name = name;
    userInfo.user = user;
    return userInfo;
}


@end
