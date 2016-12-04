//
//  BTCircularProgressButton.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/9/7.
//  Copyright (c) 2015年 YangYubin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCircularProgressButton : UIButton

@property (nonatomic) UIColor *progressColor;
@property (nonatomic) CGFloat lineWidth;

- (id)initWithFrame:(CGRect)frame
      progressColor:(UIColor *)progressColor
          lineWidth:(CGFloat)lineWidth;

- (void)setProgress:(float)currentTime duration:(float)duration;

@end
