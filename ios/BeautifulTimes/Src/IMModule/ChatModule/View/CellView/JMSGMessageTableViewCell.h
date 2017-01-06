//
//  JMSGMessageTableViewCell.h
//  JMessageDemo
//
//  Created by 邓永豪 on 16/4/11.
//  Copyright © 2016年 HXHG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMSGMessageContentView.h"
#import "JMSGAudioPlayerHelper.h"
#import "JMSGChatModel.h"

@protocol playVoiceDelegate <NSObject>
@optional
- (void)successionalPlayVoice:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)getContinuePlay:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

- (void)selectHeadView:(JMSGChatModel *)model;

- (void)setMessageIDWithMessage:(JMSGMessage *)message
                      chatModel:(JMSGChatModel * __strong *)chatModel
                          index:(NSInteger)index;
@end

@protocol PictureDelegate <NSObject>
@optional
- (void)tapPicture :(NSIndexPath *)index
           tapView :(UIImageView *)tapView
      tableViewCell:(UITableViewCell *)tableViewCell;

- (void)selectHeadView:(JMSGChatModel *)model;
@end


@interface JMSGMessageTableViewCell : UITableViewCell <XHAudioPlayerHelperDelegate,
playVoiceDelegate,JMSGMessageDelegate>

@property(strong,nonatomic)UIImageView *headView;
@property(strong,nonatomic)JMSGMessageContentView *messageContent;
@property(strong,nonatomic)JMSGChatModel *model;
@property(weak, nonatomic)JMSGConversation *conversation;
@property(weak, nonatomic) id delegate;

@property (strong, nonatomic) UIImageView *sendFailView;
@property (strong, nonatomic) UIActivityIndicatorView *circleView;

//image
@property (strong, nonatomic) UILabel *percentLabel;

//voice
@property(assign, nonatomic)BOOL continuePlayer;
@property(assign, nonatomic)BOOL isPlaying;
@property(assign, nonatomic)NSInteger index;//voice 语音图片的当前显示
@property(strong, nonatomic)NSIndexPath *indexPath;
@property(strong, nonatomic)UIView *readView;
@property(strong, nonatomic)UILabel *voiceTimeLabel;

- (void)playVoice;
- (void)setCellData:(JMSGChatModel *)model
           delegate:(id <playVoiceDelegate>)delegate
          indexPath:(NSIndexPath *)indexPath
;
- (void)layoutAllView;
@end
