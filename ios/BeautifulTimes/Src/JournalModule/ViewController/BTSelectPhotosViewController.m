//
//  BTSelectPhotosViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTSelectPhotosViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BTChoosePhotosItem.h"
#import "BTMyAlbumViewController.h"
#import "BTJournalController.h"
#import "BTAddJournalViewController.h"
#import "BTAddTimelineViewController.h"
#import "BTTimelineViewController.h"
#import "BTTimelineDetailViewController.h"
#import "BTEditJournalViewController.h"

static  NSString *kcellIdentifier = @"kSelectPhotosCollectionCellID";
static int const showNumber = 3;
static CGFloat const OFFSET = 15.0f;

@interface BTSelectPhotosViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, BTChoosePhotoDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, copy) NSString *chosenMediaType;
@property (nonatomic, strong) UIButton *usePhoto;
@property (nonatomic, strong) UIButton *useCamera;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation BTSelectPhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"添加照片";
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.collectionView];
    [self.bodyView addSubview:self.usePhoto];
    [self.bodyView addSubview:self.useCamera];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(weakSelf);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bodyView).offset(5);
        make.right.equalTo(weakSelf.bodyView).offset(-5);
        make.top.equalTo(weakSelf.bodyView).offset(5);
        make.height.equalTo(@(BT_ViewHeight(weakSelf.bodyView) / 2));
    }];
    
    [self.usePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(48));
        make.centerY.equalTo(weakSelf.bodyView).offset(44);
        make.left.equalTo(weakSelf.bodyView).offset(20);
        make.right.equalTo(weakSelf.bodyView).offset(-20);
    }];
    
    [self.useCamera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(weakSelf.usePhoto);
        make.centerY.equalTo(weakSelf.usePhoto).offset(44 + 22);
        make.left.equalTo(weakSelf.bodyView).offset(20);
        make.right.equalTo(weakSelf.bodyView).offset(-20);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView registerClass:[BTChoosePhotosItem class] forCellWithReuseIdentifier:kcellIdentifier];
    self.dataSource = [[BTJournalController sharedInstance] photos];
    [self.collectionView reloadData];
    [self checkButtonStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)checkButtonStatus {
    if ([BTJournalController sharedInstance].photos.count == 0) {
        self.finishButton.hidden = YES;
    } else {
        self.finishButton.hidden = NO;
    }
    if ([BTJournalController sharedInstance].photos.count == 6) {
        self.usePhoto.enabled = NO;
        self.useCamera.enabled = NO;
    } else {
        self.usePhoto.enabled = YES;
        self.useCamera.enabled = YES;
    }
}

- (void)cancelChoosePhoto {
    self.dataSource = [BTJournalController sharedInstance].photos;
    [self.collectionView reloadData];
    [self checkButtonStatus];
}

- (void)finishButtonClick {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTAddJournalViewController class]]) {
            BTAddJournalViewController *vc = (BTAddJournalViewController *)controller;
            if ([BTJournalController sharedInstance].photos.count > 0) {
                vc.photos.image = [BTJournalController sharedInstance].photos[0];
            }
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[BTEditJournalViewController class]]) {
            BTEditJournalViewController *vc = (BTEditJournalViewController *)controller;
            if ([BTJournalController sharedInstance].photos.count > 0) {
                vc.photos.image = [BTJournalController sharedInstance].photos[0];
            }
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        
        if ([controller isKindOfClass:[BTAddTimelineViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
        if ([controller isKindOfClass:[BTTimelineDetailViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
            return;
        }
    }
}

- (void)usePhotoClick {
    BTMyAlbumViewController *vc = [[BTMyAlbumViewController alloc] init];
    vc.isSelectModel = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)useCameraClick {
//    [self selectExistingPictureOrVideo];
    [self shootPiicturePrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeImage]){
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:[BTJournalController sharedInstance].photos];
        [ary addObject:chosenImage];
        [BTJournalController sharedInstance].photos = ary;
    }
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeMovie]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadData];
    }];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.picker.mediaTypes = mediatypes;
        self.picker.sourceType = sourceType;
        NSString *requiredmediatype = (NSString *)kUTTypeImage;
        NSArray *arrmediatypes = [NSArray arrayWithObject:requiredmediatype];
        [self.picker setMediaTypes:arrmediatypes];
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    if (self.dataSource.count % showNumber == 0) {
//        return self.dataSource.count / showNumber;
//    }
//    
//    return self.dataSource.count / showNumber + 1;
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    if (self.dataSource.count % showNumber != 0) {
//        if (section == self.dataSource.count / showNumber) {
//            return self.dataSource.count % showNumber;
//        }
//    }
//    
    return showNumber;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = (BT_SCREEN_WIDTH - OFFSET * (showNumber + 1) - 10) / showNumber;
    return CGSizeMake(itemWidth, itemWidth + OFFSET);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTChoosePhotosItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    long index = indexPath.section * showNumber + indexPath.row;
    cell.tag = index;
    if (self.dataSource.count > index) {
        if (self.dataSource[index]) {
           [cell bindData:self.dataSource[index] isShowColseButton:YES];
        }
    } else {
        [cell bindData:BT_LOADIMAGE(@"com_ic_addPhoto@3x") isShowColseButton:NO];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//定义UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

-(UIButton *)usePhoto {
    if (!_usePhoto) {
        _usePhoto = [[UIButton alloc] init];
        [_usePhoto setTitle:@"从相册中选择" forState:UIControlStateNormal];
        _usePhoto.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
        [_usePhoto setBorderWithWidth:0 color:nil cornerRadius:5];
        [_usePhoto addTarget:self action:@selector(usePhotoClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _usePhoto;
}

-(UIButton *)useCamera {
    if (!_useCamera) {
        _useCamera = [[UIButton alloc] init];
        [_useCamera setTitle:@"拍照" forState:UIControlStateNormal];
        _useCamera.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"];
        [_useCamera setBorderWithWidth:0 color:nil cornerRadius:5];
        [_useCamera addTarget:self action:@selector(useCameraClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _useCamera;
}

@end
