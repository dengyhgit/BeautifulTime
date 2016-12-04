//
//  UIView+BTAddition.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/15.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BTAddition)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign,nonatomic) CGFloat centerX;
@property (assign,nonatomic) CGFloat centerY;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;

- (id)setBorderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

@end
