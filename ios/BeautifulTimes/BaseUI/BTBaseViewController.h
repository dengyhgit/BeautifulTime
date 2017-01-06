//
//  BTBaseViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTBaseViewController : UIViewController

/**
 *  工作区
 */
@property (nonatomic, strong) UIView *bodyView;

/**
 *  头部view
 */
@property (nonatomic, strong) UIView *headerView;

/**
 *  头部的title
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, strong) UIButton *finishButton;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) CGFloat     statusHeight;

/**
 *  返回按钮点击事件
 */
- (void)backButtonClick;

- (void)finishButtonClick;

- (void) BTThemeDidNeedUpdateStyle;

@end
