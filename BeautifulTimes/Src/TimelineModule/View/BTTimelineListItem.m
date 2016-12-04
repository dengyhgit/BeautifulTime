//
//  BTTimelineListItemTableViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineListItem.h"

@interface BTTimelineListItem ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *friendsLabel;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) UILabel *separatorLine;

@property (nonatomic, strong) UIImageView *timelinePhoto;

@end

@implementation BTTimelineListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.timelinePhoto];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.separatorLine];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.siteLabel];
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.playButton];
        [self.contentView addSubview:self.friendsLabel];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    WS(weakSelf);
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.contentView).offset(10);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.equalTo(@(60));
        make.height.equalTo(@(60));
    }];
    
    [self.timelinePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.contentView).offset(-10);
        make.centerY.equalTo(weakSelf.contentView);
        make.width.equalTo(@(65));
        make.height.equalTo(@(65));
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.contentView);
        make.right.equalTo(weakSelf.contentView).offset(-2);
        make.left.equalTo(weakSelf.photoView).offset(60);
        make.height.equalTo(@(0.5));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.photoView);
        make.top.equalTo(weakSelf.contentView);
        make.bottom.equalTo(weakSelf.contentView);
        make.width.equalTo(@(2));
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.photoView).offset(60);
        make.top.equalTo(weakSelf.contentView).offset(3);
        make.height.equalTo(@(40));
        make.right.equalTo(weakSelf.timelinePhoto).offset(-67);
    }];
    
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.contentLabel).offset(42);
        make.left.equalTo(weakSelf.contentLabel);
        make.right.equalTo(weakSelf.contentLabel);
        make.height.equalTo(@(30));
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.friendsLabel).offset(35);
        make.left.equalTo(weakSelf.friendsLabel);
        make.width.equalTo(@(80));
        make.height.equalTo(@(15));
    }];
    
    [self.siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.friendsLabel).offset(35);
        make.left.equalTo(weakSelf.dateLabel).offset(85);
        make.right.equalTo(weakSelf.friendsLabel);
        make.height.equalTo(@(15));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindDate:(BTTimelineModel *)model {
    self.contentLabel.text = [[NSString alloc] initWithData:model.timelineContent encoding:NSUTF8StringEncoding];
    self.photoView.image = BT_LOADIMAGE(@"com_timeline");
    if (model.friends && ![model.friends isEqualToString:@""]) {
        self.friendsLabel.text = [NSString stringWithFormat:@"我和：%@", model.friends];
    } else {
        self.friendsLabel.text = @"独自一人";
    }
    
    NSString *documentDirectory = [BTTool getDocumentDirectory];
    NSString *imagePath = [documentDirectory stringByAppendingPathComponent:model.thumbImage];
    UIImage *thumbImage = [[UIImage alloc] initWithContentsOfFile:imagePath];
    self.timelinePhoto.image = thumbImage;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd日-HH时";
    self.dateLabel.text = [formatter stringFromDate:model.timelineDate];
    self.siteLabel.text = model.site;
}

#pragma mark setter
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = BT_FONTSIZE(16);
        //自动折行设置
//        _contentLabel.lineBreakMode = UILineBreakModeWordWrap;
        [_contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _contentLabel.numberOfLines = 2;
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = BT_FONTSIZE(12);
        _dateLabel.textColor = [UIColor grayColor];
    }
    return _dateLabel;
}

- (UILabel *)siteLabel {
    if (!_siteLabel) {
        _siteLabel = [[UILabel alloc] init];
        _siteLabel.font = BT_FONTSIZE(12);
        _siteLabel.textColor = [UIColor grayColor];
    }
    return _siteLabel;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
    }
    
    return _photoView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
    }
    return _playButton;
}

- (UILabel *)friendsLabel {
    if (!_friendsLabel) {
        _friendsLabel = [[UILabel alloc] init];
        _friendsLabel.font = BT_FONTSIZE(13);
        _friendsLabel.textColor = [UIColor grayColor];
        //自动折行设置
//        _friendsLabel.lineBreakMode = UILineBreakModeWordWrap;
        [_friendsLabel setLineBreakMode:NSLineBreakByWordWrapping];
        _friendsLabel.numberOfLines = 2;
    }
    return _friendsLabel;
}

- (UILabel *)line {
    if (!_line) {
        _line = [[UILabel alloc] init];
        _line.backgroundColor = [UIColor grayColor];
    }
    return _line;
}

- (UILabel *)separatorLine {
    if (!_separatorLine) {
        _separatorLine = [[UILabel alloc] init];
        _separatorLine.backgroundColor = [UIColor grayColor];
    }
    return _separatorLine;
}

- (UIImageView *)timelinePhoto {
    if (!_timelinePhoto) {
        _timelinePhoto = [[UIImageView alloc] init];
    }
    return _timelinePhoto;
}

@end
