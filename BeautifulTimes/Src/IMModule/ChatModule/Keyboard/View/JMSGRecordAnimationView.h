//
//  JMSGRecordAnimationView.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSGRecordAnimationView : UIView
{
    UIImageView *signalIV;
    NSTimer *animationTimer;
    UILabel *tipLabel;
    UIImageView *phoneIV;
    UIImageView *cancelIV;
}

- (void)startAnimation;
- (void)stopAnimation;
- (void)changeanimation:(double)lowPassResults;
//切换录音和取消界面 YES：显示录音 NO：显示取消
- (void)changeRecordView:(BOOL)flag;
@end
