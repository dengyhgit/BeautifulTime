//
//  BTStyle.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTStyle.h"

@implementation BNaviStyle

@end

@implementation UIImage (BNaviExtension)

+ (UIImage*)loadImage:(NSString*)imageName fromBundle:(NSBundle*)bundle {
    UIImage *image = nil;
    
    //bool值判断是否加载3x图片
    BOOL bIsImageUnder3x = NO;
    
    if([imageName length] > 0 && bundle) {
        // 把imageName的名称和类型分离开
        NSArray *nameAndType = [imageName componentsSeparatedByString:@"."];
        NSString *name = [nameAndType objectAtIndex:0];
        NSString *type = nameAndType.count > 1 ? [nameAndType objectAtIndex:1] : @"png";
        
        NSString *imagePath = [bundle pathForResource:name ofType:type];
        
        //代码里写死的@2x 处理
        if (imagePath == nil && [name hasSuffix:@"@2x"] && (name.length>3)){
            name = [name substringWithRange:NSMakeRange(0,name.length-3)];
        }
        // 如果没有，尝试加上@2x来找
        if (imagePath == nil && ![name hasSuffix:@"@2x"]) {
            NSString* name2x = [name stringByAppendingString:@"@2x"];
            imagePath = [bundle pathForResource:name2x ofType:type];
            if (imagePath == nil && ![name hasSuffix:@"@3x"]) {
                NSString* name3x = [name stringByAppendingString:@"@3x"];
                imagePath = [bundle pathForResource:name3x ofType:type];
                
                bIsImageUnder3x = YES;
            }
        }
        
        if (imagePath) {
            image = [UIImage imageWithContentsOfFile:imagePath];
        }
    }
    return (BT_IOS8_OR_HIGHER||!bIsImageUnder3x)?image:[image scaledImageFrom3x];
}


+ (UIImage*)imageWithColor:(UIColor*)color size:(CGSize)size {
    // 创建上下文
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    // 创建图像大小
    CGRect fillRect = CGRectMake(0, 0, size.width, size.height);
    
    // 设置填充颜色
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    
    // 执行填充
    CGContextFillRect(currentContext, fillRect);
    
    // 获取图像
    UIImage *colorImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return colorImage;
}

/**
 *  将原本3倍尺寸的图片缩放到设备对应尺寸 因为8.3将图片全都替换为3x 该功能仅仅在ios7以下使用
 *
 *  @return 设备尺寸image
 */
- (UIImage *)scaledImageFrom3x
{
    float locScale = [UIScreen mainScreen].scale;
    
    float theRate = 1.0 / 3.0;
    UIImage *newImage = nil;
    
    CGSize oldSize = self.size;
    
    CGFloat scaledWidth = oldSize.width * theRate;
    CGFloat scaledHeight = oldSize.height * theRate;
    
    CGRect scaledRect = CGRectZero;
    scaledRect.size.width  = scaledWidth;
    scaledRect.size.height = scaledHeight;
    
    UIGraphicsBeginImageContextWithOptions(scaledRect.size, NO, locScale);
    
    [self drawInRect:scaledRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if(newImage == nil) {
//        NSLog(@"could not scale image");
    }
    return newImage;
}



@end

@implementation UIColor (BNaviExtension)

//设置16进制表示的颜色
+ (UIColor*)colorWithHex:(uint)hex {
    int red, green, blue, alpha;
    
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.f];
}


//根据RGB设置颜色
+ (void)colorWithHex:(uint)hex red:(CGFloat*)redP green:(CGFloat*)greenP blue:(CGFloat*)blueP alpha:(CGFloat*)alphaP {
    int red, green, blue, alpha;
    
    blue = hex & 0x000000FF;
    green = ((hex & 0x0000FF00) >> 8);
    red = ((hex & 0x00FF0000) >> 16);
    alpha = ((hex & 0xFF000000) >> 24);
    
    if(redP) {
        *redP = red/255.0f ;
    }
    if(greenP) {
        *greenP = green/255.0f;
    }
    if(blueP) {
        *blueP = blue/255.0f ;
    }
    if(alphaP) {
        *alphaP = alpha/255.f;
    }
}

@end
