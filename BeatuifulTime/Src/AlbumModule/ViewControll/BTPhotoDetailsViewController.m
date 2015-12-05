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
static NSInteger currentIndex;

@interface BTPhotoDetailsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *nextImageView;
@property (nonatomic, strong) UIImageView *nextCacheImageView;
@property (nonatomic, strong) UIImageView *previousImageView;
@property (nonatomic, strong) UIImageView *previousCacheImageView;

@end

@implementation BTPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishButton.hidden = NO;
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.currentImageView];
    [self.scrollView addSubview:self.nextImageView];
    [self.scrollView addSubview:self.previousImageView];
    [self.scrollView addSubview:self.nextCacheImageView];
    [self.scrollView addSubview:self.previousCacheImageView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self parseAllPhoto];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH * scale, (BT_SCREEN_HEIGHT - 48 * 2) * scale);
    currentIndex = self.index;

    [self photoParseWithIndex:currentIndex imageView:self.currentImageView];
    [self photoParseWithIndex:currentIndex - 1 imageView:self.previousImageView];
    [self photoParseWithIndex:currentIndex + 1 imageView:self.nextImageView];
    [self photoParseWithIndex:currentIndex - 2 imageView:self.previousCacheImageView];
    [self photoParseWithIndex:currentIndex + 2 imageView:self.nextCacheImageView];
    
    [self.scrollView scrollRectToVisible:CGRectMake(BT_SCREEN_WIDTH * (currentIndex - 1), 0, BT_SCREEN_WIDTH , BT_SCREEN_HEIGHT) animated:NO];
    
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

- (void)photoParseWithIndex:(NSInteger)index imageView:(UIImageView *)imageView{
    if (index < 0 || index > self.assets.count - 1) {
        return;
    }
    NSInteger x = index * BT_SCREEN_WIDTH;
    [imageView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",(long)index]]) {
        UIImage *img = [self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",(long)index]];
        imageView.image = img;
        return;
    }
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    [self.imageManager requestImageForAsset:self.assets[index]
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFit
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             imageView.image = result;
                         }];
}

- (void)parseAllPhoto {
    for (int i = 0; i < self.assets.count; i++) {
        __block long index = i;
        if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",index]]) {
            continue;
        }
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        [self.imageManager requestImageForAsset:self.assets[i]
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      [self.dataSource setObject:result forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
                                  }];
        
    }
}

- (void)finishButtonClick {

}


#pragma mark - 滚动视图代理方法
// 完成减速意味着页面切换完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;

    if (pageNo == currentIndex) {
        return;
    }
    currentIndex = pageNo;
    [self photoParseWithIndex:currentIndex imageView:self.currentImageView];
    [self photoParseWithIndex:currentIndex - 1 imageView:self.previousImageView];
    [self photoParseWithIndex:currentIndex + 1 imageView:self.nextImageView];
    [self photoParseWithIndex:currentIndex - 2 imageView:self.previousCacheImageView];
    [self photoParseWithIndex:currentIndex + 2 imageView:self.nextCacheImageView];
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

/*

#pragma mark 当UIScrollView尝试进行缩放的时候就会调用

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.currentImageView;
}

#pragma mark 当缩放完毕的时候调用

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
    NSLog(@"结束缩放 - %f", scale);
}

#pragma mark 当正在缩放的时候调用

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    
}
 */

- (NSMutableDictionary *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableDictionary alloc] init];
    }
    return _dataSource;
}

- (PHCachingImageManager *)imageManager {
    if (!_imageManager) {
        _imageManager = [[PHCachingImageManager alloc] init];
    }
    return _imageManager;
}

- (UIImageView *)currentImageView {
    if (!_currentImageView) {
        _currentImageView = [[UIImageView alloc] init];
        _currentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _currentImageView;
}

- (UIImageView *)previousImageView {
    if (!_previousImageView) {
        _previousImageView = [[UIImageView alloc] init];
        _previousImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previousImageView;
}

- (UIImageView *)nextImageView {
    if (!_nextImageView) {
        _nextImageView = [[UIImageView alloc] init];
        _nextImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _nextImageView;
}

- (UIImageView *)previousCacheImageView {
    if (!_previousCacheImageView) {
        _previousCacheImageView = [[UIImageView alloc] init];
        _previousCacheImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _previousCacheImageView;
}

- (UIImageView *)nextCacheImageView {
    if (!_nextCacheImageView) {
        _nextCacheImageView = [[UIImageView alloc] init];
        _nextCacheImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _nextCacheImageView;
}


@end
