//
//  BTAdressBookCell.h
//  BeautifulTimes
//
//  Created by deng on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTAddressBook.h"

@interface BTAdressBookCell : UITableViewCell

@property (nonatomic, strong) UIImageView *isSelect;
@property (nonatomic, strong) UILabel *name;

- (void)bindData:(BTAddressBook *)addressBook;

@end
