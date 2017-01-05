//
//  JMSGChatViewController.m
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/7.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGChatViewController.h"
#import "JMSGFileManager.h"
#import "JMSGShowTimeCell.h"
#import "UIImage+ResizeMagick.h"
#import "JMSGPersonViewController.h"
#import "JMSGFriendDetailViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "JMSGLoadMessageTableViewCell.h"
#import "JMSGSendMsgManager.h"
#import "JMSGGroupDetailViewController.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotion.h"


@interface JMSGChatViewController() {
    BOOL isNoOtherMessage;
    NSInteger messageOffset;
    NSMutableArray *_imgDataArr;
    JMSGConversation *_conversation;
    NSMutableDictionary *_allMessageDic;
    NSMutableArray *_allmessageIdArr;
    NSMutableArray *_userArr;
    UIButton *_rightBtn;
    
    __block int flag;
}

@property (nonatomic, strong) HMEmotionKeyboard *keyboard;

@end

@implementation JMSGChatViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    _allMessageDic = @{}.mutableCopy;
    _allmessageIdArr = @[].mutableCopy;
    _imgDataArr = @[].mutableCopy;
    [self setupView];
    [self addNotification];
    [JMessage addDelegate:self withConversation:self.conversation];
    [self getGroupMemberListWithGetMessageFlag:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.toolBarContainer.toolbar drawRect:self.toolBarContainer.toolbar.frame];
    [_conversation refreshTargetInfoFromServer:^(id resultObject, NSError *error) {
        if (self.conversation.conversationType == kJMSGConversationTypeGroup) {
            [self updateGroupConversationTittle:nil];
        } else {
            self.title = [resultObject title];
        }
        [_messageTableView reloadData];
    }];
}

- (void)viewDidLayoutSubviews {
    [self scrollToBottomAnimated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_conversation clearUnreadCount];
    if ([[JMSGAudioPlayerHelper shareInstance] isPlaying]) {
        [[JMSGAudioPlayerHelper shareInstance] stopAudio];
    }
    [[JMSGAudioPlayerHelper shareInstance] setDelegate:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark --释放内存
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [JMessage removeDelegate:self withConversation:_conversation];
}

- (void)updateGroupConversationTittle:(JMSGGroup *)newGroup {
    JMSGGroup *group;
    if (!newGroup) {
        group = self.conversation.target;
    } else {
        group = newGroup;
    }
    if ([group.name isEqualToString:@""]) {
        self.title = @"群聊";
    } else {
        self.title = group.name;
    }
    self.title = [NSString stringWithFormat:@"%@(%lu)",self.title,(unsigned long)[group.memberArray count]];
    [self getGroupMemberListWithGetMessageFlag:NO];
    if (self.isConversationChange) {
        [self cleanMessageCache];
        [self getPageMessage];
        self.isConversationChange = NO;
    }
}

- (void)setupView {
    [self setupNavigation];
    [self setupComponentView];
}

- (void)setupComponentView {
    UITapGestureRecognizer *gesture =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [self.view addGestureRecognizer:gesture];
    _toolBarContainer.toolbar.delegate = self;
    self.toolBarContainer.toolbar.textView.text = [[JMSGSendMsgManager ins] draftStringWithConversation:_conversation];
    _messageTableView.showsVerticalScrollIndicator = NO;
    _messageTableView.delegate = self;
    _messageTableView.dataSource = self;
    _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _messageTableView.backgroundColor = RGBColor(236, 237, 240);
    
    _moreViewContainer.moreView.delegate = self;
}

- (void)tapClick:(UIGestureRecognizer *)gesture {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    [self dropToolBar];
}

- (void)setupNavigation {
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setFrame:navigationRightButtonRect];
    if (_conversation.conversationType == kJMSGConversationTypeSingle) {
        [_rightBtn setImage:[UIImage imageNamed:@"userDetail"] forState:UIControlStateNormal];
    } else {
        [self updateGroupConversationTittle:nil];
        if ([((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
            [_rightBtn setImage:[UIImage imageNamed:@"groupDetail"] forState:UIControlStateNormal];
        } else {
            _rightBtn.hidden = YES;
        }
    }
    [_rightBtn addTarget:self action:@selector(addFriends) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
}

- (void)getGroupMemberListWithGetMessageFlag:(BOOL)getMesageFlag {
    if (self.conversation && self.conversation.conversationType == kJMSGConversationTypeGroup) {
        JMSGGroup *group = self.conversation.target;
        _userArr = [NSMutableArray arrayWithArray:[group memberArray]];
        [self isContantMeWithUserArr:_userArr];
        if (getMesageFlag) {
            [self getPageMessage];
        }
    } else {
        if (getMesageFlag) {
            [self getPageMessage];
        }
        [self hidenDetailBtn:NO];
    }
}

- (void)isContantMeWithUserArr:(NSMutableArray *)userArr {
    BOOL hideFlag = YES;
    for (NSInteger i =0; i< [userArr count]; i++) {
        JMSGUser *user = [userArr objectAtIndex:i];
        if ([user.username isEqualToString:[JMSGUser myInfo].username]) {
            hideFlag = NO;
            break;
        }
    }
    [self hidenDetailBtn:hideFlag];
}

- (void)hidenDetailBtn:(BOOL)isHidden {
    [_rightBtn setHidden:isHidden];
}

#pragma mark --JMessageDelegate
- (void)onSendMessageResponse:(JMSGMessage *)message
                        error:(NSError *)error {
    [self relayoutTableCellWithMsgId:message.msgId];
    if (error != nil) {
        [_conversation clearUnreadCount];
        NSString *alert = [JMSGStringUtils errorAlert:error];
        if (alert == nil) {
            alert = [error description];
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [MBProgressHUD showMessage:alert view:self.view];
        return;
    }
}

- (void)onReceiveMessage:(JMSGMessage *)message
                   error:(NSError *)error {
    if (error) {
        JMSGChatModel *model = [[JMSGChatModel alloc] init];
        [model setErrorMessageChatModelWithError:error];
        [self addMessage:model];
        return;
    }
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    if (message.contentType == kJMSGContentTypeCustom) {
        return;
    }
    BTMAINTHREAD((^{
        if (!message) {
            return;
        }
        
        if (_allMessageDic[message.msgId]) {
            return;
        }
        
        if (message.contentType == kJMSGContentTypeEventNotification) {
            if (((JMSGEventContent *)message.content).eventType == kJMSGEventNotificationRemoveGroupMembers && ![((JMSGGroup *)_conversation.target) isMyselfGroupMember]) {
                [self setupNavigation];
            }
        }
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
            
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        
        JMSGChatModel *model = [[JMSGChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        [self addMessage:model];
    }));
}

- (void)onReceiveMessageDownloadFailed:(JMSGMessage *)message {
    if (![self.conversation isMessageForThisConversation:message]) {
        return;
    }
    
    BTMAINTHREAD((^{
        if (!message) {
            return;
        }
        
        if (_conversation.conversationType == kJMSGConversationTypeSingle) {
            
        } else if (![((JMSGGroup *)_conversation.target).gid isEqualToString:((JMSGGroup *)message.target).gid]){
            return;
        }
        JMSGChatModel *model = [[JMSGChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
        }
        model.photoIndex = [_imgDataArr count] -1;
        [self addMessage:model];
    }));
}

- (void)onGroupInfoChanged:(JMSGGroup *)group {
    [self updateGroupConversationTittle:group];
}
- (void)onReceiveNotificationEvent:(JMSGNotificationEvent *)event {
//    NSLog(@"\n\n === Notification Event === \n\n event 3 =:%@ \n\n === Notification Event === \n",@(event.eventType));
}
- (void)relayoutTableCellWithMsgId:(NSString *) messageId{
    if ([messageId isEqualToString:@""]) {
        return;
    }
    NSInteger index = [_allmessageIdArr indexOfObject:messageId];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    JMSGMessageTableViewCell *tableviewcell = [_messageTableView cellForRowAtIndexPath:indexPath];
    [tableviewcell layoutAllView];
}

#pragma mark -- 清空消息缓存
- (void)cleanMessageCache {
    [_allMessageDic removeAllObjects];
    [_allmessageIdArr removeAllObjects];
    [self.messageTableView reloadData];
}

#pragma mark --添加message
- (void)addMessage:(JMSGChatModel *)model {
    [_allMessageDic setObject:model forKey:model.message.msgId];
    [_allmessageIdArr addObject:model.message.msgId];
    [self addCellToTabel];
}

- (void)deleteMessage:(NSNotification *)notification {
    JMSGMessage *message = notification.object;
    //SDK：删除某条消息
    [_conversation deleteMessageWithMessageId:message.msgId];
    [_allMessageDic removeObjectForKey:message.msgId];
    [_allmessageIdArr removeObject:message.msgId];
    [_messageTableView loadMoreMessage];
}

- (void)getPageMessage {
    [self cleanMessageCache];
    NSMutableArray * arrList = [[NSMutableArray alloc] init];
    [_allmessageIdArr addObject:[[NSObject alloc] init]];
    
    messageOffset = messagefristPageNumber;
    
    [arrList addObjectsFromArray:[[[_conversation messageArrayFromNewestWithOffset:@0 limit:@(messageOffset)] reverseObjectEnumerator] allObjects]];
    if ([arrList count] < messagefristPageNumber) {
        isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    for (NSInteger i=0; i< [arrList count]; i++) {
        JMSGMessage *message = [arrList objectAtIndex:i];
        JMSGChatModel *model = [[JMSGChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr addObject:model];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr addObject:model.message.msgId];
    }
    [_messageTableView reloadData];
    [self scrollToBottomAnimated:NO];
}

- (void)flashToLoadMessage {
    NSMutableArray * arrList = @[].mutableCopy;
    NSArray *newMessageArr = [_conversation messageArrayFromNewestWithOffset:@(messageOffset) limit:@(messagePageNumber)];
    [arrList addObjectsFromArray:newMessageArr];
    if ([arrList count] < messagePageNumber) {
        isNoOtherMessage = YES;
        [_allmessageIdArr removeObjectAtIndex:0];
    }
    
    messageOffset += messagePageNumber;
    for (NSInteger i = 0; i < [arrList count]; i++) {
        JMSGMessage *message = arrList[i];
        JMSGChatModel *model = [[JMSGChatModel alloc] init];
        [model setChatModelWith:message conversationType:_conversation];
        
        if (message.contentType == kJMSGContentTypeImage) {
            [_imgDataArr insertObject:model atIndex:0];
            model.photoIndex = [_imgDataArr count] - 1;
        }
        
        [_allMessageDic setObject:model forKey:model.message.msgId];
        [_allmessageIdArr insertObject:model.message.msgId atIndex: isNoOtherMessage ? 0 : 1];
    }
    [_messageTableView loadMoreMessage];
}

- (XHVoiceRecordHelper *)voiceRecordHelper {
    if (!_voiceRecordHelper) {
        WEAKSELF
        _voiceRecordHelper = [[XHVoiceRecordHelper alloc] init];
        _voiceRecordHelper.maxTimeStopRecorderCompletion = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf finishRecorded];
        };
        
        _voiceRecordHelper.peakPowerForChannel = ^(float peakPowerForChannel) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            strongSelf.voiceRecordHUD.peakPower = peakPowerForChannel;
        };
        _voiceRecordHelper.maxRecordTime = kVoiceRecorderTotalTime;
    }
    return _voiceRecordHelper;
}

- (XHVoiceRecordHUD *)voiceRecordHUD {
    if (!_voiceRecordHUD) {
        _voiceRecordHUD = [[XHVoiceRecordHUD alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
    }
    return _voiceRecordHUD;
}

- (void)pressVoiceBtnToHideKeyBoard {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    _toolBarHeightConstrait.constant = 45;
    [self dropToolBar];
}

- (void)switchToTextInputMode {
    [self.toolBarContainer.toolbar.textView becomeFirstResponder];
}

#pragma mark --增加朋友
- (void)addFriends
{
    JMSGGroupDetailViewController *groupDetailCtl = [[JMSGGroupDetailViewController alloc] init];
    groupDetailCtl.hidesBottomBarWhenPushed = YES;
    groupDetailCtl.conversation = _conversation;
    groupDetailCtl.sendMessageCtl = self;
    [self.navigationController pushViewController:groupDetailCtl animated:YES];
}

- (void)fileClick {
    
}

#pragma mark -调用相册
- (void)photoClick {
    YHPhotoPickerViewController *photoPickerVC = [[YHPhotoPickerViewController alloc] init];
    photoPickerVC.pickerDelegate = self;
    [self presentViewController:photoPickerVC animated:YES completion:NULL];
}

#pragma mark --调用相机
- (void)cameraClick {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        NSString *requiredMediaType = (NSString *)kUTTypeImage;
        NSArray *arrMediaTypes=[NSArray arrayWithObjects:requiredMediaType,nil];
        [picker setMediaTypes:arrMediaTypes];
        picker.showsCameraControls = YES;
        picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - 发送地理位置
- (void)locationClick {
}

#pragma mark 预览图片 PictureDelegate
- (void)tapPicture:(NSIndexPath *)index tapView:(UIImageView *)tapView tableViewCell:(UITableViewCell *)tableViewCell {
    [self.toolBarContainer.toolbar.textView resignFirstResponder];
    JMSGMessageTableViewCell *cell =(JMSGMessageTableViewCell *)tableViewCell;
    NSInteger count = _imgDataArr.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        JMSGChatModel *messageObject = [_imgDataArr objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.message = messageObject;
        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = [_imgDataArr indexOfObject:cell.model];
    //  browser.currentPhotoIndex = cell.model.photoIndex; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.conversation =_conversation;
    [browser show];
}

#pragma mark - YHPhotoPickerViewController Delegate
- (void)YHPhotoPickerViewController:(YHSelectPhotoViewController *)PhotoPickerViewController selectedPhotos:(NSArray *)photos {
    for (UIImage *image in photos) {
        [self prepareImageMessage:image];
    }
    [self dropToolBarNoAnimate];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.movie"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [MBProgressHUD showMessage:@"不支持视频发送" view:self.view];
        return;
    }
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self prepareImageMessage:image];
    [self dropToolBarNoAnimate];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --发送图片
- (void)prepareImageMessage:(UIImage *)img {
    img = [img resizedImageByWidth:upLoadImgWidth];
    
    JMSGChatModel *model = [[JMSGChatModel alloc] init];
    JMSGImageContent *imageContent = [[JMSGImageContent alloc] initWithImageData:UIImagePNGRepresentation(img)];
    if (imageContent) {
        [_conversation createMessageAsyncWithImageContent:imageContent completionHandler:^(id resultObject, NSError *error) {
            [[JMSGSendMsgManager ins] addMessage:resultObject withConversation:_conversation];
            [model setChatModelWith:resultObject conversationType:_conversation];
            [_imgDataArr addObject:model];
            model.photoIndex = [_imgDataArr count] - 1;
            [model setupImageSize];
            [self addMessage:model];
        }];
    }
}

#pragma mark --加载通知
- (void)addNotification{
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(cleanMessageCache)
                                                 name:kDeleteAllMessage
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteMessage:)
                                                 name:kDeleteMessage
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emotionDidSelected:)
                                                 name:HMEmotionDidSelectedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(emotionDidDeleted:)
                                                 name:HMEmotionDidDeletedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendEmotion)
                                                 name:FaceSendButton
                                               object:nil];
    self.toolBarContainer.toolbar.textView.delegate = self;
}

- (void)inputKeyboardWillShow:(NSNotification *)notification{
    _barBottomFlag = NO;
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        _moreViewHeight.constant = keyBoardFrame.size.height;
        [self.view layoutIfNeeded];
    }];
    [self scrollToEnd];
}

- (void)inputKeyboardWillHide:(NSNotification *)notification {
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:animationTime animations:^{
        _moreViewHeight.constant = 0;
    }];
    [self scrollToBottomAnimated:NO];
}

- (void)sendEmotion {
    [self sendText:self.toolBarContainer.toolbar.textView.messageText];
    self.toolBarContainer.toolbar.textView.text = @"";
}

#pragma mark --发送文本
- (void)sendText:(NSString *)text {
    [self prepareTextMessage:text];
}

#pragma mark --返回下面的位置
- (void)dropToolBar {
    _barBottomFlag = YES;
    _toolBarContainer.toolbar.addButton.selected = NO;
    [UIView animateWithDuration:0.3 animations:^{
        _toolBarToBottomConstrait.constant = 0;
        _moreViewHeight.constant = 0;
    }];
}

- (void)dropToolBarNoAnimate {
    _barBottomFlag = YES;
    _toolBarContainer.toolbar.addButton.selected = NO;
    [_messageTableView reloadData];
    _toolBarToBottomConstrait.constant = 0;
    _moreViewHeight.constant = 0;
}

#pragma mark --按下功能响应
- (void)pressMoreBtnClick:(UIButton *)btn {
    _barBottomFlag = NO;
    if(_toolBarContainer.toolbar.textView.inputView) {
        _toolBarContainer.toolbar.textView.inputView = nil;
    }
    [_toolBarContainer.toolbar.textView resignFirstResponder];
    [UIView animateWithDuration:0.25 animations:^{
        _toolBarToBottomConstrait.constant = 0;
        _moreViewHeight.constant = 216;
    }];
    [_toolBarContainer.toolbar switchToolbarToTextMode];
    [self scrollToBottomAnimated:NO];
}

- (void)noPressmoreBtnClick:(UIButton *)btn {
    [_toolBarContainer.toolbar.textView becomeFirstResponder];
}

- (void)pressEmotionBtnClick:(UIButton *)btn {
    _barBottomFlag = NO;
    [_toolBarContainer.toolbar.textView resignFirstResponder];
    
    if(_toolBarContainer.toolbar.textView.inputView &&
       [_toolBarContainer.toolbar.textView.inputView isKindOfClass:[HMEmotionKeyboard class]]) {
        _toolBarContainer.toolbar.textView.inputView = nil;
    } else {
        _toolBarContainer.toolbar.textView.inputView = self.keyboard;
    }
    [_toolBarContainer.toolbar switchToolbarToTextMode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_toolBarContainer.toolbar.textView becomeFirstResponder];
    });
    [self scrollToBottomAnimated:NO];
}

#pragma mark  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    [self.toolBarContainer.toolbar.textView appendEmotion:emotion];
//    [self textViewDidChange:self.bottomInputView];
}

#pragma mark  当点击表情键盘上的删除按钮时调用
- (void)emotionDidDeleted:(NSNotification *)note
{
    [self.toolBarContainer.toolbar.textView deleteBackward];
}

#pragma mark ----发送文本消息
- (void)prepareTextMessage:(NSString *)text {
    if ([text isEqualToString:@""] || text == nil) {
        return;
    }
    [[JMSGSendMsgManager ins] updateConversation:_conversation withDraft:@""];
    JMSGTextContent *textContent = [[JMSGTextContent alloc] initWithText:text];
    JMSGChatModel *model = [[JMSGChatModel alloc] init];
    JMSGMessage *message = [_conversation createMessageWithContent:textContent];
    [_conversation sendMessage:message];
    [model setChatModelWith:message conversationType:_conversation];
    [self addMessage:model];
}

#pragma mark -- 刷新对应的
- (void)addCellToTabel {
    NSIndexPath *path = [NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0];
    [_messageTableView beginUpdates];
    [_messageTableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
    [_messageTableView endUpdates];
    [self scrollToEnd];
}

#pragma mark --滑动至尾端
- (void)scrollToEnd {
    if ([_allmessageIdArr count] != 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isNoOtherMessage) {
        if (indexPath.row == 0) { //这个是第 0 行 用于刷新
            return 40;
        }
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    JMSGChatModel *model = _allMessageDic[messageId ];
    
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
        return model.contentHeight + 17;
    }
    
    if (model.message.contentType == kJMSGContentTypeText) {
        return model.contentHeight + 17;
    } else if (model.message.contentType == kJMSGContentTypeImage) {
        if (model.imageSize.height == 0) {
            [model setupImageSize];
        }
        return model.imageSize.height < 44?59:model.imageSize.height + 14;
        
    } else if (model.message.contentType == kJMSGContentTypeVoice) {
        return 69;
    } else {
        return 49;
    }
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_allmessageIdArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!isNoOtherMessage) {
        if (indexPath.row == 0) {
            static NSString *cellLoadIdentifier = @"loadCell";
            JMSGLoadMessageTableViewCell *cell = (JMSGLoadMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellLoadIdentifier];
            
            if (cell == nil) {
                cell = [[JMSGLoadMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellLoadIdentifier];
            }
            [cell startLoading];
            [self performSelector:@selector(flashToLoadMessage) withObject:nil afterDelay:0];
            return cell;
        }
    }
    NSString *messageId = _allmessageIdArr[indexPath.row];
    if (!messageId) {
        return nil;
    }
    
    JMSGChatModel *model = _allMessageDic[messageId];
    if (!model) {
        return nil;
    }
    
    if (model.message.contentType == kJMSGContentTypeEventNotification || model.isErrorMessage) {
        static NSString *cellIdentifier = @"timeCell";
        JMSGShowTimeCell *cell = (JMSGShowTimeCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"JMSGShowTimeCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (model.isErrorMessage) {
            cell.messageTimeLabel.text = [NSString stringWithFormat:@"%@ 错误码:%ld",st_receiveErrorMessageDes,(long)model.messageError.code];
            return cell;
        }
        
        if (model.message.contentType == kJMSGContentTypeEventNotification) {
            cell.messageTimeLabel.text = [((JMSGEventContent *)model.message.content) showEventNotification];
        } else {
            cell.messageTimeLabel.text = [JMSGStringUtils getFriendlyDateString:[model.messageTime doubleValue]];
        }
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"MessageCell";
        JMSGMessageTableViewCell *cell = (JMSGMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[JMSGMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.conversation = _conversation;
        }
        
        [cell setCellData:model delegate:self indexPath:indexPath];
        return cell;
    }
}

#pragma mark -PlayVoiceDelegate
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    if ([_allmessageIdArr count] - 1 > indexPath.row) {
        NSString *messageId = _allmessageIdArr[indexPath.row + 1];
        JMSGChatModel *model = _allMessageDic[ messageId];
        
        if (model.message.contentType == kJMSGContentTypeVoice && model.message.flag) {
            JMSGMessageTableViewCell *voiceCell =(JMSGMessageTableViewCell *)[self.messageTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
            [voiceCell playVoice];
        }
    }
}

- (void)setMessageIDWithMessage:(JMSGMessage *)message chatModel:(JMSGChatModel * __strong *)chatModel index:(NSInteger)index {
    [_allMessageDic removeObjectForKey:(*chatModel).message.msgId];
    [_allMessageDic setObject:*chatModel forKey:message.msgId];
    
    if ([_allmessageIdArr count] > index) {
        [_allmessageIdArr removeObjectAtIndex:index];
        [_allmessageIdArr insertObject:message.msgId atIndex:index];
    }
}

#pragma mark SendMessageDelegate
- (void)didStartRecordingVoiceAction {
    [self startRecord];
}

- (void)didCancelRecordingVoiceAction {
    [self cancelRecord];
}

- (void)didFinishRecordingVoiceAction {
    [self finishRecorded];
}

- (void)didDragOutsideAction {
    [self resumeRecord];
}

- (void)didDragInsideAction {
    [self pauseRecord];
}

- (void)pauseRecord {
    [self.voiceRecordHUD pauseRecord];
}

- (void)resumeRecord {
    [self.voiceRecordHUD resaueRecord];
}

- (void)cancelRecord {
    WEAKSELF
    [self.voiceRecordHUD cancelRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper cancelledDeleteWithCompletion:^{
        
    }];
}

#pragma mark - Voice Recording Helper Method
- (void)startRecord {
    [self.voiceRecordHUD startRecordingHUDAtView:self.view];
    [self.voiceRecordHelper startRecordingWithPath:[self getRecorderPath] StartRecorderCompletion:^{
    }];
}

- (void)finishRecorded {
    WEAKSELF
    [self.voiceRecordHUD stopRecordCompled:^(BOOL fnished) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.voiceRecordHUD = nil;
    }];
    [self.voiceRecordHelper stopRecordingWithStopRecorderCompletion:^{
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf SendMessageWithVoice:strongSelf.voiceRecordHelper.recordPath
                           voiceDuration:strongSelf.voiceRecordHelper.recordDuration];
    }];
}

#pragma mark --发送语音
- (void)SendMessageWithVoice:(NSString *)voicePath
               voiceDuration:(NSString*)voiceDuration {
    if ([voiceDuration integerValue]<0.5) {
        return;
    }
    if ([voiceDuration integerValue]>60) {
        return;
    }
    JMSGChatModel *model =[[JMSGChatModel alloc] init];
    JMSGVoiceContent *voiceContent = [[JMSGVoiceContent alloc] initWithVoiceData:[NSData dataWithContentsOfFile:voicePath] voiceDuration:[NSNumber numberWithInteger:[voiceDuration integerValue]]];
    //SDK：创建消息对象
    JMSGMessage *voiceMessage = [_conversation createMessageWithContent:voiceContent];
    [_conversation sendMessage:voiceMessage];
    [model setChatModelWith:voiceMessage conversationType:_conversation];
    [JMSGFileManager deleteFile:voicePath];
    [self addMessage:model];
}

#pragma mark - RecorderPath Helper Method
- (NSString *)getRecorderPath {
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yy-MMMM-dd";
    NSString *recorderPath = [[NSString alloc] initWithFormat:@"%@/Documents/", NSHomeDirectory()];
    dateFormatter.dateFormat = @"yyyy-MM-dd-hh-mm-ss";
    recorderPath = [recorderPath stringByAppendingFormat:@"%@-MySound.ilbc", [dateFormatter stringFromDate:now]];
    return recorderPath;
}

- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.messageTableView numberOfRowsInSection:0];
    if (rows > 0) {
        [self.messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_allmessageIdArr count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:animated];
    }
}

- (HMEmotionKeyboard *)keyboard
{
    if (!_keyboard) {
        _keyboard = [HMEmotionKeyboard keyboard];
        _keyboard.width = BT_SCREEN_WIDTH;
        _keyboard.height = 216.0f;
    }
    return _keyboard;
}

@end
