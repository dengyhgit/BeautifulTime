//
//  BTSendTextView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HMEmotion;

@interface BTSendTextView : UITextView

/**
 *  拼接表情
 */
- (void)appendEmotion:(HMEmotion *)emotion;

/**
 *  具体的文字内容
 */
- (NSString *)messageText;

@end
