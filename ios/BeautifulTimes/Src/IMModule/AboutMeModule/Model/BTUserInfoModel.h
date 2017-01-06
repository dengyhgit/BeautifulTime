//
//  BTUserInfoModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UserNickName,
    UserWeixinNum,
    UserCompany,
    UserDepartment,
    UserWorker,
    UserTel,
    UserEmail,
}UserInfoType;


@interface BTUserInfoModel : NSObject

//存放信息的文本
@property (nonatomic,copy) NSString *info;
//列表的名字
@property (nonatomic,copy) NSString *name;
//存放图片的二进制
@property (nonatomic,strong) NSData *image;
//判别不同信息的枚举
@property (nonatomic,assign) UserInfoType infoType;

@property (nonatomic, strong) JMSGUser *user;

+(instancetype)profileWithInfo:(NSString *)info infoType:(UserInfoType)infoType name:(NSString*)name;
+(instancetype)profileWithImage:(NSData *)image name:(NSString*)name;

+(instancetype)profileWithUser:(JMSGUser *)user name:(NSString *)name;

@end
