//
//  Journal+CoreDataProperties.h
//  BeautifulTimes
//
//  Created by deng on 15/11/2.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Journal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Journal (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *journalId;
@property (nullable, nonatomic, retain) NSData *journalContent;
@property (nullable, nonatomic, retain) NSDate *journalDate;
@property (nullable, nonatomic, retain) NSString *journalTime;
@property (nullable, nonatomic, retain) NSData *weather;
@property (nullable, nonatomic, retain) NSString *site;
@property (nullable, nonatomic, retain) NSString *photos;
@property (nullable, nonatomic, retain) NSString *records;
@property (nullable, nonatomic, retain) NSString *avator;

@end

NS_ASSUME_NONNULL_END
