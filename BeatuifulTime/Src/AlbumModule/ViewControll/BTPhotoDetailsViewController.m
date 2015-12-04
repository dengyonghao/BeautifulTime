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
@property (nonatomic, strong) UIImageView *previousImageView;

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH * scale, (BT_SCREEN_HEIGHT - 48 * 2) * scale);
    currentIndex = self.index;
    if (currentIndex == 0) {
        [self photoParseWithIndex:currentIndex imageView:self.currentImageView];
        [self photoParseWithIndex:currentIndex + 1 imageView:self.nextImageView];
    }
    else if(currentIndex == self.assets.count - 1){
        [self photoParseWithIndex:currentIndex imageView:self.currentImageView];
        [self photoParseWithIndex:currentIndex - 1 imageView:self.previousImageView];
    } else {
        [self photoParseWithIndex:currentIndex imageView:self.currentImageView];
        [self photoParseWithIndex:currentIndex - 1 imageView:self.previousImageView];
        [self photoParseWithIndex:currentIndex + 1 imageView:self.nextImageView];
    }
    
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
    WS(weakSelf);
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

- (void)nextPhoto {
    if (self.nextImageView.image == nil) {
        sleep(0.3);
        [self nextPhoto];
    }
    if(currentIndex == self.assets.count - 1){
        self.previousImageView.frame = self.currentImageView.frame;
        self.previousImageView.image = self.currentImageView.image;
        self.currentImageView.frame = self.nextImageView.frame;
        self.currentImageView.image = self.nextImageView.image;
    } else {
        self.previousImageView.frame = self.currentImageView.frame;
        self.previousImageView.image = self.currentImageView.image;
        self.currentImageView.frame = self.nextImageView.frame;
        self.currentImageView.image = self.nextImageView.image;
        [self photoParseWithIndex:currentIndex + 1 imageView:self.nextImageView];
    }
}

- (void)previousPhoto {
    if(currentIndex == 0){
        self.nextImageView.frame = self.currentImageView.frame;
        self.nextImageView.image = self.currentImageView.image;
        self.currentImageView.frame = self.previousImageView.frame;
        self.currentImageView.image = self.previousImageView.image;
    } else {
        self.nextImageView.frame = self.currentImageView.frame;
        self.nextImageView.image = self.currentImageView.image;
        self.currentImageView.frame = self.previousImageView.frame;
        self.currentImageView.image = self.previousImageView.image;
        [self photoParseWithIndex:currentIndex - 1 imageView:self.previousImageView];
    }
}

- (void)finishButtonClick {

}


#pragma mark - 滚动视图代理方法
// 完成减速意味着页面切换完成
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",(long)currentIndex]] == nil) {
        [self.dataSource setObject:self.currentImageView.image forKey: [[NSString alloc] initWithFormat:@"%ld",(long)currentIndex]];
    }

    if (pageNo == currentIndex) {
        return;
    }
    if (pageNo > currentIndex) {
        currentIndex = pageNo;
        [self nextPhoto];
    } else {
        currentIndex = pageNo;
        [self previousPhoto];
    }
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


@end
