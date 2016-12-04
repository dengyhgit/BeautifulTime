//
//  BTTimelineListItemTableViewCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTimelineModel.h"

@interface BTTimelineListItem : UITableViewCell

- (void)bindDate:(BTTimelineModel *)model;

@end
