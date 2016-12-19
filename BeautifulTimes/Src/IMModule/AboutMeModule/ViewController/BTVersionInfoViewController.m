//
//  BTVersionInfoViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/11/24.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTVersionInfoViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface BTVersionInfoViewController ()

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation BTVersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
