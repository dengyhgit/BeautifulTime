//
//  BTPhotoListViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoListViewController.h"
#import "BTPhotoCollectionViewCell.h"
#import "BTPhotoDetailsViewController.h"
#import "BTJournalController.h"
#import "BTSelectPhotosViewController.h"
#import "UICollectionView+Addition.h"
#import "BTMyAlbumViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

static  NSString *kcellIdentifier = @"kPhotoCollectionCellID";
static int const showNumber = 3;
static CGSize AssetGridThumbnailSize;

@interface BTPhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver, UIActionSheetDelegate, UIAlertViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    long photosNumber;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *flageArray;
@property (nonatomic, strong) NSMutableDictionary *photoSource;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;
@property (nonatomic, strong) UIActionSheet * selectActionSheet;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, copy) NSString *chosenMediaType;
@property CGRect previousPreheatRect;

@end

@implementation BTPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    photosNumber = [BTJournalController sharedInstance].photos.count;
    self.titleLabel.text = @"相册详情";
    self.finishButton.hidden = NO;
    if (self.isSelectModel) {
        [self.finishButton setTitle:@"选择" forState:UIControlStateNormal];
    } else {
        [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    [self.bodyView addSubview:self.collectionView];
    [self resetCachedAssets];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView registerClass:[BTPhotoCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
//    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake((BT_SCREEN_WIDTH / showNumber * 1.5), (BT_SCREEN_WIDTH / showNumber * 1.5));
    
    if (self.isSelectModel) {
        AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH , BT_SCREEN_WIDTH);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // Begin caching assets in and around collection view's visible rect.
    [self updateCachedAssets];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - Asset Caching

- (void)resetCachedAssets {
    [self.imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self isViewLoaded] && [[self view] window] != nil;
    if (!isViewVisible) {
        return;
    }
    
    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.collectionView.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));
    
    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.collectionView.bounds) / 3.0f) {
        
        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [self.collectionView aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];
        
        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];
        
        // Update the assets the PHCachingImageManager is caching.
        [self.imageManager startCachingImagesForAssets:assetsToStartCaching
                                            targetSize:AssetGridThumbnailSize
                                           contentMode:PHImageContentModeAspectFill
                                               options:self.options];
        [self.imageManager stopCachingImagesForAssets:assetsToStopCaching
                                           targetSize:AssetGridThumbnailSize
                                          contentMode:PHImageContentModeAspectFill
                                              options:self.options];
        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);
        
        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }
        
        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }
        
        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }
        
        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) {
        return nil;
    }
    
    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.fetchResult[indexPath.item];
        [assets addObject:asset];
    }
    
    return assets;
}


- (void)finishButtonClick {
    if (self.isSelectModel) {
        NSMutableArray *ary = [[NSMutableArray alloc] initWithArray:[BTJournalController sharedInstance].photos];
        [ary addObjectsFromArray:[self sortDictionaryByAsc:self.photoSource]];
        [[BTJournalController sharedInstance] setPhotos:ary];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[BTSelectPhotosViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
    //delete album
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"添加照片"];
        [actionSheet addButtonWithTitle:@"删除相册"];
        [actionSheet addButtonWithTitle:@"修改相册名称"];
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
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"选择来源" message:@"请选择添加照片的来源" delegate:self cancelButtonTitle:@"取消选择" otherButtonTitles:@"从相册选择", @"拍照", nil];
            [alertView show];
            
        }
            break;
            
        case 1:
        {
            [MBProgressHUD showMessage:@"删除中..." toView:self.view];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                if (!self.assetCollection) {
                    [PHAssetCollectionChangeRequest deleteAssetCollections:self.fetchResult];
                } else {
                    NSArray *arry = @[self.assetCollection];
                    [PHAssetCollectionChangeRequest deleteAssetCollections:arry];
                }
            } completionHandler:^(BOOL success, NSError *error) {
                if (success) {
                    //loading框
                    [self backButtonClick];
                } else {
                    //删除失败
                }
            }];
        }
            break;
        case 2:
        {
            if (self.assetCollection) {
                UIAlertView *alerView =[[UIAlertView alloc] initWithTitle:@"修改相册名称"
                                                                  message:@"输入相册名称!"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                        otherButtonTitles:@"确定", nil];
                alerView.alertViewStyle = UIAlertViewStylePlainTextInput;
                alerView.tag = 20011;
                [alerView show];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 20011) {
        if (buttonIndex == 1) {
            [[alertView textFieldAtIndex:0] resignFirstResponder];
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection];
                assetCollectionChangeRequest.title = [alertView textFieldAtIndex:0].text;
            } completionHandler:^(BOOL success, NSError * _Nullable error) {
                
            }];
        }
        return;
    }
    if (buttonIndex == 1){
        [self selectExistingPictureOrVideo];
    } else {
        [self shootPiicturePrVideo];
    }
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
        // Add it to the photo library
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            PHAssetChangeRequest *assetChangeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:chosenImage];
            
            if (self.assetCollection) {
                PHAssetCollectionChangeRequest *assetCollectionChangeRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:self.assetCollection];
                [assetCollectionChangeRequest addAssets:@[[assetChangeRequest placeholderForCreatedAsset]]];
            }
        } completionHandler:^(BOOL success, NSError *error) {
            if (!success) {
                NSLog(@"Error creating asset: %@", error);
            }
        }];
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

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.fetchResult];
    
    if (collectionChanges == nil) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.fetchResult = [collectionChanges fetchResultAfterChanges];
        UICollectionView *collectionView = self.collectionView;
        [collectionView reloadData];
        [self resetCachedAssets];
    });
}

#pragma mark - UICollectionView delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.fetchResult.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = BT_SCREEN_WIDTH / showNumber;
    CGFloat height = width;
    
    return CGSizeMake(width, height);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PHAsset *asset = self.fetchResult[indexPath.item];
    
    BTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
   
    cell.representedAssetIdentifier = asset.localIdentifier;
    cell.thumbnailImage = nil;
    long index = indexPath.row;
    NSString *str = [self.flageArray valueForKey:[[NSString alloc] initWithFormat:@"%ld",index]];
    if ([str isEqualToString:@"YES"]) {
        cell.isSelect.hidden = NO;
    } else {
        cell.isSelect.hidden = YES;
    }
    
    [self.imageManager requestImageForAsset:self.fetchResult[index]
                                 targetSize:AssetGridThumbnailSize
                                contentMode:PHImageContentModeAspectFill
                                    options:self.options
                              resultHandler:^(UIImage *result, NSDictionary *info) {
                                  if ([cell.representedAssetIdentifier isEqualToString:asset.localIdentifier]) {
                                      cell.thumbnailImage = result;
                                  }
                              }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    long index = indexPath.section * showNumber + indexPath.row;
    if (self.isSelectModel) {
        BTPhotoCollectionViewCell *cell = (BTPhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (cell.isSelect.hidden && photosNumber < 6) {
            cell.isSelect.hidden = NO;
            [self.flageArray setValue:@"YES" forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
            [self.photoSource setValue:cell.thumbnailImage forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
            photosNumber++;
        } else {
            if (photosNumber == 6 && cell.isSelect.hidden) {
                return;
            }
            cell.isSelect.hidden = YES;
            [self.flageArray setValue:@"NO" forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
            [self.photoSource removeObjectForKey:[[NSString alloc] initWithFormat:@"%ld",index]];
            photosNumber--;
        }
        
    } else {
        BTPhotoDetailsViewController *vc = [[BTPhotoDetailsViewController alloc] init];
        vc.assets = self.fetchResult;
        vc.index = indexPath.section * showNumber + indexPath.row;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//定义UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    [self updateCachedAssets];
}

- (NSArray *)sortDictionaryByAsc:(NSDictionary *)dict {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *keys = [dict allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    for (NSString *categoryId in sortedArray) {
        [array addObject:[dict objectForKey:categoryId]];
    }
    return array;
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

- (NSMutableDictionary *)flageArray {
    if (!_flageArray) {
        _flageArray = [[NSMutableDictionary alloc] init];
    }
    return _flageArray;
}

- (NSMutableDictionary *)photoSource {
    if (!_photoSource) {
        _photoSource = [[NSMutableDictionary alloc] init];
    }
    return _photoSource;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

-(PHImageRequestOptions *)options {
    if (!_options) {
        _options = [[PHImageRequestOptions alloc] init];
        _options.resizeMode = PHImageRequestOptionsResizeModeExact;
        _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    return _options;
}

- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
}

@end
