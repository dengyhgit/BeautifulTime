//
//  BTChatViewCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTMessageFrameModel.h"

@interface BTChatViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@property (nonatomic,strong) BTMessageFrameModel *frameModel;

@end
