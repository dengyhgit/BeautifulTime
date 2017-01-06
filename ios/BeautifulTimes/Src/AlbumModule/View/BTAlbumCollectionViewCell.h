//
//  BTAlbumCollectionViewCell.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/17.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BTAlbumCollectionViewCell : UICollectionViewCell

- (void)bindData:(NSString *)titleText icon:(UIImage *)icon;

- (void)bindDataAsset:(PHAsset *)asset title:(NSString *)titleText;

@end
