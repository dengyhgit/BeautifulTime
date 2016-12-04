//
//  BTTabBarView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTTabBarView;
//协议
@protocol BTTabBarViewDelegate <NSObject>

@optional
-(void)tabBar:(BTTabBarView *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface BTTabBarView : UIView

-(void)addTabBarButtonItem:(UITabBarItem *)item;

@property (nonatomic,weak) id<BTTabBarViewDelegate>delegate;

@end