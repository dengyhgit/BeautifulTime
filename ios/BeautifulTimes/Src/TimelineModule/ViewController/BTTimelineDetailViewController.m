//
//  BTTimelineDetailViewController.m
//  BeautifulTimes
//
//  Created by 邓永豪 on 16/3/24.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDetailViewController.h"
#import "BTTimelineViewController.h"
#import "BTTimelineDBManager.h"
#import "BTTimelineToolView.h"
#import "BTIMEditUserInfoViewController.h"
#import "BTJournalController.h"
#import "BTIMNavViewController.h"
#import "BTSelectPhotosViewController.h"
#import "BTAddressBookViewController.h"
#import "BTTimelineViewController.h"
#import "YHPopupView.h"
#import <CoreLocation/CoreLocation.h>

@interface BTTimelineDetailViewController () <UIActionSheetDelegate, BTTimelineToolViewDelegate, CLLocationManagerDelegate, BTEditUserInfoViewDelegate, UIScrollViewDelegate> {
    BOOL isEditModel;
    
    NSMutableArray *_photoArray;
}

@property (nonatomic, strong) UIActionSheet * selectActionSheet;
@property (nonatomic, strong) BTTimelineToolView *toolView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *site;
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation BTTimelineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"时光轴详情";
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.toolView];
    [self.bodyView addSubview:self.contentTextView];
    self.bgImageView.image = BT_LOADIMAGE(@"com_bg_journal01_1242x2208");
    isEditModel = NO;
    
    [self loadData];
    
    [self addKeyboardObserver];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bodyView);
        make.right.equalTo(weakSelf.bodyView);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.bodyView);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 48, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadData {
    self.contentTextView.text = [[NSString alloc] initWithData:self.timeline.timelineContent encoding:NSUTF8StringEncoding];
    self.site.text = self.timeline.site;
    [BTJournalController sharedInstance].contacter = self.timeline.friends;
    
    NSString *documentDirectory = [BTTool getDocumentDirectory];
    NSString *photosPath = [documentDirectory stringByAppendingPathComponent:self.timeline.photos];
    NSData *photosData = [[NSData alloc] initWithContentsOfFile:photosPath];
    
    _photoArray = [NSKeyedUnarchiver unarchiveObjectWithData:photosData];
}

- (void)photosClick {
    
    if (_photoArray.count > 0) {
        YHPopupView *popupView = [[YHPopupView alloc] initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40)];
        popupView.clickBlankSpaceDismiss = YES;
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(BT_SCREEN_WIDTH / 2 - 15, BT_SCREEN_HEIGHT - 35, 30, 30)];
        [closeButton addTarget:self action:@selector(closePopupView) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setBackgroundImage:BT_LOADIMAGE(@"cm_close_white") forState:UIControlStateNormal];
        
        [popupView addSubview:closeButton];
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 40)];
        scrollView.pagingEnabled = YES;
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

#pragma mark - click event
- (void)backButtonClick {
    [[BTJournalController sharedInstance] resetAllParameters];
    [super backButtonClick];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTTimelineViewController class]]) {
            BTTimelineViewController *vc = (BTTimelineViewController *)controller;
            [vc reloadTimelineList];
        }
    }
}

- (void)removeKeyboardObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)addKeyboardObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

//开始定位
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
}

//检测是否支持定位
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
//    NSString *errorString;
    [manager stopUpdatingLocation];
//    switch([error code]) {
//        case kCLErrorDenied:
//            errorString = @"用户拒绝访问位置服务";
//            break;
//        case kCLErrorLocationUnknown:
//            errorString = @"位置数据不可用";
//            break;
//        default:
//            errorString = @"发生未知错误";
//            break;
//    }
    BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
    edit.delegate = self;
    edit.title = @"获取位置";
    edit.str = self.site.text;
    [self removeKeyboardObserver];
    BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
    [self presentViewController:nav animated:YES completion:nil];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
        edit.delegate = self;
        edit.title = @"获取位置";
        if (!error) {
            for (CLPlacemark * placemark in placemarks) {
                NSDictionary *info = [placemark addressDictionary];
                NSString *city = [info objectForKey:@"City"];
                NSString *country = [info objectForKey:@"Country"];
                edit.str = [NSString stringWithFormat:@"%@%@", country, city];;
            }
        }
        [self removeKeyboardObserver];
        BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    [self.locationManager stopUpdatingLocation];
}

#pragma mark 编辑控制器的代理方法
-(void)EditingFinshed:(BTIMEditUserInfoViewController *)edit indexPath:(NSIndexPath *)indexPath newInfo:(NSString *)newInfo
{
    self.site.text = newInfo;
    [self addKeyboardObserver];
}

#pragma timelineToolView delegate
- (void)timelineToolViewDidSelectAtCurrentSite {
    if (isEditModel) {
        [self.contentTextView resignFirstResponder];
        if (self.site.text) {
            BTIMEditUserInfoViewController *edit = [[BTIMEditUserInfoViewController alloc]init];
            edit.delegate = self;
            edit.title = @"获取位置";
            edit.str = self.site.text;
            [self removeKeyboardObserver];
            BTIMNavViewController *nav = [[BTIMNavViewController alloc] initWithRootViewController:edit];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            [MBProgressHUD showMessage:@"自动获取当前位置..." toView:self.view];
            [self startLocation];
        }
    } else {
        NSString *siteInfo;
        if (self.site.text) {
            siteInfo = [NSString stringWithFormat:@"我在%@", self.site.text];
        } else {
            siteInfo = @"无位置信息";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:siteInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)timelineToolViewDidSelectAtSelectPhotos {
    if (isEditModel) {
        [self.contentTextView resignFirstResponder];
        if (!([BTJournalController sharedInstance].photos.count > 0)) {
            [BTJournalController sharedInstance].photos = _photoArray;
        }
        BTSelectPhotosViewController *vc = [[BTSelectPhotosViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        [self photosClick];
    }
}

- (void)timelineToolViewDidSelectAtAddressBook {
    if (isEditModel) {
        [self.contentTextView resignFirstResponder];
        BTAddressBookViewController *vc = [[BTAddressBookViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        NSString *siteInfo;
        if (self.timeline.friends && ![self.timeline.friends isEqualToString:@""]) {
            siteInfo = [NSString stringWithFormat:@"我和%@", self.timeline.friends];
        } else {
            siteInfo = @"独自一人";
        }
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:siteInfo delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
}

#pragma mark keyboard delegate
- (void) keyboardWasShown:(NSNotification *) notif{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48 - keyboardSize.height)];
        [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48 - keyboardSize.height, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48)];
        [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.contentTextView.frame.size.height  + yOffset)];
        [self.toolView setFrame:CGRectMake(0, self.toolView.frame.origin.y + yOffset, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
    
}

- (void)finishButtonClick {
    if (isEditModel) {
        isEditModel = NO;
        
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
        self.timeline.photos = uid;
        
        UIImage *thumbImage = [BTJournalController sharedInstance].photos.firstObject;
        if (thumbImage) {
            NSData *thumbImageData = UIImageJPEGRepresentation(thumbImage, 0.3);
            NSString *thumbImageUid = [self getSaveFilePath];
            NSString *thumbImagePath = [documentDirectory stringByAppendingPathComponent:thumbImageUid];
            while (true) {
                if (![fileManager fileExistsAtPath:thumbImagePath]) {
                    break;
                } else {
                    thumbImageUid = [self getSaveFilePath];
                    thumbImagePath = [documentDirectory stringByAppendingPathComponent:thumbImageUid];
                }
            }
            [thumbImageData writeToFile:thumbImagePath atomically:YES];
            self.timeline.thumbImage = thumbImageUid;
        } else {
            self.timeline.thumbImage = nil;
        }
        
        self.timeline.timelineContent = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding];
        self.timeline.site = self.site.text;
        NSString *contacter = [BTJournalController sharedInstance].contacter;
        self.timeline.friends = contacter;
        [[BTTimelineDBManager sharedInstance] updateTimeline:self.timeline];
        [[BTJournalController sharedInstance] resetAllParameters];
        [self backButtonClick];
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"修改点滴"];
        [actionSheet addButtonWithTitle:@"删除点滴"];
        [actionSheet addButtonWithTitle:@"取消"];
        //设置取消按钮
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showFromRect:self.view.superview.bounds inView:self.view.superview animated:NO];
        
        if (self.selectActionSheet) {
            self.selectActionSheet = nil;
        }
        
        self.selectActionSheet = actionSheet;
    }
}

- (NSString *)getSaveFilePath {
    NSString *uid = [[NSUUID UUID] UUIDString];
    return uid;
}

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
            self.toolView.userInteractionEnabled = YES;
            self.contentTextView.editable = YES;
            [self.contentTextView becomeFirstResponder];
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
        [[BTTimelineDBManager sharedInstance] deleteTimelineWithId:[self.timeline.timelineId integerValue]];
        [self backButtonClick];
    }
}


- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

- (BTTimelineToolView *)toolView {
    if (!_toolView) {
        _toolView = [[BTTimelineToolView alloc] init];
        _toolView.delegate = self;
//        _toolView.userInteractionEnabled = NO;
    }
    return _toolView;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
        _contentTextView.backgroundColor = BT_CLEARCOLOR;
        [_contentTextView setFont:BT_FONTSIZE(18)];
        _contentTextView.editable = NO;
    }
    return _contentTextView;
}

- (UILabel *)site {
    if (!_site) {
        _site = [[UILabel alloc] init];
    }
    return _site;
}

@end
