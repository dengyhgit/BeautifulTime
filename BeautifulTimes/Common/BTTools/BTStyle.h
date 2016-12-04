//
//  BTStyle.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

// 定义颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface BNaviStyle : NSObject


@end

@interface UIImage (BNaviExtension)

// 从指定bundle中获取图片
+ (UIImage*)loadImage:(NSString*)imageName fromBundle:(NSBundle*)bundle;


// 依据像素值及范围得到展示图标
+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size;

@end

@interface UIColor (BNaviExtension)

//设置16进制表示的颜色
+ (UIColor*)colorWithHex:(uint)hex;

//根据RGB设置颜色
+ (void)colorWithHex:(uint)hex red:(CGFloat*)redP green:(CGFloat*)greenP blue:(CGFloat*)blueP alpha:(CGFloat*)alphaP;

@end

