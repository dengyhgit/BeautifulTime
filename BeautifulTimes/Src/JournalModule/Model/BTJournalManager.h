//
//  BTJournalManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/15.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTJournalManagerDelegate

- (void) journalUpdatedCallBack;

@end


@interface BTJournalManager : NSObject

@property (nonatomic, weak) id <BTJournalManagerDelegate> delegate;

+ (BTJournalManager *) shareInstance;

- (NSArray *)getAllJournalData;

@end
