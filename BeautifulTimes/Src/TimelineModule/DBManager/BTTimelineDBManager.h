//
//  BTTimelineDBManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTimelineModel.h"

@interface BTTimelineDBManager : NSObject

+ (BTTimelineDBManager *)sharedInstance;

/**
 *  添加 timeline message
 *
 *  @param timeline message
 */
- (void)addTimelineMessage:(BTTimelineModel *)message;

/**
 *  得到所以有记录
 *
 *  @return 所有记录的array
 */
- (NSArray *)getAllTimelineMessage;

/**
 *  查找指定记录
 *
 *  @param Id timeline id
 *
 *  @return timelineModel
 */
- (BTTimelineModel *)getTimelineWithId:(NSInteger)Id;

/**
 *  删除指定点滴
 *
 *  @param timelineID timelineId
 */
- (void)deleteTimelineWithId:(NSInteger)timelineId;

/**
 *  更新记录
 *
 *  @param history    更新model
 */
- (void)updateTimeline:(BTTimelineModel *)history;

@end
