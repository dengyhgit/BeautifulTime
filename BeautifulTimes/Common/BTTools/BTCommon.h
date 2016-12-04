//
//  BTCommon.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef BTCommon_h
#define BTCommon_h

static NSString * const st_receiveUnknowMessageDes = @"收到新消息类型无法解析的数据，请升级查看";
static NSString * const st_receiveErrorMessageDes = @"接收消息错误";

#define kNavigationBarColor    UIColorFromRGB(0x3f80de)
#define upLoadImgWidth            720

#define firstLaunch              @"firstLaunch"
#define currentCity              @"btCurrentCity"
#define currentCountry           @"btCurrentCountry"
#define userID                   @"btUserID"
#define userPassword             @"btPassword"
#define isLogin                  @"kIsLogin"

// 弱引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

#define BT_UIIMAGE(_FILE_)          ([UIImage imageNamed:(_FILE_)])
#define BT_LOADIMAGE(_FILE_)        ([[BTThemeManager getInstance]loadImageInDefaultThemeWithName:(_FILE_)])

#define     IOS7_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define     IOS8_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
#define     IOS8_3_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.3f)
#define     IOS9_0_OR_HIGHER       ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f)

//发送消息的通知名
#define SendMsgName @"sendMessage"
#define SendFileMsgName @"sendFileMessage"

//删除好友时发出的通知名
#define DeleteFriend @"deleteFriend"

#define kUpdateJournalInfo @"kUpdateJournalInfo"

//发送表情的按钮
#define FaceSendButton @"faceSendButton"

//收到好友申请通知名
#define AddFriendRequst @"kAddFriendRequst"

//更新好友列表通知名
#define UpdateContacterList @"kUpdateContacterList"

#define DownloadFileFinish  @"DownloadFileFinish"

#define JMSSAGE_APPKEY @"5855962950f6cd9eb62da7b8"
#define CHANNEL @""
#define kFriendInvitationNotification @"friendInvitationNotification"

#define BTMAINTHREAD(block) dispatch_async(dispatch_get_main_queue(), block)

/** 表情相关 */
// 表情的最大行数
#define HMEmotionMaxRows 3
// 表情的最大列数
#define HMEmotionMaxCols 7
// 每页最多显示多少个表情
#define HMEmotionMaxCountPerPage (HMEmotionMaxRows * HMEmotionMaxCols - 1)

// 表情选中的通知
#define HMEmotionDidSelectedNotification @"HMEmotionDidSelectedNotification"
// 点击删除按钮的通知
#define HMEmotionDidDeletedNotification @"HMEmotionDidDeletedNotification"
// 通知里面取出表情用的key
#define HMSelectedEmotion @"HMSelectedEmotion"

#define kMessageChangeState  @"messageChangeState"
#define kCreatGroupState  @"creatGroupState"
#define kSkipToSingleChatViewState  @"SkipToSingleChatViewState"
#define kDeleteAllMessage  @"deleteAllMessage"
#define kConversationChange @"ConversationChange"

#define RGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define RGBColorAlpha(r,g,b,alp) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(alp)]

#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:0.7]

// 状态栏高度
#define     BT_STATUSBAR_HEIGHT  0
// 屏幕的高度
#define     BT_SCREEN_HEIGHT     (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.height:[UIScreen mainScreen].bounds.size.height)
// 屏幕的宽度
#define     BT_SCREEN_WIDTH      (IOS8_OR_HIGHER?[UIScreen mainScreen].bounds.size.width:[UIScreen mainScreen].bounds.size.width)

#define kApplicationSize      [UIScreen mainScreen].bounds.size       //(e.g. 320,460)
#define kApplicationWidth     [UIScreen mainScreen].bounds.size.width //(e.g. 320)
#define kApplicationHeight    [UIScreen mainScreen].bounds.size.height//不包含状态bar的高度(e.g. 460)

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             170

#define kStatusBarHeight         20
#define kNavigationBarHeight     44
#define kNavigationheightForIOS7 64
#define kContentHeight           (kApplicationHeight - kNavigationBarHeight)
#define kTabBarHeight            49
#define kTableRowTitleSize       14
#define maxPopLength             170

//Notification
#define kAlertToSendImage @"AlertToSendImage"
#define kDeleteMessage @"DeleteMessage"
#define kUpdateUserAvator @"kBTUpdateUserAvator"

#define kuserName @"userName"
#define kBADGE @"badge"

//Color
#define kNavigationBarColor UIColorFromRGB(0x3f80de)
#define kTabbarColor UIColorFromRGB(0x3e3e3e)
#define kTextfieldPlaceholderColor UIColorFromRGB(0x555555)
#define kTableviewCellClickColor UIColorFromRGB(0xdddddd)
#define kTableviewSeperateLineColor UIColorFromRGB(0xcfcfcf)
#define kSeparationLineColor UIColorFromRGB(0xd0d0d0)
//NavigationBar
#define kGoBackBtnImageOffset UIEdgeInsetsMake(0, 0, 0, 15)
#define kNavigationLeftButtonRect CGRectMake(0, 0, 30, 30)

//ToolBar
static NSInteger const st_toolBarTextSize = 17.0f;

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本
#define kUIWindow    [[[UIApplication sharedApplication] delegate] window] //获得window
#define kUnderStatusBarStartY (kIOSVersions>=7.0 ? 20 : 0)                 //7.0以上stautsbar不占位置，内容视图的起始位置要往下20

#define kScreenSize           [[UIScreen mainScreen] bounds].size                 //(e.g. 320,480)
#define kScreenWidth          [[UIScreen mainScreen] bounds].size.width           //(e.g. 320)
#define kScreenHeight  (kIOSVersions>=7.0 ? [[UIScreen mainScreen] bounds].size.height + 64 : [[UIScreen mainScreen] bounds].size.height)
#define kIOS7OffHeight (kIOSVersions>=7.0 ? 64 : 0)

// View的right
#define BT_ViewRight(View)              (View.frame.origin.x + View.frame.size.width)
// View的left
#define BT_ViewLeft(View)               (View.frame.origin.x)
// View的bottom
#define BT_ViewBottom(View)             (View.frame.origin.y + View.frame.size.height)
// View的top
#define BT_ViewTop(View)                (View.frame.origin.y)
// View的width
#define BT_ViewWidth(View)              (View.frame.size.width)
// View的height
#define BT_ViewHeight(View)             (View.frame.size.height)

//判断设备是不是6Plus
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(scale)]?[[UIScreen mainScreen] scale]:1) >= 2.8

//是否为4寸屏
#define BT_4INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(320*[UIScreen mainScreen].scale, 568*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

//是否为4.7寸屏
#define BT_47INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(375*[UIScreen mainScreen].scale, 667*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

//是否为5.5寸屏
#define BT_55INCH_SCREEN          (CGSizeEqualToSize(CGSizeMake(414*[UIScreen mainScreen].scale, 736*[UIScreen mainScreen].scale),[[UIScreen mainScreen] currentMode].size))

#define BT_IOS7_OR_HIGHER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
#define BT_IOS8_OR_HIGHER        ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

// 透明色
#define BT_CLEARCOLOR            ([UIColor clearColor])

// 根据大小创建字体
#define BT_FONTSIZE(_SIZE_)      ([UIFont systemFontOfSize:_SIZE_])


#endif
