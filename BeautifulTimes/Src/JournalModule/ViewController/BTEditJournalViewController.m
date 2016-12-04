//
//  BTEditJournalViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTEditJournalViewController.h"
#import "BTCalendarView.h"
#import "BTWeatherStatusVeiw.h"
#import "UIView+BTAddition.h"
#import "BTWeatherModel.h"
#import "AppDelegate.h"
#import "BTJournalListViewController.h"
#import "BTCircularProgressButton.h"
#import <AVFoundation/AVFoundation.h>
#import "YHPopupView.h"
#import "BTSelectPhotosViewController.h"
#import "BTJournalController.h"
#import "BTRecordViewController.h"

static const CGFloat itemWidth = 70.0f;

@interface BTEditJournalViewController () <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate, UIScrollViewDelegate> {
    AVAudioPlayer *_player;
    AVAudioSession *_audioSession;
    BOOL isEditModel;
    
    NSMutableArray *_photoArray;
//    NSString *_jornalRecordPath;
}

@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) BTWeatherStatusVeiw *weatherStatusView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) UIActionSheet * selectActionSheet;
@property (nonatomic, strong) BTCircularProgressButton *progressButton; /**< 进度环 */
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BTEditJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"编辑日记";
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    [self loadJournalData];
    
    [self.view addSubview:self.toolsView];
    [self.toolsView addSubview:self.calendarView];
    [self.toolsView addSubview:self.weatherStatusView];
    [self.toolsView addSubview:self.photos];
    [self.toolsView addSubview:self.progressButton];
    [self.toolsView addSubview:self.playButton];
    [self.toolsView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
    _audioSession = [AVAudioSession sharedInstance];
    isEditModel = NO;
    self.bgImageView.image = BT_LOADIMAGE(@"com_bg_journal01_1242x2208");
    [self addImageViewGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat OFFSET = 10.0f;
    WS(weakSelf);
    [self.toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(5);
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@(80));
    }];
    CGFloat offset = (BT_SCREEN_WIDTH - 20 - itemWidth * 4) / 5;
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.toolsView).offset(offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.weatherStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.calendarView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.weatherStatusView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(80 + OFFSET / 2);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(80 + OFFSET / 2);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (isEditModel) {
        if ([BTJournalController sharedInstance].record && ![[BTJournalController sharedInstance].record isEqualToString:@""]) {
            [self.records setHidden:YES];
            [self.progressButton setHidden:NO];
            [self.playButton setHidden:NO];
        } else {
            [self.records setHidden:NO];
            [self.progressButton setHidden:YES];
            [self.playButton setHidden:YES];
        }
    } else {
        if (self.journal.records == nil || [self.journal.records isEqualToString:@""]) {
            [self.records setHidden:NO];
            [self.progressButton setHidden:YES];
            [self.playButton setHidden:YES];
        } else {
            [self.records setHidden:YES];
            [self.progressButton setHidden:NO];
            [self.playButton setHidden:NO];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadJournalData {
    NSString *documentDirectory = [BTTool getDocumentDirectory];
    NSString *photosPath = [documentDirectory stringByAppendingPathComponent:self.journal.photos];
    NSData *photosData = [[NSData alloc] initWithContentsOfFile:photosPath];
    
    if (photosData) {
        NSArray *photos = [NSKeyedUnarchiver unarchiveObjectWithData:photosData];
        _photoArray = [[NSMutableArray alloc] initWithArray:photos];
    }
}

#pragma mark 添加手势识别器
-(void)addImageViewGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photosClick)];
    tap.numberOfTapsRequired = 1;
    [self.photos addGestureRecognizer:tap];
}

- (void)photosClick {
    
    
    if (isEditModel) {
        [self.content resignFirstResponder];
        BTSelectPhotosViewController *vc = [[BTSelectPhotosViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (_photoArray.count > 0) {
        YHPopupView *popupView = [[YHPopupView alloc] initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40)];
        popupView.clickBlankSpaceDismiss = YES;
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(BT_SCREEN_WIDTH / 2 - 15, BT_SCREEN_HEIGHT - 35, 30, 30)];
        [closeButton addTarget:self action:@selector(closePopupView) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setBackgroundImage:BT_LOADIMAGE(@"cm_close_white") forState:UIControlStateNormal];
        
        [popupView addSubview:closeButton];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40)];
        scrollView.pagingEnabled = YES;
        scrollView.userInteractionEnabled = YES;
        scrollView.showsHorizontalScrollIndicator = NO;
        
        scrollView.contentSize = CGSizeMake(_photoArray.count * BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40);
        scrollView.delegate = self;
        scrollView.contentOffset = CGPointMake(0, 0);
        
        for (int i = 0; i < _photoArray.count; i++) {
            UIImageView *imgView = [[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            NSInteger x = i * BT_SCREEN_WIDTH;
            [imgView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40)];
            imgView.image = _photoArray[i];
            [scrollView addSubview:imgView];
        }
        [popupView addSubview:scrollView];
        [self presentPopupView:popupView];
    }
    
}

- (void)closePopupView {
    [self dismissPopupView];
}

- (void)backButtonClick {
    [super backButtonClick];
    
    if (isEditModel) {
        self.journal.records = [BTJournalController sharedInstance].record;
        [[AppDelegate getInstance].coreDataHelper saveContext];
    }
    
    [[BTJournalController sharedInstance] resetAllParameters];
    if (_player.isPlaying) {
        [_player stop];
        [_audioSession setActive:NO error:nil];
    }
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTJournalListViewController class]]) {
            BTJournalListViewController *vc = (BTJournalListViewController *)controller;
            [vc initDataSource];
            [vc.tableView reloadData];
        }
    }
}

- (void)finishButtonClick {
    if (!isEditModel) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"修改日记"];
        [actionSheet addButtonWithTitle:@"删除日记"];
        [actionSheet addButtonWithTitle:@"取消"];
        //设置取消按钮
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showFromRect:self.view.superview.bounds inView:self.view.superview animated:NO];
        
        if (self.selectActionSheet) {
            self.selectActionSheet = nil;
        }
        
        self.selectActionSheet = actionSheet;

    } else {
        isEditModel = NO;
        [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.content.editable = NO;
        NSData* data = [self.content.text dataUsingEncoding:NSUTF8StringEncoding];
        self.journal.journalContent = data;
        
        NSData *photosData = [NSKeyedArchiver archivedDataWithRootObject:[BTJournalController sharedInstance].photos];
        NSString *documentDirectory = [BTTool getDocumentDirectory];
        //唯一标识的id
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
        [photosData writeToFile:savePath atomically:YES];
        [fileManager removeItemAtPath:[documentDirectory stringByAppendingPathComponent:self.journal.photos] error:nil];
        self.journal.photos = uid;
        
        UIImage *avator = [BTJournalController sharedInstance].photos.firstObject;
        if (avator) {
            NSData *avatorData = UIImageJPEGRepresentation(avator, 0.3);
            NSString *avatorUid = [self getSaveFilePath];
            NSString *avatorPath = [documentDirectory stringByAppendingPathComponent:avatorUid];
            while (true) {
                if (![fileManager fileExistsAtPath:avatorPath]) {
                    break;
                } else {
                    avatorUid = [self getSaveFilePath];
                    avatorPath = [documentDirectory stringByAppendingPathComponent:avatorUid];
                }
            }
            [avatorData writeToFile:avatorPath atomically:YES];
            self.journal.avator = avatorUid;
        } else {
            self.journal.avator = nil;
        }
        
//        NSLog(@"1-----------%@", self.journal.records);
//        NSLog(@"2-----------%@",[BTJournalController sharedInstance].record);
        
        if (![self.journal.records isEqualToString:[BTJournalController sharedInstance].record]) {
            if (self.journal.records && ![self.journal.records isEqualToString:@""]) {
                [fileManager removeItemAtPath:[documentDirectory stringByAppendingPathComponent:self.journal.records] error:nil];
            }
            self.journal.records = [BTJournalController sharedInstance].record;
            _player = nil;
        }
        
//        if ([BTJournalController sharedInstance].record && ![[BTJournalController sharedInstance].record isEqualToString:@""]) {
//            [self.records setHidden:NO];
//            [self.progressButton setHidden:YES];
//            [self.playButton setHidden:YES];
//        }
//        
        //保存数据库
        [[AppDelegate getInstance].coreDataHelper saveContext];
        [[BTJournalController sharedInstance] resetAllParameters];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateJournalInfo object:nil];
        [self loadJournalData];
    }
}

- (NSString *)getSaveFilePath {
    NSString *uid = [[NSUUID UUID] UUIDString];
    return uid;
}

- (void)playButtonClick:(UIButton *)sender {
    if (isEditModel) {
        [self.content resignFirstResponder];
//        [BTJournalController sharedInstance].record = self.journal.records;
        BTRecordViewController *vc = [[BTRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (!self.playButton.selected) {
            self.playButton.selected = YES;
            [self playRecord];
        }
        else {
            self.playButton.selected = NO;
            [self stopPlay];
        }
    }
}

- (void)playRecord {
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_audioSession setActive:YES error:nil];
    if (self.journal.records){
        if (!_player) {
            NSString *documentDirectory = [BTTool getDocumentDirectory];
            NSString *recordPath = [documentDirectory stringByAppendingPathComponent:self.journal.records];
            NSData *recordData = [[NSData alloc] initWithContentsOfFile:recordPath];
            _player = [[AVAudioPlayer alloc] initWithData:recordData error:nil];
            _player.delegate = self;
            _player.volume = 1;
        }
        [_player prepareToPlay];
        [_player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playProgressTime:) userInfo:nil repeats:YES];
    }
}

- (void)stopPlay {
    [_player stop];
    _player.currentTime = 0.0f;
    [self.timer invalidate];
    self.timer = nil;
    [self nowPlayingRecordCurrentTime:0 duration:_player.duration];
    [_audioSession setActive:NO error:nil];
}

- (void)playProgressTime:(NSTimer *)timer {
    [self nowPlayingRecordCurrentTime:_player.currentTime duration:_player.duration];
}

- (void)nowPlayingRecordCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    [self.progressButton setProgress:currentTime duration:duration];
}

#pragma mark - AVAudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self.timer invalidate];
        self.timer = nil;
        self.playButton.selected = NO;
        [self nowPlayingRecordCurrentTime:0 duration:player.duration];
        [_audioSession setActive:NO error:nil];
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            isEditModel = YES;
            [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
            [BTJournalController sharedInstance].record = self.journal.records;
            [BTJournalController sharedInstance].photos = _photoArray;
            self.content.editable = YES;
            if ([_player isPlaying]) {
                self.playButton.selected = NO;
                [self stopPlay];
            }
            [self.content becomeFirstResponder];
        }
            break;
            
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        [[AppDelegate getInstance].coreDataHelper.context deleteObject:self.journal];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[BTJournalListViewController class]]) {
                BTJournalListViewController *vc = (BTJournalListViewController *)controller;
                [vc initDataSource];
                [vc.tableView reloadData];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}


- (void)recordsClick {
    if (isEditModel) {
        BTRecordViewController *vc = [[BTRecordViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (UIView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[UIView alloc] init];
        _toolsView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_press_e"] ;
        [_toolsView setBorderWithWidth:1 color:nil cornerRadius:8];
    }
    return _toolsView;
}

- (BTCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[BTCalendarView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        [_calendarView bindData:self.journal.journalDate];
    }
    return _calendarView;
}

- (BTWeatherStatusVeiw *)weatherStatusView {
    if (!_weatherStatusView) {
        _weatherStatusView = [[BTWeatherStatusVeiw alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        if (self.journal.weather) {
            BTWeatherModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:self.journal.weather];
            [_weatherStatusView bindData:model];
        }
    }
    return _weatherStatusView;
}

- (UIScrollView *)bodyScrollView {
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] init];
        _bodyScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH - 20, BT_SCREEN_HEIGHT);
        _bodyScrollView.backgroundColor = [UIColor clearColor];
    }
    return _bodyScrollView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.delegate = self;
        _content.editable = NO;
        [_content setFont:BT_FONTSIZE(18)];
        _content.backgroundColor = [UIColor clearColor];
        if (self.journal.journalContent) {
            NSString *content = [[NSString alloc] initWithData:self.journal.journalContent encoding:NSUTF8StringEncoding];
            _content.text = content;
        }
    }
    return _content;
}

- (UIImageView *)photos {
    if (!_photos) {
        _photos = [[UIImageView alloc] init];
        [_photos setImage:BT_LOADIMAGE(@"com_ic_photo")];
        [_photos setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        _photos.userInteractionEnabled = YES;
        _photos.image = _photoArray.firstObject;
    }
    return _photos;
}

- (UIButton *)records {
    if (!_records) {
        _records = [[UIButton alloc] init];
        [_records setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        [_records setImage:BT_LOADIMAGE(@"com_ic_voice") forState:UIControlStateNormal];
        [_records addTarget:self action:@selector(recordsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _records;
}


- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

- (BTCircularProgressButton *)progressButton {
    if (!_progressButton) {
        _progressButton = [[BTCircularProgressButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)
                                                            progressColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_c"]
                                                                lineWidth:4.0f];
        _progressButton.userInteractionEnabled = NO;
        [_progressButton setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];

    }
    return _progressButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setBackgroundImage:BT_LOADIMAGE(@"cm_pause_white") forState:UIControlStateSelected];
        [_playButton setBackgroundImage:BT_LOADIMAGE(@"cm_play_white") forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
