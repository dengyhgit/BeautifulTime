//
//  BTTimelineDB.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTimelineModel.h"

@interface BTTimelineDB : NSObject

/**
 *  获取通讯记录数据库单例
 *
 *  @return 数据库单例
 */
+ (BTTimelineDB *) sharedInstance;

/**
 *  数据库路径
 *
 *  @return 数据库路径
 */
- (NSString *) getDBPath;

/**
 *  创建数据库
 */
- (void) createHistoryDB;

/**
 *  添加一条记录
 *
 *  @param timeline记录
 */
- (void)addHistory:(BTTimelineModel *)message;

/**
 *  得到指定点滴
 *
 *  @param timelineID timelineId
 *
 *  @return 指定记录
 */
- (BTTimelineModel *) getTimelineByID:(NSInteger)timelineID;

/**
 *  更新记录
 *
 *  @param history    更新内容
 */
- (void)updateHistory:(BTTimelineModel *)history;

/**
 *  删除指定点滴
 *
 *  @param timelineID timelineId
 */
- (void)deleteHistoryByTimelineID:(NSInteger)timelineID;

/**
 *  删除所有点滴
 */
- (void)deleteAllHistory;

/**
 *  获得所有点滴
 *
 *  @return 点滴的arrary
 */
- (NSArray *)getAllHistory;

@end
