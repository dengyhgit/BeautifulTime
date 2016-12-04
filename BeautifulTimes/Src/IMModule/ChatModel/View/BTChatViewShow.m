//
//  BTChatViewShow.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatViewShow.h"
#import "BTMessageFrameModel.h"
#import "BTChatMessageModel.h"

@interface BTChatViewShow ()

@property (nonatomic,weak) UILabel *timeLabel;
@property (nonatomic,weak) UIButton *contentBtn;
@property (nonatomic,weak) UIImageView *headImage;

@end

@implementation BTChatViewShow

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        
        [self setupChildView];
        
    }
    return self;
}

#pragma mark 添加子控件
-(void)setupChildView
{
    //1.时间
    UILabel *timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor lightGrayColor];
    timeLabel.font = BT_FONTSIZE(15);
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:timeLabel];
    self.timeLabel = timeLabel;
    //2.正文内容
    UIButton *contentBtn = [[UIButton alloc]init];
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.font = BT_FONTSIZE(15);
    contentBtn.titleLabel.numberOfLines = 0;  //多行显示
    contentBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 20, 20, 20);
    
    [self addSubview:contentBtn];
    self.contentBtn = contentBtn;
    //3.头像
    UIImageView *headImage = [[UIImageView alloc]init];
    [self addSubview:headImage];
    self.headImage = headImage;
}

//传递模型
-(void)setFrameModel:(BTMessageFrameModel *)frameModel
{
    _frameModel = frameModel;
    self.frame = frameModel.chatFrame;
    
    self.timeLabel.frame = frameModel.timeFrame;
    self.timeLabel.text = frameModel.messageModel.time;

    if(frameModel.messageModel.isCurrentUser){
        UIImage *head = frameModel.messageModel.ownHeadIcon ? [UIImage imageWithData:frameModel.messageModel.ownHeadIcon]:[UIImage imageNamed:@"DefaultCompanyHead"];
        self.headImage.image = head;
    }else{
        self.headImage.image = frameModel.messageModel.friendHeadIcon ? frameModel.messageModel.friendHeadIcon:[UIImage imageNamed:@"DefaultHead"];
    }
    self.headImage.frame = frameModel.headFrame;

    [self.contentBtn setAttributedTitle:frameModel.messageModel.attributedBody forState:UIControlStateNormal];
    self.contentBtn.frame = frameModel.contentFrame;

    if(frameModel.messageModel.isCurrentUser){
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"SenderTextNodeBkg")] forState:UIControlStateNormal];
    } else {
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:BT_LOADIMAGE(@"ReceiverAppNodeBkg")] forState:UIControlStateNormal];
    }
}

@end