//
//  BTIMEditUserInfoViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTIMEditUserInfoViewController;

@protocol BTEditUserInfoViewDelegate <NSObject>

@optional

-(void)EditingFinshed:(BTIMEditUserInfoViewController *)edit indexPath:(NSIndexPath *)indexPath newInfo:(NSString *)newInfo;

@end

@interface BTIMEditUserInfoViewController : UITableViewController

@property (nonatomic,copy) NSString *str;
@property (nonatomic,strong) NSIndexPath* indexPath;
@property (nonatomic,weak) id<BTEditUserInfoViewDelegate>delegate;

@end