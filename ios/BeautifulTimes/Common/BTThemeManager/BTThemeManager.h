//
//  BTThemeManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    BTThemeType_BT_BLUE = 1,
    BTThemeType_BT_BLACK = 2,
    BTThemeType_TEST = 3, //for themetest页面
    BTThemeType_ONLINE = 4, //for 在线皮肤
}BTThemeType;



#define BT_Theme_Color(_COLORKEY_)          ([[BTThemeManager getInstance] BTThemeColor:(_COLORKEY_)])


@protocol BTThemeListenerProtocol <NSObject>

- (void) BTThemeDidNeedUpdateStyle;

@end


@interface BTThemeManager : NSObject

@property (nonatomic, assign) BTThemeType themeStyle;


+ (BTThemeManager *) getInstance;

/*
 * 设置主题风格 for default theme
 */
- (void) setThemeStyle:(BTThemeType) themeStyle;

/*
 *  设置主题风格 for online theme
 * @param themeStyle 主题类型
 * @param themeName  主题包名字
 */
- (void)setThemeStyle:(BTThemeType)themeStyle withThemeName:(NSString *) themeName ;
/*
 * 注册监听
 */
- (void) addThemeListener:(id) obj;
/*
 *移除监听
 */
- (void) removeThemeListener:(id) obj;


/*1.图片资源*/
- (void )BTThemeImage:(NSString *)imagePath completionHandler:(void (^)(UIImage *image))handler;

/*2.颜色资源*/
- (UIColor *) BTThemeColor:(NSString *)colorKey;

/*3.字体*/
/*
 * @param dic 传入bundle字典，包含bundle名与bundle的path，用于themetest页面
 */
- (void) setThemeWithBundleInfo:(NSDictionary *) dic;


/*
 * 获取BeautifulTimesSkins文件夹的路径
 */
- (NSString *) getBeautifulTimesSkinsDocPath;

/*
 * 在默认(黑色)皮肤中加载一张图片
 */

- (UIImage *) loadImageInDefaultThemeWithName:(NSString *) imageName;

- (UIImage *) loadImageInBlueThemeWithName:(NSString *) imageName;

@end
