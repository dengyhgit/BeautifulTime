//
//  BTAlbumCollectionViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/17.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAlbumCollectionViewCell.h"
#import <Photos/Photos.h>

static CGFloat const iconWidth = 120.0f;
static CGFloat const iconHeight = 120.0f;
static CGFloat const labelHeight = 20.0f;

@interface BTAlbumCollectionViewCell ()

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BTAlbumCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.title];
        
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconHeight));
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.imageView);
            make.top.equalTo(weakSelf.imageView).with.offset(iconHeight + 8);
            make.bottom.equalTo(weakSelf.contentView).with.offset(-16);
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(labelHeight));
        }];
    }
    return self;
}

#pragma mark - CLThemeListenerProtocol
- (void)CLThemeDidNeedUpdateStyle
{
    self.title.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_a5_content"];
}

- (void)bindData:(NSString *)titleText icon:(UIImage *)icon {

    self.title.text = titleText;
    
    self.imageView.image = icon;
}

- (void)bindDataAsset:(PHAsset *)asset title:(NSString *)titleText {
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    WS(weakSelf);
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(200, 200)
                           contentMode:PHImageContentModeAspectFill
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             weakSelf.imageView.image = result;
                             
                         }];

}


- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"test data";
        _title.font = BT_FONTSIZE(14);
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
