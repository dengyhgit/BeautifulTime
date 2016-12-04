//
//  BTTimelineModel.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTimelineModel : NSObject

@property (nullable, nonatomic, retain) NSNumber *timelineId;
@property (nullable, nonatomic, retain) NSData *timelineContent;
@property (nullable, nonatomic, retain) NSDate *timelineDate;
@property (nullable, nonatomic, retain) NSData *weather;
@property (nullable, nonatomic, retain) NSString *site;
@property (nullable, nonatomic, retain) NSString *photos;
@property (nullable, nonatomic, retain) NSString *record;
@property (nullable, nonatomic, retain) NSString *friends;
@property (nullable, nonatomic, retain) NSString *thumbImage;

@end
