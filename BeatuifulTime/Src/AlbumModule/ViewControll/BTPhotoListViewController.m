//
//  BTPhotoListViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoListViewController.h"
#import "BTPhotoCollectionViewCell.h"

static  NSString *kcellIdentifier = @"kPhotoCollectionCellID";
static int const showNumber = 3;
static CGSize AssetGridThumbnailSize;
static CGFloat const iconWidth = 90.0f;
static CGFloat const iconHeight = 90.0f;

@interface BTPhotoListViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BTPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"相册详情";
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
        if (section == self.dataSource.count / showNumber + 1) {
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
    PHCollection *collection = self.dataSource[indexPath.section * showNumber + indexPath.row];
    
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        PHFetchResult *result = self.dataSource[indexPath.section * showNumber + indexPath.row];
        if (result.count > 0) {
            PHAsset *asset = self.dataSource[indexPath.section * showNumber + indexPath.row][0];
            
            [imageManager requestImageForAsset:asset
                                    targetSize:AssetGridThumbnailSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     
                                     [cell bindData:result];
                                     
                                 }];
        }
        
        
    }
    else {
        
        PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
        
        if (assetsFetchResult.count) {
            PHAsset *asset = assetsFetchResult[0];
            
            [imageManager requestImageForAsset:asset
                                    targetSize:AssetGridThumbnailSize
                                   contentMode:PHImageContentModeAspectFill
                                       options:options
                                 resultHandler:^(UIImage *result, NSDictionary *info) {
                                     
                                     [cell bindData:result];
                                     
                                 }];
        }
        else {
            [cell bindData:nil];
        }
        
        
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

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
