//
//  BTChatToolView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatToolView.h"
#import "UIImage+Addition.h"
#import "BTSendTextView.h"

#define centerMargin 5
#define leftMargin  2
#define buttonWidth 35
#define buttonHeight 35
#define inputViewHeight 36

static CGFloat const chatToolViewHeight = 49;

@interface BTChatToolView ()

@property (nonatomic,weak) UIButton *audioButton;
@property (nonatomic,weak) UIButton *faceButton;
@property (nonatomic,weak) UIButton *addButton;

@end

@implementation BTChatToolView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.width = BT_SCREEN_WIDTH;
        self.height = chatToolViewHeight;
        [self setupFirst];
    }
    return self;
}

#pragma mark 添加子控件
- (void)setupFirst
{
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:line];

    UIButton *audioButton = [self addButtonWithImage:BT_LOADIMAGE(@"ToolViewInputVoice") highImage:BT_LOADIMAGE(@"ToolViewInputVoiceHL")  tag:ChatToolViewTypeAudio];
    self.audioButton = audioButton;

    [self addTextView];

    UIButton *faceButton = [self addButtonWithImage:BT_LOADIMAGE(@"ToolViewEmotion") highImage:BT_LOADIMAGE(@"ToolViewEmotion") tag:ChatToolViewTypeEmotion];
    self.faceButton = faceButton;

    UIButton *addButton = [self addButtonWithImage:BT_LOADIMAGE(@"TypeSelectorBtn_Black") highImage:BT_LOADIMAGE(@"TypeSelectorBtnHL_Black")  tag:ChatToolViewTypeAddPicture];
    self.addButton = addButton;
    
}
#pragma mark 添加输入框
- (void)addTextView
{
    BTSendTextView *send = [[BTSendTextView alloc] init];
    [self addSubview:send];
    self.toolInputView = send;
}

#pragma mark 添加按钮
- (UIButton*)addButtonWithImage:(UIImage *)image highImage:(UIImage *)highImage  tag:(ChatToolViewType)tag
{
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage resizedImage:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage resizedImage:highImage] forState:UIControlStateHighlighted];
    btn.tag = tag;
    [btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    return btn;
}

#pragma mark 按钮点击的事件
-(void)buttonClick:(UIButton*)sender {
    if(_delegate && [_delegate respondsToSelector:@selector(chatToolView: buttonTag:)]){
        [_delegate chatToolView:self buttonTag:(ChatToolViewType)sender.tag];
    }
}

#pragma mark 设置表情按钮的图片
-(void)setEmotionStatus:(BOOL)emotionStatus
{
    _emotionStatus = emotionStatus;
    _addStatus = NO;
    
    if(emotionStatus){
        [self.faceButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewKeyboard")] forState:UIControlStateNormal];
        [self.faceButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewKeyboardHL")] forState:UIControlStateHighlighted];
    }else{
        [self.faceButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewEmotion")] forState:UIControlStateNormal];
        [self.faceButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewEmotion")] forState:UIControlStateHighlighted];
    }
}
#pragma mark 设置添加图片的按钮
-(void)setAddStatus:(BOOL)addStatus
{
    _addStatus = addStatus;
    _emotionStatus = NO;
    if(addStatus){
        [self.addButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewKeyboard")] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ToolViewKeyboardHL")] forState:UIControlStateHighlighted];
    }else{
        [self.addButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"TypeSelectorBtn_Black")] forState:UIControlStateNormal];
        [self.addButton setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"TypeSelectorBtnHL_Black")] forState:UIControlStateHighlighted];
    }
}

-(void)layoutSubviews
{
    [super subviews];

    CGFloat btnY = (self.height - buttonHeight) * 0.5;
    
    CGFloat audioX = leftMargin;
    self.audioButton.frame = CGRectMake(audioX, btnY, buttonWidth, buttonHeight);
    
    CGFloat inputW = BT_SCREEN_WIDTH - 3 * buttonWidth - leftMargin * 2 - centerMargin * 3;

    CGFloat inputX = CGRectGetMaxX(self.audioButton.frame) + centerMargin + 1;
    CGFloat inputH = inputViewHeight;
    CGFloat inputY = (self.height - inputH) * 0.5;
    self.toolInputView.frame = CGRectMake(inputX, inputY, inputW, inputH);

    CGFloat faceX = CGRectGetMaxX(self.toolInputView.frame) + centerMargin + 1;
    self.faceButton.frame=CGRectMake(faceX, btnY, buttonWidth, buttonHeight);

    CGFloat addImageX=CGRectGetMaxX(self.faceButton.frame) + centerMargin - 2;
    self.addButton.frame=CGRectMake(addImageX, btnY, buttonWidth, buttonHeight);
}

@end
