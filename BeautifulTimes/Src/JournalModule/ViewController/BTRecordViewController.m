//
//  BTRecordViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTRecordViewController.h"
#import "BTCircularProgressButton.h"
#import "BTJournalController.h"
#import "BTAddJournalViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BTJournalController.h"
#import "BTEditJournalViewController.h"

static CGFloat const durationCircleSize = 112.0f;
static CGFloat const recorderDuration = 600;

@interface BTRecordViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    AVAudioSession * audioSession;
    BOOL isEditModel;
}

@property (nonatomic, strong) BTCircularProgressButton *progressButton; /**< 进度环 */
@property (nonatomic, strong) UIButton *recordIcon;
@property (nonatomic, strong) UIImageView *circlesImageView;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) NSTimer *timer;                    //定时器
@property (nonatomic, strong) NSURL *recordUrl;

@end

@implementation BTRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"录音";
    [self.bodyView addSubview:self.progressButton];
    [self.bodyView addSubview:self.recordIcon];
    [self.bodyView addSubview:self.circlesImageView];
    [self.bodyView addSubview:self.recordButton];
    [self.bodyView addSubview:self.playButton];
    [self.bodyView addSubview:self.resetButton];
    [self.bodyView addSubview:self.saveButton];
    audioSession = [AVAudioSession sharedInstance];
    [self initRecorder];
    isEditModel = NO;
    self.bgImageView.image = BT_LOADIMAGE(@"com_bg_journal01_1242x2208");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.circlesImageView setHidden:YES];
//    NSLog(@"view will appear record: %@", [BTJournalController sharedInstance].record);
    if ([BTJournalController sharedInstance].record  && ![[BTJournalController sharedInstance].record isEqualToString:@""]) {
        isEditModel = YES;
        [self.recordButton setHidden:YES];
        [self.playButton setHidden:NO];
        [self.resetButton setHidden:NO];
        [self.saveButton setHidden:YES];
    } else {
        [self.playButton setHidden:YES];
        [self.resetButton setHidden:YES];
        [self.saveButton setHidden:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [audioSession setActive:NO error:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    [self.progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(durationCircleSize));
        make.height.equalTo(@(durationCircleSize));
        make.centerX.equalTo(weakSelf.bodyView.mas_centerX);
        make.centerY.equalTo(weakSelf.bodyView).with.offset(-48);
    }];
    
    [self.recordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressButton);
        make.centerY.equalTo(weakSelf.progressButton);
        make.width.equalTo(@(56));
        make.height.equalTo(@(56));
    }];
    
    [self.circlesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressButton);
        make.centerY.equalTo(weakSelf.progressButton);
        make.width.equalTo(@(132));
        make.height.equalTo(@(132));
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(130));
        make.height.equalTo(@(40));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(130));
        make.height.equalTo(@(40));
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.left.equalTo(weakSelf.playButton).offset(- (60 + 20));
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.right.equalTo(weakSelf.playButton).offset(60 + 20);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backButtonClick {
    [super backButtonClick];
    if (player.isPlaying) {
        [player stop];
    }
}

#pragma mark -click event
- (void)recordButtonClick:(UIButton *)sender {
    if (!self.recordButton.selected) {
        self.recordButton.selected = YES;
        [self startRecord];
        [self startAnimate];
    }
    else {
        self.playButton.hidden = NO;
        self.recordButton.hidden = YES;
        self.resetButton.hidden = NO;
        self.saveButton.hidden = NO;
        [self stopRecord];
        [self stopAnimate];
        self.recordButton.selected = NO;
    }
}

- (void)saveButtonClick:(UIButton *)sender {
    if (player.isPlaying) {
        [player stop];
    }
    if (self.recordUrl) {
        NSString *filePath = [self.recordUrl absoluteString];
        NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
        
        NSString *documentDirectory = [BTTool getDocumentDirectory];
        NSString *uid = [self getSaveFilePath];
        NSString *savePath = [documentDirectory stringByAppendingPathComponent:uid];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        while (true) {
            if (![fileManager fileExistsAtPath:savePath]) {
                break;
            } else {
                uid = [self getSaveFilePath];
                savePath = [documentDirectory stringByAppendingPathComponent:uid];
            }
        }
        [data writeToFile:savePath atomically:YES];
        [fileManager removeItemAtPath:filePath error:nil];
//        NSLog(@"save finish remove:%@", filePath);
//        NSLog(@"-----------uid:%@", uid);
        [[BTJournalController sharedInstance] setRecord:uid];
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTAddJournalViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
        if ([controller isKindOfClass:[BTEditJournalViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (void)resetButtonClick:(UIButton *)sender {
//    if ([BTJournalController sharedInstance].record) {
//        [BTJournalController sharedInstance].record = nil;
//    }p==nnbb
    self.recordButton.hidden = NO;
    self.playButton.hidden = YES;
    self.resetButton.hidden = YES;
    self.saveButton.hidden = YES;
    if (player.isPlaying) {
        self.playButton.selected = NO;
        [self stopPlay];
        [self stopAnimate];
    }
    [self deleteRecordFile];
    player = nil;
    [self nowPlayingRecordCurrentTime:0 duration:recorderDuration];
    recorder = nil;
    [self initRecorder];
}

- (void)playButtonClick:(UIButton *)sender {
    if (!self.playButton.selected) {
        self.playButton.selected = YES;
        [self playRecord];
        [self startAnimate];
    }
    else {
        self.playButton.selected = NO;
        [self stopPlay];
        [self stopAnimate];
    }
}

- (void)playRecord {
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    if (self.recordUrl != nil){
        if (!player) {
            if (isEditModel) {
                if ([BTJournalController sharedInstance].record && ![[BTJournalController sharedInstance].record isEqualToString:@""]) {
                    NSString *saveRecordPath = [[BTTool getDocumentDirectory] stringByAppendingPathComponent:[BTJournalController sharedInstance].record];
//                    NSLog(@"路径%@", saveRecordPath);
                    NSData *recordData = [[NSData alloc] initWithContentsOfFile:saveRecordPath];
                    if (recordData) {
                        player = [[AVAudioPlayer alloc] initWithData:recordData error:nil];
                    } else {
//                        NSLog(@"1播放文件为空！！！！");
                    }
                } else {
                    player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordUrl error:nil];
                }
                
                
            } else {
                player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordUrl error:nil];
            }
            player.delegate = self;
            player.volume = 1;
        }
        [player prepareToPlay];
        [player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playProgressTime:) userInfo:nil repeats:YES];
    }
}

- (void)stopPlay {
    [player stop];
    player.currentTime = 0.0f;
    [self.timer invalidate];
    self.timer = nil;
    [self nowPlayingRecordCurrentTime:0 duration:player.duration];
}

- (void)deleteRecordFile {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (isEditModel) {
        if ([BTJournalController sharedInstance].record && ![[BTJournalController sharedInstance].record isEqualToString:@""]) {
            NSString *savePath = [[BTTool getDocumentDirectory] stringByAppendingPathComponent:[BTJournalController sharedInstance].record];
            if ([fileManager fileExistsAtPath:savePath]) {
//                NSLog(@"is editmodel remove: %@", savePath);
                [fileManager removeItemAtPath:savePath error:nil];
            }
        }
    }
    
    NSString *filePath = [self.recordUrl absoluteString];
    if ([fileManager fileExistsAtPath:filePath]) {
//        NSLog(@"移除：%@", filePath);
        [fileManager removeItemAtPath:filePath error:nil];
    }
    [BTJournalController sharedInstance].record = nil;
}

- (NSString *)getSaveFilePath {
    NSString *uid = [[NSUUID UUID] UUIDString];
    return uid;
}

#pragma mark AVAudioRecorder设置
- (void)startRecord {
    if ([recorder prepareToRecord]) {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [audioSession setActive:YES error:nil];
        [recorder record];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressTime:) userInfo:nil repeats:YES];
    }
}

- (void)initRecorder {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //常用的音频采样频率有8kHz、11.025kHz、22.05kHz、16kHz、37.8kHz、44.1kHz、48kHz等
    [recordSetting setValue:[NSNumber numberWithFloat:11025] forKey:AVSampleRateKey];
    //录音通道数  1 或 2（立体）
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSDate *now = [NSDate date];
    NSString *messageId = [NSString stringWithFormat:@"%d",(int)now.timeIntervalSince1970];
    for(int i = 0; i < 5; i++){
        int num = rand() % 10;
        NSString *str = [NSString stringWithFormat:@"%d",num];
        messageId = [messageId stringByAppendingString:str];
    }
    self.recordUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"]];
    recorder = [[AVAudioRecorder alloc] initWithURL:self.recordUrl settings:recordSetting error:nil];
    [recorder recordForDuration:recorderDuration];
    recorder.delegate = self;
}

- (void)progressTime:(NSTimer *)timer {
    [self nowPlayingRecordCurrentTime:recorder.currentTime duration:recorderDuration];
}

- (void)playProgressTime:(NSTimer *)timer {
    [self nowPlayingRecordCurrentTime:player.currentTime duration:player.duration];
}

- (void)stopRecord {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)startAnimate {
    self.circlesImageView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(1.0);
    animation.toValue = @(2.0);
    animation.repeatCount = MAXFLOAT;
    [self.circlesImageView.layer addAnimation:animation forKey:@"animateTransform"];
}

- (void)stopAnimate {
    self.circlesImageView.hidden = YES;
    [self.circlesImageView.layer removeAllAnimations];
}

#pragma mark - AVAudioRecorder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //录音结束
    if (flag) {
        [self nowPlayingRecordCurrentTime:0 duration:recorderDuration];
    }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    //录音编码错误
}

- (void)nowPlayingRecordCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    [self.progressButton setProgress:currentTime duration:duration];
}

#pragma mark - AVAudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self.timer invalidate];
        self.timer = nil;
        [self stopAnimate];
        self.playButton.selected = NO;
        [self nowPlayingRecordCurrentTime:0 duration:recorderDuration];
    }
}

#pragma mark - BTThemeListenerProtocol
- (void)BTThemeDidNeedUpdateStyle {
    [super BTThemeDidNeedUpdateStyle];
}

#pragma mark - setter
- (BTCircularProgressButton *)progressButton {
    if (!_progressButton) {
        _progressButton = [[BTCircularProgressButton alloc] initWithFrame:CGRectMake(0, 0, durationCircleSize, durationCircleSize)
                                                            progressColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_c"]
                                                                lineWidth:8.0f];
        _progressButton.userInteractionEnabled = NO;
    }
    return _progressButton;
}

- (UIButton *)recordIcon {
    if (!_recordIcon) {
        _recordIcon = [[UIButton alloc] init];
        [_recordIcon setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordIcon;
}

- (UIImageView *)circlesImageView {
    if (!_circlesImageView) {
        _circlesImageView = [[UIImageView alloc] init];
        _circlesImageView.hidden = NO;
        _circlesImageView.image = BT_LOADIMAGE(@"ic_circle1");
    }
    return _circlesImageView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        [_recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        [_recordButton setTitle:@"停止录音" forState:UIControlStateSelected];
        [_recordButton setBorderWithWidth:0 color:nil cornerRadius:5];
        _recordButton.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
    }
    return _recordButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitle:@"开始播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"停止播放" forState:UIControlStateSelected];
        _playButton.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
        [_playButton setBorderWithWidth:0 color:nil cornerRadius:5];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setBorderWithWidth:0 color:nil cornerRadius:5];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
    }
    return _saveButton;
}

- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setBorderWithWidth:0 color:nil cornerRadius:5];
        [_resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _resetButton.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
    }
    return _resetButton;
}

@end
