//
//  BTVersionInfoViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/11/24.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTVersionInfoViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>

@interface BTVersionInfoViewController ()

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;

@end

@implementation BTVersionInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
//    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.adUnitID = [BTTool getAdMobBannerId];
    self.bannerView.rootViewController = self;
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[ @"dc6430e4968505b74984f450d2e414e9" ];
    [self.bannerView loadRequest:request];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        [self setupNavButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)setupNavButton {
    UIButton *rightBtn=[[UIButton alloc]init];
    rightBtn.frame=CGRectMake(0, 0, 40, 30);
    [rightBtn setTitle:@"分享" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    rightBtn.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, -10);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    rightBtn.titleLabel.font = BT_FONTSIZE(14);
    [rightBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
}

- (void)share {
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"最美时光-分享点滴生活" descr:@"" thumImage:[UIImage imageNamed:@"App_Icon.png"]];
        
        shareObject.webpageUrl = @"https://appsto.re/cn/V85Bgb.i";
        messageObject.shareObject = shareObject;
        
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                // 分享失败回调
            }else{
                // 分享成功回调
            }
        }];
    }];
}

@end
