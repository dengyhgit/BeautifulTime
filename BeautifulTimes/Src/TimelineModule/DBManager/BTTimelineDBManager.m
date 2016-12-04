//
//  BTTimelineDBManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDBManager.h"
#import "BTTimelineDB.h"

static BTTimelineDBManager * timelineDBManager = nil;

@interface BTTimelineDBManager ()
{
    BTTimelineDB *_timelineDB;
}

@end

@implementation BTTimelineDBManager

+ (BTTimelineDBManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timelineDBManager = [[BTTimelineDBManager alloc] init];
    });
    return timelineDBManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _timelineDB = [BTTimelineDB sharedInstance];
    }
    return self;
}

- (void)addTimelineMessage:(BTTimelineModel *)message {
    [_timelineDB addHistory:message];
}

- (NSArray *)getAllTimelineMessage {
    NSArray *array = [_timelineDB getAllHistory];
    return array;
}

- (BTTimelineModel *)getTimelineWithId:(NSInteger)Id {
    BTTimelineModel *timeline = [_timelineDB getTimelineByID:Id];
    return timeline;
}

- (void)deleteTimelineWithId:(NSInteger)timelineId {
    [_timelineDB deleteHistoryByTimelineID:timelineId];
}

- (void)updateTimeline:(BTTimelineModel *)history {
    [_timelineDB updateHistory:history];
}

@end
