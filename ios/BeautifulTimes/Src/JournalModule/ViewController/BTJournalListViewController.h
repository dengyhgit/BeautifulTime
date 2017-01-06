//
//  BTJournalListViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTJournalListViewController : BTBaseViewController

@property (nonatomic, strong) UITableView *tableView;

- (void)initDataSource;

@end
