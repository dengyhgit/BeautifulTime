//
//  BTPhotoCollectionViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoCollectionViewCell.h"

@interface BTPhotoCollectionViewCell ()

@property (nonatomic, weak) UIImageView *imageView;

@end

@implementation BTPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        _imageView = imageView;
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:self.isSelect];
    
        CGFloat iconWidth = BT_SCREEN_WIDTH / 3;
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconWidth));
        }];
        
        [self.isSelect mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf).offset(-2);
            make.top.equalTo(weakSelf).offset(2);
            make.width.equalTo(@(23));
            make.height.equalTo(@(23));
        }];
    }
    self.imageView.image = nil;
    return self;
}

#pragma mark - CLThemeListenerProtocol
- (void)CLThemeDidNeedUpdateStyle
{
    
}

- (UIImageView *)isSelect {
    if (!_isSelect) {
        _isSelect = [[UIImageView alloc] init];
        _isSelect.image = BT_LOADIMAGE(@"com_blue_image_select");
        _isSelect.hidden = YES;
    }
    return _isSelect;
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    _imageView.image = thumbnailImage;
}

@end
