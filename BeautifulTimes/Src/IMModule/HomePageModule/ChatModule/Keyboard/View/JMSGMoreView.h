//
//  JMSGMoreView.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddBtnDelegate <NSObject>
@optional

- (void)photoClick;
- (void)cameraClick;
- (void)fileClick;
- (void)locationClick;

@end

@interface JMSGMoreView : UIView

@property (weak, nonatomic) IBOutlet UIButton *photoBtn;
@property (weak, nonatomic) IBOutlet UIButton *cameraBtn;
@property (weak, nonatomic) IBOutlet UIButton *fileBtn;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (assign, nonatomic)  id<AddBtnDelegate>delegate;

@end


@interface JMSGMoreViewContainer : UIView

@property (strong, nonatomic) JMSGMoreView *moreView;

@end