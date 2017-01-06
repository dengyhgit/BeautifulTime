//
//  BTTimelineDB.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDB.h"
#import "FMDB.h"

@interface BTTimelineDB ()

@property (nonatomic, strong) FMDatabaseQueue * queue;

@end

static BTTimelineDB * timelineDB = nil;

@implementation BTTimelineDB

+ (BTTimelineDB *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timelineDB = [[BTTimelineDB alloc] init];
    });
    return timelineDB;
}

- (BTTimelineDB *) init
{
    if (self = [super init]) {
        [self createHistoryDB];
    }
    return self;
}

- (NSString *)getDBPath {

    NSString *path = [BTTool getDocumentDirectory];
    NSString *userSavePath = [NSString stringWithFormat:@"BTCaches/BTTimeline"];
    path = [path stringByAppendingPathComponent:userSavePath];
    if ([BTTool createDirectory:path]) {
        if ([BTTool createDirectory:path]) {
            path = [path stringByAppendingPathComponent:@"bttimeline.db"];
            return path;
        }
        else {
            NSLog(@"path: %@ not exist", path);
        }
    }
    else {
        NSLog(@"path: %@ not exist", path);
    }
    return nil;
}

- (void) createHistoryDB {
    
    NSString * path = [self getDBPath];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[path stringByAppendingPathComponent:@"bttimeline.db"]]) {
        return;
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
        //创建表
        BOOL createTableResult = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS bttimeline (timelineId INTEGER PRIMARY KEY AUTOINCREMENT, timelineContent data, timelineDate date, weather data, site text, photos text, record text, friends text, thumbImage text)"];
        if (createTableResult) {
//            NSLog(@"创建记录表成功");
        } else {
//            NSLog(@"创建记录表失败");
        }
    }];
}

- (void)addHistory:(BTTimelineModel *)message {
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"insert into bttimeline (timelineContent, timelineDate, weather, site, photos, record, friends, thumbImage) values (?, ?, ?, ?, ?, ?, ?, ?)";
        [db executeUpdate:sql, message.timelineContent, message.timelineDate, message.weather, message.site, message.photos, message.record, message.friends, message.thumbImage];
    }];
}

- (BTTimelineModel *) getTimelineByID:(NSInteger)timelineID{
    __block BTTimelineModel * history = nil;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM bttimeline WHERE timelineId = ?",[NSNumber numberWithInteger:timelineID]];
        while ([rs next]) {
            history = [self rsToModel:rs];
            break;
        }
        [rs close];
    }];
    
    return history;
}


- (void)updateHistory:(BTTimelineModel *)history{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"UPDATE bttimeline SET timelineContent = ?, timelineDate = ?, weather = ?, site = ?, photos = ?, record = ?, friends = ?, thumbImage = ? WHERE timelineId = ?", history.timelineContent, history.timelineDate, history.weather, history.site, history.photos, history.record, history.friends , history.thumbImage, history.timelineId];
    }];
}

- (void)deleteHistoryByTimelineID:(NSInteger)timelineID {
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bttimeline WHERE timelineId = ?",[NSNumber numberWithInteger:timelineID]];
    }];
}

/**
 *  删除所有搜索记录
 */
- (void)deleteAllHistory
{
    [self.queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"DELETE FROM bttimeline"];
    }];
}

- (NSArray *)getAllHistory
{
    __block NSMutableArray *historys = [[NSMutableArray alloc] init];
    [self.queue inDatabase:^(FMDatabase *db) {
//        NSLog(@"start to get all history");
        FMResultSet *rs = [db executeQuery:@"SELECT * FROM bttimeline"];
        while ([rs next]) {
            [historys addObject:[self rsToModel:rs]];
        }
        [rs close];
    }];
//    NSLog(@"end to get all history");
    return historys;
}

- (BTTimelineModel *)rsToModel:(FMResultSet*)rs
{
    BTTimelineModel * model = [[BTTimelineModel alloc] init];
    model.timelineId = [NSNumber numberWithInt:[rs intForColumn:@"timelineId"]];
    model.timelineContent = [rs dataForColumn:@"timelineContent"];
    model.timelineDate = [rs dateForColumn:@"timelineDate"];
    model.weather = [rs dataForColumn:@"weather"];
    model.site = [rs stringForColumn:@"site"];
    model.photos = [rs stringForColumn:@"photos"];
    model.record = [rs stringForColumn:@"record"];
    model.friends = [rs stringForColumn:@"friends"];
    model.thumbImage = [rs stringForColumn:@"thumbImage"];
    return model;
}

- (void) dealloc {
    _queue = nil;
}

@end
