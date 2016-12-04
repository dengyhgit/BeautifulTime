//
//  BTPhotoCollectionViewCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BTPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *isSelect;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, strong) UIImage *thumbnailImage;

@end
