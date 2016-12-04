//
//  BTJournalManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/15.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalManager.h"
#import "AppDelegate.h"

static BTJournalManager * journalManager = nil;

@implementation BTJournalManager

+ (BTJournalManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        journalManager = [[BTJournalManager alloc]init];
    });
    return journalManager;
}

- (BTJournalManager *)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSArray *)getAllJournalData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Journal"];
    NSArray * journalData = [[AppDelegate getInstance].coreDataHelper.context executeFetchRequest:request error:nil];
    return journalData;
}


@end
