//
//  BTThemeManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTThemeManager.h"
#import "BTStyle.h"
#import "KFObjectExtension.h"


#define BTThemeChangeNotification @"BTThemeChangeNotification"

static BTThemeManager * _themeManager = nil;

@interface BTThemeManager () {
    NSDictionary *_themeColors;
}

@property (nonatomic, strong) NSDictionary *themeColors;
@property (nonatomic, strong) NSBundle     *themeBundle;

@end

@implementation BTThemeManager

@synthesize themeStyle = _themeStyle;
@synthesize themeColors = _themeColors;

+ (BTThemeManager *)getInstance
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _themeManager = [[BTThemeManager alloc]init];
    });
    
    return _themeManager;
}

- (id) init
{
    if (self = [super init]) {
        //        _listeners = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void)setThemeStyle:(BTThemeType)themeStyle
{
    if (_themeStyle == themeStyle ) {
        return;
    }
    
    _themeStyle = themeStyle;
    
    if (_themeStyle == BTThemeType_TEST) {
        return ;
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:themeStyle] forKey:@"BTThemeType"];
    
    
    NSString *bundleName = nil;
    
    if (_themeStyle == BTThemeType_BT_BLACK) {
        bundleName = @"blackTheme";
    }else if (_themeStyle == BTThemeType_BT_BLUE){
        bundleName = @"blueTheme";
    }
    
    if (bundleName == nil) {
        return;
    }
    
    NSString *themeBundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    self.themeBundle = [NSBundle bundleWithPath:themeBundlePath];
    
    NSString *path = [self.themeBundle pathForResource:@"ThemeColor" ofType:@"txt"];
    NSData *data =    [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if (error) {
        NSLog(@"load theme bundle error = %@", error);
    }
    self.themeColors = json;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BTThemeChangeNotification object:nil];
    
}

- (void)setThemeStyle:(BTThemeType)themeStyle withThemeName:(NSString *)themeName {
    
    if (_themeStyle == themeStyle ) {
        return;
    }
    
    _themeStyle = themeStyle;
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:themeStyle] forKey:@"BTThemeType"];
    
    if([themeName rangeOfString:@".zip"].location != NSNotFound) {
        themeName = [themeName substringToIndex:(themeName.length - 4)];
    }
    NSString * filePath = [NSString stringWithFormat:@"%@/%@.bundle", [self getBeautifulTimesSkinsDocPath], themeName];
    
    self.themeBundle = [NSBundle bundleWithPath:filePath];
    
    NSString *path = [self.themeBundle pathForResource:@"ThemeColor" ofType:@"txt"];
    NSData *data =    [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if (error) {
        NSLog(@"load theme bundle error = %@", error);
    }
    self.themeColors = json;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BTThemeChangeNotification object:nil];
    
}

- (void)addThemeListener:(id )obj
{
    if([obj respondsToSelector:@selector(BTThemeDidNeedUpdateStyle)]){
        [[NSNotificationCenter defaultCenter] addObserver:obj selector:@selector(BTThemeDidNeedUpdateStyle) name:BTThemeChangeNotification object:nil];
    }
    
}

- (void) removeThemeListener:(id)obj
{
    if (obj) {
        [[NSNotificationCenter defaultCenter] removeObserver:obj];
    }
}

- (void )BTThemeImage:(NSString *)imageName completionHandler:(void (^)(UIImage *image))handler;
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 耗时的操作
        NSString *imagePath = [NSString stringWithFormat:@"image/%@",imageName];
        UIImage *image = nil;
        
        image = [UIImage loadImage:imagePath fromBundle:self.themeBundle];
        
        if (image == nil && self.themeStyle != BTThemeType_BT_BLUE) {
            //当前的themeBundle没有，则到蓝色主题中寻找
            NSString *themeBundlePath = [[NSBundle mainBundle] pathForResource:@"blueTheme" ofType:@"bundle"];
            NSBundle *bluetheme = [NSBundle bundleWithPath:themeBundlePath];
            image = [UIImage loadImage:imagePath fromBundle:bluetheme];
        }
        
        if(image == nil && self.themeStyle != BTThemeType_BT_BLACK) {
            //当前的themeBundle没有，则到黑色主题中寻找
            NSString * themeBundlePath = [[NSBundle mainBundle] pathForResource:@"blackTheme" ofType:@"bundle"];
            NSBundle * blacktheme = [NSBundle bundleWithPath:themeBundlePath];
            image = [UIImage loadImage:imagePath fromBundle:blacktheme];
        }
        
        if (image == nil) {
            image = [UIImage imageNamed:imageName];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 更新界面
            handler(image);
        });
    });
}

//BT_BG_COLOR
- (UIColor *) BTThemeColor:(NSString *)colorKey
{
    /*从颜色值资源包 找到对应的色值*/
    NSString *jsonValue = [self.themeColors stringValueForKey:colorKey defaultValue:@"0xffffffff" operation:NSStringOperationTypeNone];
    if (jsonValue == nil) {
        NSLog(@"色值为空！！！ colorkey = %@", colorKey);
        return [UIColor blackColor];
    }
    
    unsigned long colorValue = strtoul([jsonValue UTF8String],0,16);
    
    return [UIColor colorWithHex:(uint)colorValue];
}

/*
 * @param dic 传入bundle字典，包含bundle名与bundle的path，
 */
- (void) setThemeWithBundleInfo:(NSDictionary *) dic {
    self.themeStyle = BTThemeType_TEST;
    
    self.themeBundle = [NSBundle bundleWithPath:[dic objectForKey:@"BundlePath"]];
    
    NSString *path = [self.themeBundle pathForResource:@"ThemeColor" ofType:@"txt"];
    NSData *data =    [NSData dataWithContentsOfFile:path];
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    if (error) {
        NSLog(@"load theme bundle error = %@", error);
    }
    self.themeColors = json;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:BTThemeChangeNotification object:nil];
    
}

/*
 * 获取BeautifulTimesSkins文件夹的路径
 */
- (NSString *) getBeautifulTimesSkinsDocPath {
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [paths firstObject];
    NSString * carlifeSkinsDoc = [NSString stringWithFormat:@"%@/%@", docPath, @"CarlifeSkins"];
    return carlifeSkinsDoc;
}

/*
 * 在默认(黑色)皮肤中加载一张图片
 */
- (UIImage *) loadImageInDefaultThemeWithName:(NSString *) imageName {
    if (!imageName) {
        NSLog(@"图片名字为空");
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"blackTheme" ofType:@"bundle"]];
    if (!bundle) {
        NSLog(@"默认主题缺失");
        return nil;
    }
    
    NSString *imagePath = [NSString stringWithFormat:@"image/%@",imageName];
    UIImage *image = nil;
    
    image = [UIImage loadImage:imagePath fromBundle:bundle];
    
    if (image == nil) {
        image = [UIImage imageNamed:imageName];
    }
    
    if (!image) {
        NSLog(@"找不到图片%@",imageName);
        return nil;
    }
    return image;
}

/*
 * 在默认(黑色)皮肤中加载一张图片
 */
- (UIImage *) loadImageInBlueThemeWithName:(NSString *) imageName {
    if (!imageName) {
        NSLog(@"图片名字为空");
        return nil;
    }
    NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"blueTheme" ofType:@"bundle"]];
    if (!bundle) {
        NSLog(@"默认主题缺失");
        return nil;
    }
    
    NSString *imagePath = [NSString stringWithFormat:@"image/%@",imageName];
    UIImage *image = nil;
    
    image = [UIImage loadImage:imagePath fromBundle:bundle];
    
    if (image == nil) {
        image = [UIImage imageNamed:imageName];
    }
    
    if (!image) {
        NSLog(@"找不到图片%@",imageName);
        return nil;
    }
    return image;
}

- (NSDictionary *)themeColors {
    if (!_themeColors) {
        _themeColors = [[NSDictionary alloc]init];
    }
    return _themeColors;
}

@end
