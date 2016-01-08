//
//  BTPhotoDetailsViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/27.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoDetailsViewController.h"
#import <Photos/Photos.h>

static CGSize AssetGridThumbnailSize;
static NSInteger currentIndex;
static NSInteger headIndex;
static NSInteger tailIndex;
static NSInteger cacheNumber = 10;

@interface BTPhotoDetailsViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;

@end

@implementation BTPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.finishButton.hidden = NO;
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:self.scrollView];
    headIndex = tailIndex = self.index;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    CGFloat scale = [UIScreen mainScreen].scale;
    AssetGridThumbnailSize = CGSizeMake(BT_SCREEN_WIDTH * scale, (BT_SCREEN_HEIGHT - 48 * 2) * scale);
    currentIndex = self.index;
    [self parsePhoto];
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

- (void)dealloc {
    self.imageManager = nil;
}

- (void)photoParseWithIndex:(NSInteger)index imageView:(UIImageView *)imageView{
    if (index < 0 || index > self.assets.count - 1) {
        return;
    }
    
    if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",(long)index]]) {
        return;
    }
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSInteger x = index * BT_SCREEN_WIDTH;
    [imgView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    [self.scrollView addSubview:imgView];
    
    [self.imageManager requestImageForAsset:self.assets[index]
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFit
                               options:self.options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             imgView.image = result;
                         }];
}

- (void)parseAllPhoto {
    for (int i = 0; i < self.assets.count; i++) {
        __block long index = i;
        if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",index]]) {
            continue;
        }
        
        [self.imageManager requestImageForAsset:self.assets[i]
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:self.options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      [self.dataSource setObject:result forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
                                  }];
        
    }
}

- (void)parsePhoto {
    for (int i = 0; i <= cacheNumber / 2; i++) {
        if (headIndex == tailIndex) {
            [self parsePhotoWithIndex:headIndex];
            headIndex++;
            tailIndex--;
            continue;
        }
        if (tailIndex >= 0) {
            [self parsePhotoWithIndex:tailIndex--];
        }
        if (headIndex < self.assets.count) {
            [self parsePhotoWithIndex:headIndex++];
        }
    }
}

- (void)parseRightPhoto {
    for (int i = 0; i <= cacheNumber; i++) {
        if (headIndex < self.assets.count) {
            [self parsePhotoWithIndex:headIndex++];
        }
    }
}

- (void)parseLifePhoto {
    for (int i = 0; i <= cacheNumber; i++) {
        if (tailIndex >= 0) {
            [self parsePhotoWithIndex:tailIndex--];
        }
    }
}

- (void)parsePhotoWithIndex:(NSInteger)index {
    if ([self.dataSource objectForKey:[[NSString alloc] initWithFormat:@"%ld",index]]) {
        return;
    }
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    NSInteger x = index * BT_SCREEN_WIDTH;
    [imgView setFrame:CGRectMake(x, 0, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT)];
    [self.scrollView addSubview:imgView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.imageManager requestImageForAsset:self.assets[index]
                                     targetSize:AssetGridThumbnailSize
                                    contentMode:PHImageContentModeAspectFit
                                        options:self.options
                                  resultHandler:^(UIImage *result, NSDictionary *info) {
                                      [self.dataSource setObject:result forKey:[[NSString alloc] initWithFormat:@"%ld",index]];
                                      imgView.image = result;
                                  }];
    });
    
}

- (void)finishButtonClick {

}


#pragma mark - scrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger pageNo = scrollView.contentOffset.x / scrollView.bounds.size.width;
    if (pageNo == currentIndex) {
        return;
    }
    if (pageNo > currentIndex && headIndex - pageNo < cacheNumber + cacheNumber / 2) {
        [self parseRightPhoto];
    }
    else if (pageNo - tailIndex < cacheNumber + cacheNumber / 2) {
        [self parseLifePhoto];
    }
    currentIndex = pageNo;
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

-(PHImageRequestOptions *)options {
    if (!_options) {
        _options = [[PHImageRequestOptions alloc] init];
        _options.resizeMode = PHImageRequestOptionsResizeModeExact;
        _options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    }
    return _options;
}

@end
