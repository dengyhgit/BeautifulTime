//
//  ViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTHomePageViewController.h"
#import "BTThemeManager.h"
#import "BTRestPasswordViewController.h"
#import "BTUserLoginViewController.h"
#import "BTAddJournalViewController.h"
#import "BTMyAlbumViewController.h"
#import "BTTimelineViewController.h"
#import "BTAddTimelineViewController.h"
#import "BTUserCenterViewController.h"
#import "BTSettingViewController.h"
#import "BTJournalListViewController.h"
#import "BTUserLoginViewController.h"
#import "BTIMHomePageViewController.h"
#import "BTIMTabBarController.h"
#import "AppDelegate.h"

static const CGFloat BUTTONWIDTH = 48;

@interface BTHomePageViewController ()<BTThemeListenerProtocol>

@property (nonatomic, assign) BOOL themeInit;

@property (nonatomic, strong) UIButton *timeline;
@property (nonatomic, strong) UIButton *journals;
@property (nonatomic, strong) UIButton *album;
@property (nonatomic, strong) UIButton *chat;

@property (nonatomic, strong) UILabel *timelineLabel;
@property (nonatomic, strong) UILabel *journalsLabel;
@property (nonatomic, strong) UILabel *albumLabel;
@property (nonatomic, strong) UILabel *chatLabel;

@property (nonatomic, strong) UIButton *addJournal;
@property (nonatomic, strong) UIButton *addTimeline;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *setting;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeInit = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.timeline];
    [self.view addSubview:self.album];
    [self.view addSubview:self.journals];
    [self.view addSubview:self.chat];
    [self.view addSubview:self.addJournal];
    [self.view addSubview:self.addTimeline];
    [self.view addSubview:self.setting];
    
    [self.view addSubview:self.timelineLabel];
    [self.view addSubview:self.albumLabel];
    [self.view addSubview:self.journalsLabel];
    [self.view addSubview:self.chatLabel];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    CGFloat OFFSET = (BT_SCREEN_WIDTH - BUTTONWIDTH * 4) / 5;

    [self.setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view);
        make.width.mas_equalTo(@(48));
        make.height.equalTo(@(48));
        make.top.equalTo(weakSelf.view).offset(5);
    }];
    
    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.album.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.album);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.view).offset(-20);
    }];
    
    [self.timelineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.timeline);
        make.right.equalTo(weakSelf.timeline);
        make.top.equalTo(weakSelf.timeline).offset(48 - 5);
        make.height.equalTo(@(15));
    }];
    
    [self.album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeline.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.journals.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.journals);
        make.height.equalTo(weakSelf.timeline);
        make.bottom.equalTo(weakSelf.timeline);

    }];
    
    [self.albumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.album);
        make.right.equalTo(weakSelf.album);
        make.top.equalTo(weakSelf.album).offset(48 - 5);
        make.height.equalTo(@(15));
    }];
    
    [self.journals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.album.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.chat.mas_left).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.chat);
        make.height.equalTo(weakSelf.album);
        make.bottom.equalTo(weakSelf.album);

    }];
    
    [self.journalsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.journals);
        make.right.equalTo(weakSelf.journals);
        make.top.equalTo(weakSelf.journals).offset(48 - 5);
        make.height.equalTo(@(15));
    }];
    
    [self.chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.journals.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.view).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.timeline);
        make.height.equalTo(weakSelf.journals);
        make.bottom.equalTo(weakSelf.journals);

    }];
    
    [self.chatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.chat);
        make.right.equalTo(weakSelf.chat);
        make.top.equalTo(weakSelf.chat).offset(48 - 5);
        make.height.equalTo(@(15));
    }];
    
    [self.addJournal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(BT_SCREEN_WIDTH / 4);
        make.centerY.equalTo(weakSelf.view);
        make.height.equalTo(@(70));
        make.width.equalTo(@(70));
    }];
    
    [self.addTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-BT_SCREEN_WIDTH / 4);
        make.centerY.equalTo(weakSelf.addJournal).offset(70);
        make.height.equalTo(@(70));
        make.width.equalTo(@(70));
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.themeInit) {
        [self BTThemeDidNeedUpdateStyle];
        self.themeInit = NO;
    }
}

- (void)BTThemeDidNeedUpdateStyle {

    WS(weakSelf);
    //启动图片

    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_timeline" completionHandler:^(UIImage *image) {
        [weakSelf.timeline setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_timeline_press" completionHandler:^(UIImage *image) {
        [weakSelf.timeline setImage:image forState:UIControlStateHighlighted];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_journal" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_journal_press" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateHighlighted];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_chat" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_chat_press" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateHighlighted];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_album" completionHandler:^(UIImage *image) {
        [weakSelf.album setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_album_press" completionHandler:^(UIImage *image) {
        [weakSelf.album setImage:image forState:UIControlStateHighlighted];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"com_bl_home_setting" completionHandler:^(UIImage *image) {
        [weakSelf.setting setImage:image forState:UIControlStateNormal];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)addJournalClick {
    BTAddJournalViewController *vc = [[BTAddJournalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumClick {
    BTMyAlbumViewController *vc = [[BTMyAlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timelineClick {
    BTTimelineViewController *vc = [[BTTimelineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTimelineClick {
    BTAddTimelineViewController *vc = [[BTAddTimelineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)userCenterClick {
    BTUserCenterViewController *vc = [[BTUserCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)journalsClick {
    BTJournalListViewController *vc = [[BTJournalListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatClick {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:userID]) {
        BTIMTabBarController *tab = [[BTIMTabBarController alloc]init];
        [self.navigationController pushViewController:tab animated:YES];
//        [AppDelegate getInstance].window.rootViewController = tab;
    } else {
        BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)settingClick {
    BTSettingViewController *vc = [[BTSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)setting {
    if (!_setting) {
        _setting = [[UIButton alloc] init];
        _setting.hidden = YES;
        [_setting addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setting;
}

- (UIButton *)timeline {
    if (!_timeline) {
        _timeline = [[UIButton alloc] init];
        [_timeline addTarget:self action:@selector(timelineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeline;
}

- (UIButton *)album {
    if (!_album) {
        _album = [[UIButton alloc] init];
        [_album addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _album;
}

- (UIButton *)journals {
    if (!_journals) {
        _journals = [[UIButton alloc] init];
        [_journals addTarget:self action:@selector(journalsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _journals;
}

- (UIButton *)chat {
    if (!_chat) {
        _chat = [[UIButton alloc] init];
        [_chat addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chat;
}

- (UILabel *)timelineLabel {
    if (!_timelineLabel) {
        _timelineLabel = [[UILabel alloc] init];
        _timelineLabel.text = @"时光轴";
        [_timelineLabel setTextColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"]];
        _timelineLabel.textAlignment = NSTextAlignmentCenter;
        _timelineLabel.font = BT_FONTSIZE(12);
    }
    return _timelineLabel;
}

- (UILabel *)chatLabel {
    if (!_chatLabel) {
        _chatLabel = [[UILabel alloc] init];
        _chatLabel.text = @"私语";
        [_chatLabel setTextColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"]];
        _chatLabel.textAlignment = NSTextAlignmentCenter;
        _chatLabel.font = BT_FONTSIZE(12);
    }
    return _chatLabel;
}

- (UILabel *)albumLabel {
    if (!_albumLabel) {
        _albumLabel = [[UILabel alloc] init];
        _albumLabel.text = @"相册";
        [_albumLabel setTextColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"]];
        _albumLabel.textAlignment = NSTextAlignmentCenter;
        _albumLabel.font = BT_FONTSIZE(12);
    }
    return _albumLabel;
}

- (UILabel *)journalsLabel {
    if (!_journalsLabel) {
        _journalsLabel = [[UILabel alloc] init];
        _journalsLabel.text = @"日记集";
        [_journalsLabel setTextColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"]];
        _journalsLabel.textAlignment = NSTextAlignmentCenter;
        _journalsLabel.font = BT_FONTSIZE(12);
    }
    return _journalsLabel;
}

- (UIButton *)addJournal {
    if (!_addJournal) {
        _addJournal = [[UIButton alloc] init];
        [_addJournal setTitle:@"记日记" forState:UIControlStateNormal];
        _addJournal.titleLabel.font = BT_FONTSIZE(15);
        [_addJournal setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_addJournal setBackgroundImage:BT_LOADIMAGE(@"com_ic_addJournal") forState:UIControlStateNormal];
        [_addJournal addTarget:self action:@selector(addJournalClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addJournal;
}

- (UIButton *)addTimeline {
    if (!_addTimeline) {
        _addTimeline = [[UIButton alloc] init];
        [_addTimeline setTitle:@"记点滴" forState:UIControlStateNormal];
        _addTimeline.titleLabel.font = BT_FONTSIZE(15);
        [_addTimeline setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_addTimeline setBackgroundImage:BT_LOADIMAGE(@"com_ic_timeline") forState:UIControlStateNormal];
        [_addTimeline addTarget:self action:@selector(addTimelineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTimeline;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        
        if (BT_47INCH_SCREEN) {
            _backgroundImageView.image = [[BTThemeManager getInstance] loadImageInBlueThemeWithName:@"ic_bg_main_1242x2208"];
        }
        else if (BT_55INCH_SCREEN) {
            _backgroundImageView.image = [[BTThemeManager getInstance] loadImageInBlueThemeWithName:@"ic_bg_main_750x1334"];
        }
        else {
            _backgroundImageView.image = [[BTThemeManager getInstance] loadImageInBlueThemeWithName:@"ic_bg_main_640x960"];
        }
        
    }
    return _backgroundImageView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}

@end
