//
//  BTChoosePhotosItem.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/30.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTChoosePhotoDelegate <NSObject>

@required

- (void)cancelChoosePhoto;

@end

@interface BTChoosePhotosItem : UICollectionViewCell

@property (nonatomic, weak) id <BTChoosePhotoDelegate>delegate;

- (void)bindData:(UIImage *)image isShowColseButton:(BOOL)isShowColseButton;

@end
