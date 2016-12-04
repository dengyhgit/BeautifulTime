//
//  HMEmotionToolbar.m
//  黑马微博
//
//  Created by apple on 14-7-15.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#define HMEmotionToolbarButtonMaxCount 5

#import "HMEmotionToolbar.h"

@interface HMEmotionToolbar()

/** 记录当前选中的按钮 */
@property (nonatomic, weak) UIButton *selectedButton;
@end

@implementation HMEmotionToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.添加4个按钮
        [self setupButton:nil image:@"Expression_67" tag:HMEmotionTypeRecent];
        [self setupButton:nil image:@"Expression_1" tag:HMEmotionTypeDefault];
        [self setupButton:nil image:@"EmotionsEmojiHL" tag:HMEmotionTypeEmoji];
        [self setupButton:nil image:@"lxh_buhaoyisi" tag:HMEmotionTypeLxh];
      //2.添加发送按钮
        [self addSendButton:@"发送" tag:HMEmotionTypeSend];
        // 3.监听表情选中的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 *  表情选中
 */
- (void)emotionDidSelected:(NSNotification *)note
{
    if (self.selectedButton.tag == HMEmotionTypeRecent) {
        [self buttonClick:self.selectedButton];
    }
}
#pragma mark 添加发送按钮
-(UIButton*)addSendButton:(NSString*)title tag:(HMEmotionType)tag
{
    UIButton *send=[[UIButton alloc]init];
    send.tag=tag;
    [send setTitle:title forState:UIControlStateNormal];
    [send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [send setBackgroundColor:[UIColor blueColor]];
    send.titleLabel.font=MyFont(14);
    [send addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:send];
    return send;
}

/**
 *  添加按钮
 *
 *  @param title 按钮文字
 */
- (UIButton *)setupButton:(NSString *)title image:(NSString*)image tag:(HMEmotionType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    //如果有图片设置图片 没有设置文字
    if(image){
        [button setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }else{
        // 文字
        [button setTitle:title forState:UIControlStateNormal];
    }
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    
    // 添加按钮
    [self addSubview:button];
    
    // 设置背景图片
    int count = self.subviews.count;
    if (count == 1) { // 第一个按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_left_selected"] forState:UIControlStateSelected];
    } else if (count == HMEmotionToolbarButtonMaxCount) { // 最后一个按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_right_selected"] forState:UIControlStateSelected];
    } else { // 中间按钮
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage resizedImage:@"compose_emotion_table_mid_selected"] forState:UIControlStateSelected];
    }
    
    return button;
}
#pragma mark 发送按钮的点击方法
-(void)sendButtonClick:(UIButton*)sender
{
    //点击发送一个通知  faceSendButton
    NSNotification *note=[[NSNotification alloc]initWithName:FaceSendButton object:nil userInfo:nil];
    [Mynotification postNotification:note];
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    // 1.控制按钮状态
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    // 2.通知代理
    if ([self.delegate respondsToSelector:@selector(emotionToolbar:didSelectedButton:)]) {
        [self.delegate emotionToolbar:self didSelectedButton:button.tag];
    }
}

- (void)setDelegate:(id<HMEmotionToolbarDelegate>)delegate
{
    _delegate = delegate;
    
    // 获得“默认”按钮
    UIButton *defaultButton = (UIButton *)[self viewWithTag:HMEmotionTypeDefault];
    // 默认选中“默认”按钮
    [self buttonClick:defaultButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置工具条按钮的frame
    CGFloat buttonW = self.width / HMEmotionToolbarButtonMaxCount;
    CGFloat buttonH = self.height;
    for (int i = 0; i<HMEmotionToolbarButtonMaxCount; i++) {
        UIButton *button = self.subviews[i];
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}

@end
