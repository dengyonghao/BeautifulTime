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
    [self loadPhotos];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH * scale, BT_SCREEN_HEIGHT * scale);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)loadPhotos {
    for (int i = 0; i < self.assets.count; i++ ) {
        
        WS(weakSelf);
        PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        [imageManager requestImageForAsset:self.assets[i]
                                targetSize:AssetGridThumbnailSize
                               contentMode:PHImageContentModeAspectFill
                                   options:options
                             resultHandler:^(UIImage *result, NSDictionary *info) {
                                 
                                 [weakSelf.dataSource addObject:result];
                                 
                             }];
    }
}

- (void)finishButtonClick {

}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        _scrollView.contentSize = CGSizeMake(self.assets.count * BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT);
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
