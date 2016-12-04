//
//  BTJournalListItem.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalListItem.h"
#import "BTCalendarView.h"
#import "UIView+BTAddition.h"
#import "BTWeatherModel.h"

@interface BTJournalListItem ()

@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) UILabel *contentLaber;
@property (nonatomic, strong) UILabel *cityName;
@property (nonatomic, strong) UILabel *weatherInfo;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel     *pm25Label;
@property (nonatomic, strong) UIImageView *pm25ImageView;
@property (nonatomic, strong) UIImageView *photoImageView;
@property (nonatomic, strong) UIImageView *recordImageView;

@end

@implementation BTJournalListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.calendarView];
        [self addSubview:self.contentLaber];
        [self addSubview:self.cityName];
        [self addSubview:self.weatherIcon];
        [self addSubview:self.weatherInfo];
        [self addSubview:self.pm25Label];
        [self addSubview:self.pm25ImageView];
        [self addSubview:self.photoImageView];
        [self addSubview:self.recordImageView];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        WS(weakSelf);
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(5);
            make.top.equalTo(weakSelf).offset(5);
            make.width.equalTo(@(70));
            make.height.equalTo(@(70));
        }];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(5);
            make.right.equalTo(weakSelf).offset(-5);
            make.width.equalTo(@(50));
            make.height.equalTo(@(70));
        }];
        [self.contentLaber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(5);
            make.left.equalTo(weakSelf.calendarView).offset(70 + 5);
            make.right.equalTo(weakSelf.photoImageView).offset(- (70 + 5));
            make.height.equalTo(@(40));
        }];
        [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.contentLaber).offset(40 + 10);
            make.left.equalTo(weakSelf.contentLaber);
            make.height.equalTo(@(20));
            make.width.equalTo(@(30));
        }];
        [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.cityName);
            make.left.equalTo(weakSelf.cityName).offset(30 + 5);
            make.height.equalTo(@(20));
            make.width.equalTo(@(20));
        }];
        [self.weatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.pm25ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.recordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.cityName);
            make.left.equalTo(weakSelf.weatherIcon).offset(20 + 5);
            make.height.equalTo(@(20));
            make.width.equalTo(@(20));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindDate:(Journal *)model {
    self.cityName.text = model.site;
    [self.calendarView bindData:model.journalDate];
    self.contentLaber.text = [[NSString alloc] initWithData:model.journalContent encoding:NSUTF8StringEncoding];
    NSString *documentDirectory = [BTTool getDocumentDirectory];
//    NSString *photosPath = [documentDirectory stringByAppendingPathComponent:model.photos];
//    NSData *photosData = [[NSData alloc] initWithContentsOfFile:photosPath];
//    
//    NSArray *photoArray = [NSKeyedUnarchiver unarchiveObjectWithData:photosData];
//    if (photoArray.count > 0) {
//        UIImage *image = photoArray[0];
//        UIImage *img = [[UIImage alloc] initWithData:UIImageJPEGRepresentation(image, 0.3)];
//        self.photoImageView.image = img;
//    }
    if (model.avator) {
        NSString *photosPath = [documentDirectory stringByAppendingPathComponent:model.avator];
        NSData *photosData = [[NSData alloc] initWithContentsOfFile:photosPath];
        UIImage *image = [[UIImage alloc] initWithData:photosData];
        self.photoImageView.image = image;
    }
    
    BTWeatherModel *weather = [NSKeyedUnarchiver unarchiveObjectWithData:model.weather];
    if (!weather.dayWeatherIcon) {
        [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
    }
    else {
        if ([weather.dayWeatherIcon rangeOfString:@"雪"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_xue")];
        }
        else if ([weather.dayWeatherIcon rangeOfString:@"晴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
        }
        else if ([weather.dayWeatherIcon rangeOfString:@"云"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_duoyun")];
        }
        else if ([weather.dayWeatherIcon rangeOfString:@"雨"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yu")];
        }
        else if ([weather.dayWeatherIcon rangeOfString:@"阴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yin")];
        }
    }
}

- (BTCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[BTCalendarView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        _calendarView.userInteractionEnabled = NO;
    }
    return _calendarView;
}

- (UILabel *)contentLaber {
    if (!_contentLaber) {
        _contentLaber = [[UILabel alloc] init];
        _contentLaber.font = BT_FONTSIZE(16);
        _contentLaber.lineBreakMode = NSLineBreakByWordWrapping;
        _contentLaber.numberOfLines = 2;
    }
    return _contentLaber;
}

- (UILabel *)cityName {
    if (!_cityName) {
        _cityName = [[UILabel alloc] init];
        _cityName.textAlignment = NSTextAlignmentCenter;
        _cityName.font = BT_FONTSIZE(10);
    }
    return _cityName;
}

- (UILabel *)weatherInfo {
    if (!_weatherInfo) {
        _weatherInfo = [[UILabel alloc] init];
    }
    return _weatherInfo;
}

- (UIImageView *)weatherIcon {
    if (!_weatherIcon) {
        _weatherIcon = [[UIImageView alloc] init];
    }
    return _weatherIcon;
}

- (UILabel *)pm25Label {
    if (!_pm25Label) {
        _pm25Label = [[UILabel alloc] init];
    }
    return _pm25Label;
}

- (UIImageView *)pm25ImageView {
    if (!_pm25ImageView) {
        _pm25ImageView = [[UIImageView alloc] init];
    }
    return _pm25ImageView;
}

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
        _photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _photoImageView;
}

- (UIImageView *)recordImageView {
    if (!_recordImageView) {
        _recordImageView = [[UIImageView alloc] init];
    }
    return _recordImageView;
}


@end
