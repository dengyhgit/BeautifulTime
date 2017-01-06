//
//  BTEditJournalViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"

@interface BTEditJournalViewController : BTBaseViewController

@property (nonatomic, strong) Journal *journal;
@property (nonatomic, strong) UIImageView *photos;

@end
