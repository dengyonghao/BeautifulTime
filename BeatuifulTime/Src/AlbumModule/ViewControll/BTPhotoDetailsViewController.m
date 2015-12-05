//
//  BTPhotoDetailsViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/27.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoDetailsViewController.h"
#import <Photos/Photos.h>

static CGSize AssetGridThumbnailSize;

@interface BTPhotoDetailsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation BTPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishButton.hidden = NO;
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:self.scrollView];
    WS(weakSelf);
    UIImageView *imageView = [[UIImageView alloc] init];
    NSInteger x = 0 * BT_SCREEN_WIDTH;
    [imageView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    [imageManager requestImageForAsset:self.assets[0]
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             imageView.contentMode = UIViewContentModeScaleAspectFit;
                             imageView.image = result;
                             [weakSelf.scrollView addSubview:imageView];
//                             [weakSelf.dataSource addObject:result];
                             
                         }];

    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self loadPhotos];
//    });

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH * scale, (BT_SCREEN_HEIGHT - 48 * 2) * scale);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(48, 0, -48, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadAllPhotos {
    WS(weakSelf);
    for (int i = 0; i < self.assets.count;  i++) {
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        [imageManager requestImageForAsset:self.assets[i]
                                targetSize:AssetGridThumbnailSize
                               contentMode:PHImageContentModeAspectFit
                                   options:options
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 
                                 [weakSelf.dataSource addObject:result];
                                 
                             }];
    }
}

- (void)loadPhotos {
    for (int i = 0; i < self.assets.count; i++ ) {
        if (i == 0) {
            [self photoParseWithIndex:i];
        } else {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self photoParseWithIndex:i];
            });
        }
    }
}

- (void)photoParseWithIndex:(NSInteger)index {
    WS(weakSelf);
    UIImageView *imageView = [[UIImageView alloc] init];
    NSInteger x = index * BT_SCREEN_WIDTH;
    [imageView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    [imageManager requestImageForAsset:self.assets[index]
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             imageView.contentMode = UIViewContentModeScaleAspectFit;
                             imageView.image = result;
                             [weakSelf.scrollView addSubview:imageView];
                             [weakSelf.dataSource addObject:result];
                             
                         }];
}

- (void)finishButtonClick {

}


#pragma mark - 滚动视图代理方法
// 完成减速意味着页面切换完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 设置PageControl页数
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    WS(weakSelf);
    UIImageView *imageView = [[UIImageView alloc] init];
    NSInteger x = pageNo * BT_SCREEN_WIDTH;
    [imageView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    PHImageManager *imageManager = [[PHImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    [imageManager requestImageForAsset:self.assets[pageNo]
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             imageView.contentMode = UIViewContentModeScaleAspectFit;
                             imageView.image = result;
                             [weakSelf.scrollView addSubview:imageView];
                             //                             [weakSelf.dataSource addObject:result];
                             
                         }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.contentSize = CGSizeMake(self.assets.count * BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT - 48 * 2);
        _scrollView.delegate = self;
        _scrollView.contentOffset = CGPointMake(0, 0);
        //设置放大缩小的最大，最小倍数
        self.scrollView.minimumZoomScale = 1;
        self.scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}


@end
