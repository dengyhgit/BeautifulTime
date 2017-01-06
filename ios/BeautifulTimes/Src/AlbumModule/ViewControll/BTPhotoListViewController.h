//
//  BTPhotoListViewController.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BTPhotoListViewController : BTBaseViewController

@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, assign) BOOL isSelectModel;

@end
