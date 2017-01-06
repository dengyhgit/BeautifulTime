//
//  BTMyAlbumViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/17.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTMyAlbumViewController.h"
#import "BTAlbumCollectionViewCell.h"
#import <Photos/Photos.h>
#import "BTPhotoListViewController.h"
#import "BTAddAlbumViewController.h"

static  NSString *kcellIdentifier = @"kAlbumCollectionCellID";
static int const showNumber = 2;
static CGFloat const cellHeight = 164.0f;
static CGSize AssetGridThumbnailSize;
static CGFloat const iconWidth = 120.0f;
static CGFloat const iconHeight = 120.0f;

@interface BTMyAlbumViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSArray *sectionFetchResults;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;

@end

@implementation BTMyAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.isSelectModel) {
        [self.finishButton setHidden:NO];
        [self.finishButton setTitle:@"添加" forState:UIControlStateNormal];
    }
    self.titleLabel.text = @"我的相册";
    [self initDataSource];
    [self.bodyView addSubview:self.collectionView];
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView registerClass:[BTAlbumCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
//    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(iconWidth * 1.5, iconHeight * 1.5);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

- (void)finishButtonClick {
    BTAddAlbumViewController *vc = [[BTAddAlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableArray *updatedSectionFetchResults = [self.sectionFetchResults mutableCopy];
        __block BOOL reloadRequired = NO;
        
        [self.sectionFetchResults enumerateObjectsUsingBlock:^(PHFetchResult *collectionsFetchResult, NSUInteger index, BOOL *stop) {
            PHFetchResultChangeDetails *changeDetails = [changeInstance changeDetailsForFetchResult:collectionsFetchResult];
            
            if (changeDetails != nil) {
                [updatedSectionFetchResults replaceObjectAtIndex:index withObject:[changeDetails fetchResultAfterChanges]];
                reloadRequired = YES;
            }
        }];
        
        if (reloadRequired) {
            self.sectionFetchResults = updatedSectionFetchResults;
            [self initDataSource];
            [self.collectionView reloadData];
        }
        
    });
}

- (void)initDataSource {
    [self.dataSource removeAllObjects];
    PHFetchOptions *allPhotosOptions = [[PHFetchOptions alloc] init];
    allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *allPhotos = [PHAsset fetchAssetsWithOptions:allPhotosOptions];
    
//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.sectionFetchResults = @[allPhotos, topLevelUserCollections];
    
    for (int i = 0; i < self.sectionFetchResults.count; i++) {
        
        if (i == 0) {
            [self.dataSource addObject:self.sectionFetchResults[i]];
        }
        else {
            for (PHFetchResult *result in self.sectionFetchResults[i]) {
                PHAssetCollection *assetCollection = (PHAssetCollection *)result;
                
                if ([assetCollection isKindOfClass:[PHAssetCollection class]]) {
                    
//                    PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
//                    if (assetsFetchResult.count > 0) {
//                        [self.dataSource addObject:result];
//                    }
//                    NSLog(@"--------%@", assetCollection.localizedTitle);
                    [self.dataSource addObject:result];
                }
    
            }
        }
    }
}

#pragma mark - UICollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.dataSource.count % showNumber == 0) {
        return self.dataSource.count / showNumber;
    }
    return self.dataSource.count / showNumber + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.dataSource.count % showNumber != 0) {
        if (section == self.dataSource.count / showNumber) {
            return self.dataSource.count % showNumber;
        }
    }
    return showNumber;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = BT_SCREEN_WIDTH / showNumber;
    CGFloat height = cellHeight;
    return CGSizeMake(width, height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTAlbumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    PHCollection *collection = self.dataSource[indexPath.section * showNumber + indexPath.row];
    
//    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
//    
//    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
//
//    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    if (indexPath.section == 0 && indexPath.row == 0) {
        
         PHFetchResult *result = self.dataSource[indexPath.section * showNumber + indexPath.row];
        if (result.count > 0) {
            PHAsset *asset = self.dataSource[indexPath.section * showNumber + indexPath.row][0];
            
//            [imageManager requestImageForAsset:asset
//                                    targetSize:AssetGridThumbnailSize
//                                   contentMode:PHImageContentModeAspectFill
//                                       options:options
//                                 resultHandler:^(UIImage *result, NSDictionary *info) {
//                                     
//                                     [cell bindData:@"所有照片" icon:result];
//                                     
//                                 }];
            
            [self.imageManager requestImageForAsset:asset
                                         targetSize:AssetGridThumbnailSize
                                        contentMode:PHImageContentModeAspectFill
                                            options:self.options
                                      resultHandler:^(UIImage *result, NSDictionary *info) {
                                          [cell bindData:@"所有照片" icon:result];
                                      }];
        }
    }
    else {
        
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        
        if ([assetCollection isKindOfClass:[PHAssetCollection class]]) {
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            if (assetsFetchResult.count > 0) {
                PHAsset *asset = assetsFetchResult[0];
                
//                [imageManager requestImageForAsset:asset
//                                        targetSize:AssetGridThumbnailSize
//                                       contentMode:PHImageContentModeAspectFill
//                                           options:options
//                                     resultHandler:^(UIImage *result, NSDictionary *info) {
//                                         
//                                         [cell bindData:collection.localizedTitle icon:result];
//                                         
//                                     }];
                [self.imageManager requestImageForAsset:asset
                                             targetSize:AssetGridThumbnailSize
                                            contentMode:PHImageContentModeAspectFill
                                                options:self.options
                                          resultHandler:^(UIImage *result, NSDictionary *info) {
                                              [cell bindData:collection.localizedTitle icon:result];
                                          }];
            }
            else {
                [cell bindData:collection.localizedTitle icon:BT_LOADIMAGE(@"com_ic_addPhoto@3x")];
            }
        }
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTPhotoListViewController *vc = [[BTPhotoListViewController alloc] init];
    vc.isSelectModel = self.isSelectModel;
    if (indexPath.section == 0 && indexPath.row == 0) {
        vc.fetchResult = self.dataSource[indexPath.section * showNumber + indexPath.row];
        vc.assetCollection = nil;
    } else {
        
        PHAssetCollection *assetCollection = self.dataSource[indexPath.section * showNumber + indexPath.row];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        vc.assetCollection = assetCollection;
        vc.fetchResult = assetsFetchResult;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

//定义UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma mark -setter
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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

@end
