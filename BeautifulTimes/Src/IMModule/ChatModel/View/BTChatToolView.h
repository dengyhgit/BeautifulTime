//
//  BTChatToolView.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTSendTextView.h"

typedef enum{
    ChatToolViewTypeEmotion, //表情按钮
    ChatToolViewTypeAddPicture, //图片按钮
    ChatToolViewTypeAudio, //语音按钮
    
}ChatToolViewType;

@protocol ChatToolViewDelegate;

@interface BTChatToolView : UIView

@property (nonatomic,weak) BTSendTextView *toolInputView;
@property (nonatomic,weak) id <ChatToolViewDelegate> delegate;
//表情按钮的选中状态
@property (assign,nonatomic) BOOL emotionStatus;
//添加图片按钮的选中状态
@property (assign,nonatomic) BOOL addStatus;

@end

@protocol ChatToolViewDelegate <NSObject>

@optional

-(void)chatToolView:(BTChatToolView *)toolView buttonTag:(ChatToolViewType)buttonTag;

@end
