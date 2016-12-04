//
//  BTContacterCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/23.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTContacterModel.h"

@interface BTContacterCell : UITableViewCell

- (void)bindData:(JMSGUser *)user;

@end
