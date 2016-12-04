//
//  BTCalendarView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTCalendarViewDelegate;

@interface BTCalendarView : UIView

@property (nonatomic, weak) id <BTCalendarViewDelegate> delegate;

- (void)bindData:(NSDate *)date;

@end

@protocol BTCalendarViewDelegate <NSObject>

@optional

- (void)tapCalendarView;

@end
