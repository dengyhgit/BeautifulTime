//
//  BTPhotoDetailsViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/27.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BTPhotoDetailsViewController : BTBaseViewController

@property (nonatomic, strong) PHFetchResult *assets;
@property (nonatomic, assign) NSInteger index;

@end
