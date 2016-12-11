//
//  BTWeatherStatusVeiw.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWeatherModel.h"

@protocol BTWeatherStatusViewDelegate;

@interface BTWeatherStatusVeiw : UIView

@property (nonatomic, weak) id <BTWeatherStatusViewDelegate> delegate;

- (void)bindData:(BTWeatherModel *)model;

@end

@protocol BTWeatherStatusViewDelegate <NSObject>

@optional

- (void)tapWeatherStatusView;

@end

