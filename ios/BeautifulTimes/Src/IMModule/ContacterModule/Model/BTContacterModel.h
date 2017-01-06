//
//  BTContacterModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/23.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTContacterModel : NSObject

//@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic,copy) NSString *friendName;  //好朋友的名字
@property (nonatomic,strong) UIImage *headIcon ;//好朋友的头像
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *friendNamePinyin;  //用户名的拼音 用来处理分区头

//记录用户当前状态  “0”- 在线    “1”- 离开    “2”- 离线
@property (nonatomic,assign) int userStatus;

@end
