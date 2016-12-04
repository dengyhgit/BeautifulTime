//
//  BTMessageFrameModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTChatMessageModel.h"

@interface BTMessageFrameModel : NSObject

@property (nonatomic,strong)  BTChatMessageModel  *messageModel;  //传递模型

//时间的frame
@property (nonatomic,assign,readonly) CGRect timeFrame;
//头像的frame
@property (nonatomic,assign,readonly) CGRect headFrame;
//内容的frame
@property (nonatomic,assign,readonly) CGRect contentFrame;
//单元格的高度
@property (nonatomic,assign,readonly) CGFloat cellHeight;
//聊天单元的frame
@property (nonatomic,assign,readonly) CGRect  chatFrame;

@end
