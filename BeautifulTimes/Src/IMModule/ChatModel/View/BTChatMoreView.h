//
//  BTChatMoreView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/4/1.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddBtnDelegate <NSObject>
@optional
- (void)photoClick;
- (void)cameraClick;
@end
@interface BTChatMoreView : UIView
@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (assign, nonatomic)  id<AddBtnDelegate>delegate;

@end


@interface JCHATMoreViewContainer : UIView
@property (strong, nonatomic) BTChatMoreView *moreView;

@end