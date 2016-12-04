//
//  JMSGChatViewController.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGToolBar.h"
#import "JMSGMoreView.h"
#import "JMSGRecordAnimationView.h"
#import "JMSGChatModel.h"
#import "XHVoiceRecordHUD.h"
#import "XHVoiceRecordHelper.h"
#import "JMSGMessageTableView.h"
#import "JMSGMessageTableViewCell.h"
#import "JCHATPhotoPickerViewController.h"

#define interval 60 * 2
#define navigationRightButtonRect CGRectMake(0, 0, 14, 17)

static NSInteger const messagePageNumber = 25;
static NSInteger const messagefristPageNumber = 20;

@interface JMSGChatViewController : UIViewController <
UITableViewDataSource,
UITableViewDelegate,
SendMessageDelegate,
AddBtnDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
PictureDelegate,
playVoiceDelegate,
UIGestureRecognizerDelegate,
UIAlertViewDelegate,
JMessageDelegate,
UIScrollViewDelegate,
JCHATPhotoPickerViewControllerDelegate,
UITextViewDelegate,
UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet JMSGMessageTableView *messageTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarHeightConstrait;
@property (weak, nonatomic) IBOutlet JCHATToolBarContainer *toolBarContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toolBarToBottomConstrait;
@property (weak, nonatomic) IBOutlet JMSGMoreViewContainer *moreViewContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreViewHeight;
@property(nonatomic, assign) JPIMInputViewType textViewInputViewType;
@property(assign, nonatomic) BOOL barBottomFlag;
@property(nonatomic, strong, readwrite) XHVoiceRecordHUD *voiceRecordHUD;
@property(strong, nonatomic) JMSGConversation *conversation;
@property(strong, nonatomic) NSString *targetName;
@property(assign, nonatomic) BOOL isConversationChange;
@property(weak,nonatomic)id superViewController;

/**
 *  管理录音工具对象
 */
@property(nonatomic, strong) XHVoiceRecordHelper *voiceRecordHelper;

- (void)setupView;
- (void)prepareImageMessage:(UIImage *)img;

@end
