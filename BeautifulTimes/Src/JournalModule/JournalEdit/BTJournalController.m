//
//  BTJournalController.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalController.h"

static BTJournalController *journalController;

@interface BTJournalController() <BTJournalControllerDelegate>

@end

@implementation BTJournalController

@synthesize photos = _photos;
@synthesize currentDate = _currentDate;
@synthesize record = _record;
@synthesize contacter = _contacter;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        journalController = [[BTJournalController alloc] init];
    });
    
    return journalController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)resetAllParameters {
    self.photos = nil;
    self.currentDate = nil;
    self.record = nil;
    self.contacter = nil;
}

- (NSArray *)photos {
    if (!_photos) {
        _photos = [[NSArray alloc] init];
    }
    return _photos;
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [[NSDate alloc] init];
    }
    return _currentDate;
}

- (NSString *)record {
    if (!_record) {
        _record = [[NSString alloc] init];
    }
    return _record;
}

- (NSString *)contacter {
    if (!_contacter) {
        _contacter = [[NSString alloc] init];
    }
    return _contacter;
}

@end
