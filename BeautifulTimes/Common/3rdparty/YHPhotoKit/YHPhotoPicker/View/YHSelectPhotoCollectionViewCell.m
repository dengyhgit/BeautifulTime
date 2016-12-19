//
//  YHPhotoCollectionViewCell.m
//  YHPhotoKit
//
//  Created by deng on 16/11/27.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "YHSelectPhotoCollectionViewCell.h"
#import "YHSelectPhotoViewController.h"
#import <Photos/Photos.h>

@interface YHSelectPhotoCollectionViewCell()

@property (nonatomic, strong) UIImageView *thumbImage;
@property (nonatomic, strong) UIButton *seletStatusButton;
@property (nonatomic, strong) YHPhotoModel *thumbImageModel;
@property (nonatomic, strong) YHSelectPhotoViewController *selectPhotoVC;

@end

@implementation YHSelectPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:self.thumbImage];
        [self.contentView addSubview:self.seletStatusButton];
    }
    return self;
}

- (void)setDataWithModel:(YHPhotoModel *)model withDelegate:(id)delegate{
    self.selectPhotoVC = delegate;
    self.seletStatusButton.selected = model.isSelected;
    _thumbImageModel = model;
    PHAsset *asset = model.photoAsset;
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize imageSize = CGSizeMake(self.frame.size.width * scale / 2, self.frame.size.width * scale / 2);
    [model.cachingManager requestImageForAsset:asset
                                    targetSize:imageSize
                                   contentMode:PHImageContentModeAspectFill 
                                       options:nil
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     if ([_thumbImageModel.photoAsset.localIdentifier isEqualToString:asset.localIdentifier]) {
                                         self.thumbImage.image = result;
                                     }
                                 }];
}

- (void)selectedStatusChange:(id)sender {
    UIButton *selectBtn = (UIButton *)sender;
    if (self.selectPhotoVC.selectPhotosCount >= 6) {
        NSLog(@"----最多选择6张照片");
        return;
    }
    _thumbImageModel.isSelected = !_thumbImageModel.isSelected;
    selectBtn.selected = _thumbImageModel.isSelected;
    [self.selectPhotoVC didSelectStatusChange:_thumbImageModel];
}

#pragma mark setter
- (UIImageView *)thumbImage {
    if (!_thumbImage) {
        _thumbImage = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    }
    return _thumbImage;
}

- (UIButton *)seletStatusButton {
    if (!_seletStatusButton) {
        _seletStatusButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 25, 2, 23, 23)];
        [_seletStatusButton addTarget:self action:@selector(selectedStatusChange:) forControlEvents:UIControlEventTouchUpInside];
        [_seletStatusButton setBackgroundImage:[UIImage imageNamed:@"yh_image_no_picked"] forState:UIControlStateNormal];
        [_seletStatusButton setBackgroundImage:[UIImage imageNamed:@"yh_image_picked"] forState:UIControlStateSelected];
    }
    return _seletStatusButton;
}

@end
