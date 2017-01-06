//
//  BTTimelineToolView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/3.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineToolView.h"
#import "BTAddressBookViewController.h"

static CGFloat const toolViewHeight = 48;
static CGFloat const BUTTONWIDTH = 38;

@interface BTTimelineToolView ()

@property (nonatomic, strong) UIButton *selectPhotos;
@property (nonatomic, strong) UIButton *currentSite;
@property (nonatomic, strong) UIButton *addressBook;

@end

@implementation BTTimelineToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.width = BT_SCREEN_WIDTH;
        self.height = toolViewHeight;
        [self setupFirst];
    }
    return self;
}

#pragma mark 添加子控件
- (void)setupFirst
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];
    
    [self addSubview:self.selectPhotos];
    [self addSubview:self.currentSite];
    [self addSubview:self.addressBook];
    
    WS(weakSelf);
    
    CGFloat OFFSET = (BT_SCREEN_WIDTH - BUTTONWIDTH * 3) / 4;
    
    [self.selectPhotos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.currentSite.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.currentSite);
        make.height.equalTo(@(BUTTONWIDTH));
        make.top.equalTo(weakSelf).offset(5);
    }];
    
    [self.currentSite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.selectPhotos.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.addressBook.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.addressBook);
        make.height.equalTo(weakSelf.selectPhotos);
        make.bottom.equalTo(weakSelf.selectPhotos);
        
    }];
    
    [self.addressBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.currentSite.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.selectPhotos);
        make.height.equalTo(weakSelf.currentSite);
        make.bottom.equalTo(weakSelf.currentSite);
        
    }];
}

- (void)addressBookButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(timelineToolViewDidSelectAtAddressBook)]) {
        [_delegate timelineToolViewDidSelectAtAddressBook];
    }
}

- (void)selectPhotosButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(timelineToolViewDidSelectAtSelectPhotos)]) {
        [_delegate timelineToolViewDidSelectAtSelectPhotos];
    }
}

- (void)currentSiteButtonClick {
    if (_delegate && [_delegate respondsToSelector:@selector(timelineToolViewDidSelectAtCurrentSite)]) {
        [_delegate timelineToolViewDidSelectAtCurrentSite];
    }
}

- (UIButton *)addressBook {
    if (!_addressBook) {
        _addressBook = [[UIButton alloc] init];
        [_addressBook setImage:BT_LOADIMAGE(@"com_blue_contact") forState:UIControlStateNormal];
        [_addressBook addTarget:self action:@selector(addressBookButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBook;
}

- (UIButton *)selectPhotos {
    if (!_selectPhotos) {
        _selectPhotos = [[UIButton alloc] init];
        [_selectPhotos setImage:BT_LOADIMAGE(@"com_blue_camera") forState:UIControlStateNormal];
        [_selectPhotos addTarget:self action:@selector(selectPhotosButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectPhotos;
}


- (UIButton *)currentSite {
    if (!_currentSite) {
        _currentSite = [[UIButton alloc] init];
        [_currentSite setImage:BT_LOADIMAGE(@"com_blue_position") forState:UIControlStateNormal];
        [_currentSite addTarget:self action:@selector(currentSiteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentSite;
}

@end
