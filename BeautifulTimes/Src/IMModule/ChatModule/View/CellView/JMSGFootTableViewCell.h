//
//  JMSGFootTableViewCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGGroupDetailViewController.h"

typedef void (^DidSelectNoDisturbBlock)(BOOL isNoDisturb);

@interface JMSGFootTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *footerTittle;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *quitGroupBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;
@property (strong, nonatomic)JMSGGroupDetailViewController *delegate;
@property (strong, nonatomic)UIView *baseLine;
@property (weak, nonatomic) IBOutlet UIView *NoDisturbView;
@property (weak, nonatomic) IBOutlet UILabel *NoDisturbViewTitleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *nodisturbSwitch;
- (IBAction)didSelectNoDisturbAction:(UISwitch *)sender;

- (void)setDataWithGroupName:(NSString *)groupName;
- (void)layoutToClearChatRecord;
- (void)layoutToQuitGroup;
- (void)layoutNoDisturbView;


@property (nonatomic, copy) DidSelectNoDisturbBlock didSelectNoDisturbBlock;

@end