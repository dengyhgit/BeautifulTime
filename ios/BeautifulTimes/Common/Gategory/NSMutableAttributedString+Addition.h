//
//  NSMutableAttributedString+Addition.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/24.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Addition)

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;

@end
