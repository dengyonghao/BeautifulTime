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

static  NSString *kcellIdentifier = @"kPhotoCollectionCellID";
static int const showNumber = 3;
static CGSize AssetGridThumbnailSize;

@interface BTPhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver, UIActionSheetDelegate> {
    long photosNumber;
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableDictionary *flageArray;
@property (nonatomic, strong) NSMutableDictionary *photoSource;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;
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
    AssetGridThumbnailSize = CGSizeMake((BT_SCREEN_WIDTH / showNumber), (BT_SCREEN_WIDTH / showNumber));
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
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
//            [self initDataSource];
            [collectionView reloadData];
            
        } else {
            /*
             Tell the collection view to animate insertions and deletions if we
             have incremental diffs.
             */
            [collectionView performBatchUpdates:^{
                NSIndexSet *removedIndexes = [collectionChanges removedIndexes];
                if ([removedIndexes count] > 0) {
//                    [collectionView deleteItemsAtIndexPaths:[removedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *insertedIndexes = [collectionChanges insertedIndexes];
                if ([insertedIndexes count] > 0) {
//                    [collectionView insertItemsAtIndexPaths:[insertedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
                
                NSIndexSet *changedIndexes = [collectionChanges changedIndexes];
                if ([changedIndexes count] > 0) {
//                    [collectionView reloadItemsAtIndexPaths:[changedIndexes aapl_indexPathsFromIndexesWithSection:0]];
                }
            } completion:NULL];
        }
        
//        [self resetCachedAssets];
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

@end
