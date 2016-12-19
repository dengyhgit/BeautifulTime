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
    ChatToolViewTypeEmotion,
    ChatToolViewTypeAddPicture, 
    ChatToolViewTypeAudio,
    
}ChatToolViewType;

@protocol ChatToolViewDelegate;

@interface BTChatToolView : UIView

@property (nonatomic,weak) BTSendTextView *toolInputView;
@property (nonatomic,weak) id <ChatToolViewDelegate> delegate;
@property (assign,nonatomic) BOOL emotionStatus;
@property (assign,nonatomic) BOOL addStatus;

@end

@protocol ChatToolViewDelegate <NSObject>

@optional

-(void)chatToolView:(BTChatToolView *)toolView buttonTag:(ChatToolViewType)buttonTag;

@end
