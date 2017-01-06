//
//  BTEditPhotoViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/5/13.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTEditPhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface BTEditPhotoViewController ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UISlider *sepiaSlider;
@property (strong, nonatomic) UISlider *hueSlider;
@property (strong, nonatomic) UISlider *rotateSlider;

@property (strong, nonatomic) UILabel *sepiaLabel;
@property (strong, nonatomic) UILabel *hueLabel;
@property (strong, nonatomic) UILabel *rotateLabel;

@property (strong, nonatomic) CIContext *context;
@property (strong, nonatomic) CIFilter *sepiaFilter;
@property (strong, nonatomic) CIFilter *hueFilter;
@property (strong, nonatomic) CIFilter *rotateFilter;
@property (strong, nonatomic) CIImage *beginImage;

@end

@implementation BTEditPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"编辑照片";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.imageView];
    [self.bodyView addSubview:self.rotateLabel];
    [self.bodyView addSubview:self.rotateSlider];
    [self.bodyView addSubview:self.hueLabel];
    [self.bodyView addSubview:self.hueSlider];
    [self.bodyView addSubview:self.sepiaLabel];
    [self.bodyView addSubview:self.sepiaSlider];

    self.beginImage = [CIImage imageWithCGImage:self.originalImage.CGImage];
    
    // 创建基于GPU的CIContext对象
    self.context = [CIContext contextWithOptions: nil];
    
    // 创建过滤器
    self.sepiaFilter = [CIFilter filterWithName:@"CISepiaTone"];
    self.hueFilter = [CIFilter filterWithName:@"CIHueAdjust"];
    self.rotateFilter = [CIFilter filterWithName:@"CIStraightenFilter"];
    
    self.imageView.image = self.originalImage;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    WS(weakSelf);
    
    [self.rotateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.bottom.equalTo(weakSelf.bodyView).offset(-20);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    [self.rotateSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rotateLabel).offset(65);
        make.centerY.equalTo(weakSelf.rotateLabel);
        make.right.equalTo(weakSelf.bodyView).offset(-20);
        make.height.equalTo(weakSelf.rotateLabel);
    }];

    [self.hueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rotateLabel);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    [self.hueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.hueLabel).offset(65);
        make.centerY.equalTo(weakSelf.hueLabel);
        make.right.equalTo(weakSelf.bodyView).offset(-20);
        make.height.equalTo(weakSelf.hueLabel);
    }];
    
    [self.sepiaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.rotateLabel);
        make.bottom.equalTo(weakSelf.bodyView).offset(-100);
        make.width.equalTo(@(40));
        make.height.equalTo(@(20));
    }];
    [self.sepiaSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.sepiaLabel).offset(65);
        make.centerY.equalTo(weakSelf.sepiaLabel);
        make.right.equalTo(weakSelf.bodyView).offset(-20);
        make.height.equalTo(weakSelf.sepiaLabel);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    [self savePhoto];
    [self backButtonClick];
}

- (void)changeValue {
    UIImage *image = [self changeValue1:self.beginImage];
    image = [self changeValue2:[CIImage imageWithCGImage:image.CGImage]];
    image = [self changeValue3:[CIImage imageWithCGImage:image.CGImage]];
    self.imageView.image = image;
}

- (UIImage *)changeValue1:(CIImage *)image {
    float sepiaSliderValue = self.sepiaSlider.value;
    // 设置过滤器参数
    [self.sepiaFilter setValue:image forKey:kCIInputImageKey];
    [self.sepiaFilter setValue:[NSNumber numberWithFloat:sepiaSliderValue] forKey:@"inputIntensity"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [self.sepiaFilter outputImage];
    
    // 转换图片
    CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    // 释放C对象
    CGImageRelease(cgimg);
    return newImg;
}

- (UIImage *)changeValue2:(CIImage *)image {
    float slideValue = self.hueSlider.value;
    // 设置过滤器参数
    [self.hueFilter setValue:image forKey:kCIInputImageKey];
    [self.hueFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [self.hueFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    // 释放C对象
    CGImageRelease(cgimg);
    return newImg;
}

- (UIImage *)changeValue3:(CIImage *)image {
    
    float slideValue = self.rotateSlider.value;
    // 设置过滤器参数
    [self.rotateFilter setValue:image forKey:kCIInputImageKey];
    [self.rotateFilter setValue:[NSNumber numberWithFloat:slideValue] forKey:@"inputAngle"];
    
    // 得到过滤后的图片
    CIImage *outputImage = [self.rotateFilter outputImage];
    // 转换图片
    CGImageRef cgimg = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    // 释放C对象
    CGImageRelease(cgimg);
    return newImg;
}

- (void)savePhoto {
    CIImage *saveToSave = [CIImage imageWithCGImage:self.imageView.image.CGImage];
    CGImageRef cgImg = [self.context createCGImage:saveToSave fromRect:[saveToSave extent]];
    
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImg
                                 metadata:[saveToSave properties]
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              CGImageRelease(cgImg);
                          }];
}

- (void)resetImage:(id)sender {
    self.beginImage = [CIImage imageWithCGImage:self.originalImage.CGImage];
    self.sepiaSlider.value = 0.0;
    self.hueSlider.value = 0.0;
    self.rotateSlider.value = 0.0;
    self.imageView.image = self.originalImage;
}

#pragma mark setter 
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = self.bodyView.frame;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UISlider *)sepiaSlider {
    if (!_sepiaSlider) {
        _sepiaSlider = [[UISlider alloc] init];
        _sepiaSlider.value = 0.0;
        [_sepiaSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
    }
    return _sepiaSlider;
}

- (UISlider *)hueSlider {
    if (!_hueSlider) {
        _hueSlider = [[UISlider alloc] init];
        _hueSlider.minimumValue = -3.14;
        _hueSlider.maximumValue = 3.14;
        _hueSlider.value = 0.0;
        [_hueSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
    }
    return _hueSlider;
}

- (UISlider *)rotateSlider {
    if (!_rotateSlider) {
        _rotateSlider = [[UISlider alloc] init];
        _rotateSlider.minimumValue = -3.14;
        _rotateSlider.maximumValue = 3.14;
        _rotateSlider.value = 0.0;
        [_rotateSlider addTarget:self action:@selector(changeValue) forControlEvents:UIControlEventValueChanged];
    }
    return _rotateSlider;
}

- (UILabel *)sepiaLabel {
    if (!_sepiaLabel) {
        _sepiaLabel = [[UILabel alloc] init];
        _sepiaLabel.text = @"怀旧";
    }
    return _sepiaLabel;
}

- (UILabel *)hueLabel {
    if (!_hueLabel) {
        _hueLabel = [[UILabel alloc] init];
        _hueLabel.text = @"颜色";
    }
    return _hueLabel;
}

- (UILabel *)rotateLabel {
    if (!_rotateLabel) {
        _rotateLabel = [[UILabel alloc] init];
        _rotateLabel.text = @"旋转";
    }
    return _rotateLabel;
}

@end
