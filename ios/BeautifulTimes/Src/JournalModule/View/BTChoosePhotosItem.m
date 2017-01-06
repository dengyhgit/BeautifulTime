//
//  BTChoosePhotosItem.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/30.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTChoosePhotosItem.h"
#import "BTJournalController.h"

static CGFloat const BUTTONWIDTH = 20.0f;
static CGFloat const OFFSET = 15.0f;
static int const ITEMNUM = 3;

@interface BTChoosePhotosItem ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *colseButton;

@end

@implementation BTChoosePhotosItem

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.colseButton];
        
        CGFloat itemWidth = (BT_SCREEN_WIDTH - OFFSET * (ITEMNUM + 2)) / ITEMNUM;
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(OFFSET);
            make.left.equalTo(weakSelf);
            make.width.equalTo(@(itemWidth));
            make.height.equalTo(@(itemWidth));
        }];
        [self.colseButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.imageView);
            make.right.equalTo(weakSelf.imageView);
            make.width.equalTo(@(BUTTONWIDTH));
            make.height.equalTo(@(BUTTONWIDTH));
        }];
    }
    return self;
}

- (void)colseButtonClick {
    self.imageView.image = nil;
    NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:[BTJournalController sharedInstance].photos];
    if (ary.count > self.tag) {
        [ary removeObjectAtIndex:self.tag];
        [BTJournalController sharedInstance].photos = nil;
        [BTJournalController sharedInstance].photos = ary;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(cancelChoosePhoto)]) {
        [_delegate cancelChoosePhoto];
    }
}

- (void)bindData:(UIImage *)image isShowColseButton:(BOOL)isShowColseButton {
    self.imageView.image = image;
    self.colseButton.hidden = !isShowColseButton;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (UIButton *)colseButton {
    if (!_colseButton) {
        _colseButton = [[UIButton alloc] init];
        [_colseButton setBackgroundImage:BT_LOADIMAGE(@"com_ic_red_close") forState:UIControlStateNormal];
        [_colseButton addTarget:self action:@selector(colseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colseButton;
}


@end
