//
//  BTPhotoListViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoListViewController.h"
#import "BTPhotoCollectionViewCell.h"
#import "BTPhotoDetailsViewController.h"

static  NSString *kcellIdentifier = @"kPhotoCollectionCellID";
static int const showNumber = 3;
static CGSize AssetGridThumbnailSize;
static CGFloat const iconWidth = 90.0f;
static CGFloat const iconHeight = 90.0f;

@interface BTPhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BTPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"相册详情";
    [self initDataSource];
    [self.bodyView addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.collectionView registerClass:[BTPhotoCollectionViewCell class] forCellWithReuseIdentifier:kcellIdentifier];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(iconWidth * scale, iconHeight * scale);
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

- (void)initDataSource {
    
    [self.dataSource removeAllObjects];
    
        
    if (!self.assetCollection) {
        
        for (int i = 0; i < self.fetchResult.count; i++) {
            PHAsset *asset = self.fetchResult[i];
            
            [self.dataSource addObject:asset];
        }
        
    } else {
        
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
        
        for (int i = 0; i < assetsFetchResult.count; i++) {
            PHAsset *asset = assetsFetchResult[i];
            
            [self.dataSource addObject:asset];
        }
    }
}

#pragma mark - PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    // Check if there are changes to the assets we are showing.
    PHFetchResultChangeDetails *collectionChanges = [changeInstance changeDetailsForFetchResult:self.fetchResult];
    if (collectionChanges == nil) {
        return;
    }
    
    /*
     Change notifications may be made on a background queue. Re-dispatch to the
     main queue before acting on the change as we'll be updating the UI.
     */
    dispatch_async(dispatch_get_main_queue(), ^{
        // Get the new fetch result.
        self.fetchResult = [collectionChanges fetchResultAfterChanges];
        
        UICollectionView *collectionView = self.collectionView;
        
        if (![collectionChanges hasIncrementalChanges] || [collectionChanges hasMoves]) {
            // Reload the collection view if the incremental diffs are not available
            [self initDataSource];
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
    CGFloat height = iconHeight;
    
    return CGSizeMake(width, height);
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kcellIdentifier forIndexPath:indexPath];
    [cell bindData:self.dataSource[indexPath.section * showNumber + indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BTPhotoDetailsViewController *vc = [[BTPhotoDetailsViewController alloc] init];
    vc.assets = self.dataSource;
    [self.navigationController pushViewController:vc animated:YES];
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
