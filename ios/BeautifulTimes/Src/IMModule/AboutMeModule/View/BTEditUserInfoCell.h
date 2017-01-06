//
//  BTEditUserInfoCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTextField.h"

@interface BTEditUserInfoCell : UITableViewCell

@property (nonatomic,weak) BTTextField *input;
@property (nonatomic,copy) NSString *str;

@end
