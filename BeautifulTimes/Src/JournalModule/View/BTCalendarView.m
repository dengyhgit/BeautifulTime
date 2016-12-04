//
//  BTCalendarView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTCalendarView.h"
#import "UIView+BTAddition.h"

@interface BTCalendarView ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation BTCalendarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.monthLabel];
        [self addSubview:self.dayLabel];
        [self addSubview:self.weekLabel];
        [self addSubview:self.timeLabel];
        
        WS(weakSelf);
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, frame.size.height / 4 * 3, 0));
        }];
        [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.titleView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleView).offset(frame.size.height / 4);
            make.right.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.height.equalTo(@(frame.size.height / 2));
        }];
        [self.weekLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.dayLabel).offset(frame.size.height / 2);
            make.left.equalTo(weakSelf);
            make.right.equalTo(weakSelf).offset(-frame.size.width / 2);
            make.bottom.equalTo(weakSelf);
        }];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.dayLabel).offset(frame.size.height / 2);
            make.left.equalTo(weakSelf).offset(frame.size.width / 2);
            make.right.equalTo(weakSelf);
            make.bottom.equalTo(weakSelf);
        }];
        [self setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        self.backgroundColor = [UIColor whiteColor];
        
        [self addTapGesture];
    }
    return self;
}

#pragma mark 添加手势识别器
-(void)addTapGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewEvent)];
    tap.numberOfTapsRequired=1;
    [self addGestureRecognizer:tap];
}

- (void)tapViewEvent {
    if (_delegate && [_delegate respondsToSelector:@selector(tapCalendarView)]) {
        [_delegate tapCalendarView];
    }
}

- (void)bindData:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    self.monthLabel.text = [formatter stringFromDate:date];
    formatter.dateFormat = @"dd";
    self.dayLabel.text = [formatter stringFromDate:date];
    formatter.dateFormat = @"HH:mm";
    self.timeLabel.text = [formatter stringFromDate:date];
    self.weekLabel.text = [self getCurrentWeekDay:date];
}

- (NSString *)getCurrentWeekDay:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:(NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday |NSCalendarUnitWeekdayOrdinal) fromDate:date];
    
    NSInteger week = [comps weekday];
    switch (week) {
        case 1:
            return @"周日";
        case 2:
            return @"周一";
        case 3:
            return @"周二";
        case 4:
            return @"周三";
        case 5:
            return @"周四";
        case 6:
            return @"周五";
        case 7:
            return @"周六";
        default:
            return @"";
    }
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_other_a_bg"];
    }
    return _titleView;
}

- (UILabel *)monthLabel {
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] init];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _monthLabel;
}

- (UILabel *)dayLabel {
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] init];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.font = [UIFont boldSystemFontOfSize:30];
    }
    return _dayLabel;
}

- (UILabel *)weekLabel {
    if (!_weekLabel) {
        _weekLabel = [[UILabel alloc] init];
        _weekLabel.textAlignment = NSTextAlignmentCenter;
        _weekLabel.font = BT_FONTSIZE(12);
    }
    return _weekLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = BT_FONTSIZE(12);
    }
    return _timeLabel;
}

@end
