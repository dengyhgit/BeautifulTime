//
//  BTJournalListItem.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Journal.h"

@interface BTJournalListItem : UITableViewCell

- (void)bindDate:(Journal *)model;

@end
