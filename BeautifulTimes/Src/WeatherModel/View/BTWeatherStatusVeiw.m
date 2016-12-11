//
//  BTWeatherStatusVeiw.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTWeatherStatusVeiw.h"
#import "UIView+BTAddition.h"

static const CGFloat iconWidth = 20;
static const CGFloat iconHeight = 20;

@interface BTWeatherStatusVeiw ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel     *cityName;    //城市名
@property (nonatomic, strong) UIImageView *weatherIcon; //天气icon
@property (nonatomic, strong) UILabel     *weatherInfo; //天气温度
@property (nonatomic, strong) UILabel     *pm25Label;   //pm2.5
@property (nonatomic, strong) UIImageView *pm25ImageView;

@end

@implementation BTWeatherStatusVeiw

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.cityName];
        [self addSubview:self.weatherIcon];
        [self addSubview:self.weatherInfo];
        [self addSubview:self.pm25ImageView];
        [self addSubview:self.pm25Label];
        
        WS(weakSelf);
        CGFloat height = frame.size.height;
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, height / 4 * 3, 0));
        }];
        [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.titleView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleView).offset(height / 4 + (height / 4 * 3 / 2 - iconHeight) / 2);
            make.left.equalTo(weakSelf).offset(3);
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconHeight));
        }];
        [self.weatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.weatherIcon);
            make.left.equalTo(weakSelf.weatherIcon).offset(iconWidth);
            make.right.equalTo(weakSelf);
            make.height.equalTo(weakSelf.weatherIcon);
        }];
        [self.pm25ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.weatherIcon).offset(iconHeight + (height / 4 * 3 / 2 - 20) / 2);
            make.left.equalTo(weakSelf).offset(3);
            make.width.equalTo(@(20));
            make.height.equalTo(@(20));
        }];
        
        [self.pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.pm25ImageView);
            make.left.equalTo(weakSelf.pm25ImageView).offset(20);
            make.right.equalTo(weakSelf);
            make.height.equalTo(weakSelf.pm25ImageView);
        }];
        [self setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
       
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
    if (_delegate && [_delegate respondsToSelector:@selector(tapWeatherStatusView)]) {
        [_delegate tapWeatherStatusView];
    }
}


- (void)bindData:(BTWeatherModel *)model {
    self.cityName.text = model.city;
    self.weatherInfo.text = [[NSString alloc] initWithFormat:@"%@~%@℃", model.maxTemperature, model.minTemperature];
    self.pm25Label.text = [[NSString alloc] initWithFormat:@"%@", [self getpm25Rate:model.pm25]];
    
    if (!model.dayWeatherIcon) {
        [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
    }
    else {
        if ([model.dayWeatherIcon rangeOfString:@"雪"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_xue")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"晴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"云"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_duoyun")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"雨"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yu")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"阴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yin")];
        }
    }
}

/*
 *计算空气质量等级
 */
- (NSString *) getpm25Rate:(NSString *) pm25String {
    if (pm25String) {
        int pm25 = [pm25String intValue];
        if (pm25 > 250) {
            return @"严重污染";
        }
        else if (pm25 > 150) {
            return @"重度污染";
        }
        else if (pm25 > 115) {
            return @"中度污染";
        }
        else if (pm25 > 75) {
            return @"轻度污染";
        }
        else if (pm25 > 35) {
            return @"良";
        }
        else if (pm25 > 0){
            return @"优";
        }
        else {
            return @"";
        }
    }
    return nil;
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_other_c"];
    }
    return _titleView;
}

- (UILabel *)cityName {
    if (!_cityName) {
        _cityName = [[UILabel alloc] init];
        _cityName.textAlignment = NSTextAlignmentCenter;
        _cityName.font = BT_FONTSIZE(14);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
            _cityName.text = [[NSUserDefaults standardUserDefaults] objectForKey:currentCity];
        }
    }
    return _cityName;
}

- (UILabel *)weatherInfo {
    if (!_weatherInfo) {
        _weatherInfo = [[UILabel alloc] init];
        _weatherInfo.textAlignment = NSTextAlignmentLeft;
        _weatherInfo.font = BT_FONTSIZE(11);
        _weatherInfo.text = @"0℃";
    }
    return _weatherInfo;
}

- (UIImageView *)weatherIcon {
    if (!_weatherIcon) {
        _weatherIcon = [[UIImageView alloc] init];
        [_weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
    }
    return _weatherIcon;
}

- (UILabel *)pm25Label {
    if (!_pm25Label) {
        _pm25Label = [[UILabel alloc] init];
        _pm25Label.textAlignment = NSTextAlignmentLeft;
        _pm25Label.font = BT_FONTSIZE(11);
        _pm25Label.text = @"优";
    }
    return _pm25Label;
}

- (UIImageView *)pm25ImageView {
    if (!_pm25ImageView) {
        _pm25ImageView = [[UIImageView alloc] init];
        [_pm25ImageView setImage:BT_LOADIMAGE(@"com_ic_status_pm")];
    }
    return _pm25ImageView;
}

@end
