//
//  JMSGToolBar.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import "JMSGToolBar.h"
#import "JMSGRecordAnimationView.h"
#import "NSString+MessageInputView.h"
#import "JMSGFileManager.h"
#import "JMSGAudioPlayerHelper.h"
#import "JMSGViewUtil.h"

@implementation JMSGToolBar

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.cornerRadius = 5.0;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self addSubview:self.startRecordButton];
    
//    UIWindow *window =(UIWindow *)[UIApplication sharedApplication].keyWindow;
//    self.recordAnimationView = [[JMSGRecordAnimationView alloc]initWithFrame:CGRectMake((kApplicationWidth-140)/2, (kScreenHeight -kNavigationBarHeight - kTabBarHeight - 140)/2, 140, 140)];
//    [window addSubview:self.recordAnimationView];
}

- (IBAction)addBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(noPressmoreBtnClick:)]) {
        if (self.addButton.selected) {
            self.addButton.selected = NO;
            [self.delegate noPressmoreBtnClick:sender];
        } else if (self.delegate && [self.delegate respondsToSelector:@selector(pressMoreBtnClick:)]){
            [self.delegate pressMoreBtnClick:sender];
            self.addButton.selected=YES;
        }
    }
}

- (IBAction)emotionBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressMoreBtnClick:)]){
        [self.delegate pressEmotionBtnClick:sender];
    }
}

- (IBAction)voiceBtnClick:(id)sender {
    if(self.textView.inputView) {
        self.textView.inputView = nil;
    }
    [self switchInputMode];
}

- (void)switchInputMode {
    if (self.voiceButton.selected == NO) {
        _textViewHeight.constant = 36;
        [self switchToVoiceInputMode];
    } else {
        [self switchToTextInputMode];
    }
}

- (void)switchToVoiceInputMode {
    self.voiceButton.selected = YES;
    [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_Keyboard"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_KeyboardHL"] forState:UIControlStateHighlighted];
    
    [self.textView setHidden:YES];
    [self.startRecordButton setHidden:NO];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pressVoiceBtnToHideKeyBoard)]) {
        [self.delegate pressVoiceBtnToHideKeyBoard];
    }
}

- (void)switchToTextInputMode {
    [self switchToolbarToTextMode];
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchToTextInputMode)]) {
        [self.delegate switchToTextInputMode];
    }
}

- (void)switchToolbarToTextMode {
    self.voiceButton.selected=NO;
    self.voiceButton.contentMode = UIViewContentModeCenter;
    [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_Voice"] forState:UIControlStateNormal];
    [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_VoiceHL"] forState:UIControlStateHighlighted];
    [self.startRecordButton setHidden:YES];
    [self.textView setHidden:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.voiceButton.selected == NO) {
        [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_Voice"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_VoiceHL"] forState:UIControlStateHighlighted];
    } else{
        [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_Keyboard"] forState:UIControlStateNormal];
        [self.voiceButton setImage:[UIImage imageNamed:@"YH_KB_KeyboardHL"] forState:UIControlStateHighlighted];
    }
}

- (void)drawRect:(CGRect)rect {
    if (self.textView.delegate != self) {
        self.textView.delegate = self;
    }
    self.startRecordButton.frame = self.textView.frame;
}

- (void)holdDownButtonTouchDown {
    if ([self.delegate respondsToSelector:@selector(didStartRecordingVoiceAction)]) {
        [[JMSGAudioPlayerHelper shareInstance] stopAudio];
        [self.delegate didStartRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpOutside {
    if ([self.delegate respondsToSelector:@selector(didCancelRecordingVoiceAction)]) {
        [self.delegate didCancelRecordingVoiceAction];
    }
}

- (void)holdDownButtonTouchUpInside {
    if ([self.delegate respondsToSelector:@selector(didFinishRecordingVoiceAction)]) {
        [self.delegate didFinishRecordingVoiceAction];
    }
}

- (void)holdDownDragOutside {
    if ([self.delegate respondsToSelector:@selector(didDragOutsideAction)]) {
        [self.delegate didDragOutsideAction];
    }
}

- (void)holdDownDragInside {
    if ([self.delegate respondsToSelector:@selector(didDragInsideAction)]) {
        [self.delegate didDragInsideAction];
    }
}

- (void)levelMeterChanged:(float)levelMeter{
    [self.recordAnimationView changeanimation:levelMeter];
}

#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight {
    // 动态改变自身的高度和输入框的高度
    NSUInteger numLines = MAX([self.textView numberOfLinesOfText],
                              [self.textView.text numberOfLines]);
    
    if ([_textView.text isEqualToString: @""]) {
        return;
    }
    
    CGSize textSize = [JMSGStringUtils stringSizeWithWidthString:_textView.text withWidthLimit:_textView.frame.size.width withFont:[UIFont systemFontOfSize:st_toolBarTextSize]];
    CGFloat textViewHeight = textSize.height + 30;
    _textViewHeight.constant = textViewHeight>36?textViewHeight:36;
    self.textView.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    // from iOS 7, the content size will be accurate only if the scrolling is enabled.
    self.textView.scrollEnabled = YES;
    if (numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.textView.contentSize.height - self.textView.bounds.size.height);
        [self.textView setContentOffset:bottomOffset animated:YES];
        [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length - 2, 1)];
    }
}

#pragma mark --判断能否录音
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if (kIOSVersions >= 7.0)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"无法录音"
                                                    message:@"请在“设置-隐私-麦克风”选项中，允许jpushIM访问你的手机麦克风。"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil]  show];
                    });
                }
            }];
        }
    } else{
        bCanRecord = YES;
    }
    return bCanRecord;
}

#pragma mark -
#pragma mark RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath time:(NSTimeInterval)interval
{
    if (interval < 0.50) {
        [JMSGFileManager deleteFile:filePath];
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSRange range = [filePath rangeOfString:@"spx"];
        if (range.length > 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(playVoice:time:)]) {
                [self.delegate playVoice:filePath time:[NSString stringWithFormat:@"%.f",ceilf(interval)]];
            }
        }
    });
}

- (void)recordingTimeout
{
    [self.recordAnimationView stopAnimation];
    self.isRecording = NO;
}

- (void)recordingStopped //录音机停止采集声音
{
    self.isRecording = NO;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendText:)]) {
            if ([textView isKindOfClass:[JMSGMessageTextView class]]) {
                JMSGMessageTextView *msgTextView = (JMSGMessageTextView *)textView;
                [self.delegate sendText:msgTextView.messageText];
            } else {
                [self.delegate sendText:textView.text];
            }
        }
        textView.text = @"";
        return NO;
    }
    return YES;
}

#pragma mark - Text view delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewWillBeginEditing:)]) {
        [self.delegate inputTextViewWillBeginEditing:self.textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidBeginEditing:)]) {
        [self.delegate inputTextViewDidBeginEditing:self.textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidEndEditing:)]) {
        [self.delegate inputTextViewDidEndEditing:self.textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(inputTextViewDidChange:)]) {
        [self.delegate inputTextViewDidChange:self.textView];
    }
}

+ (CGFloat)textViewLineHeight {
    return st_toolBarTextSize * [UIScreen mainScreen].scale; // for fontSize 16.0f
}

+ (CGFloat)maxLines {
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 3.0f : 8.0f;
}

+ (CGFloat)maxHeight {
    return ([JMSGToolBar maxLines] + 1.0f) * [JMSGToolBar textViewLineHeight];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    _textView = nil;
}

#pragma mark - setter
- (UIButton *)startRecordButton {
    if (!_startRecordButton) {
        _startRecordButton = [[UIButton alloc] init];
        _startRecordButton.layer.masksToBounds = YES;
        _startRecordButton.layer.cornerRadius = 5.0;
        _startRecordButton.layer.borderWidth = 0.5;
        _startRecordButton.layer.borderColor = [[UIColor grayColor] CGColor];
        
        [_startRecordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_startRecordButton setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
        [_startRecordButton setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_startRecordButton setTitle:@"松开 结束" forState:UIControlStateHighlighted];
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [_startRecordButton addTarget:self action:@selector(holdDownButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
        [_startRecordButton addTarget:self action:@selector(holdDownDragOutside) forControlEvents:UIControlEventTouchDragExit];
        [_startRecordButton addTarget:self action:@selector(holdDownDragInside) forControlEvents:UIControlEventTouchDragEnter];
        [_startRecordButton setHidden:YES];
    }
    return _startRecordButton;
}

@end


@implementation JCHATToolBarContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _toolbar = NIB(JMSGToolBar);
    [self performSelector:@selector(addtoolbar) withObject:nil afterDelay:0.02];
}
- (void)addtoolbar {
    self.toolbar.frame = CGRectMake(0, 0, kApplicationWidth, 45);
    [self addSubview:_toolbar];
}

@end
