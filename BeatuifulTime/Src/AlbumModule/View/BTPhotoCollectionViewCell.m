//
//  BTPhotoCollectionViewCell.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoCollectionViewCell.h"

static CGSize AssetGridThumbnailSize;

@interface BTPhotoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BTPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        
        CGFloat iconWidth = BT_SCREEN_WIDTH / 3;
        CGFloat scale = [UIScreen mainScreen].scale;
        AssetGridThumbnailSize = CGSizeMake(iconWidth * scale, iconWidth * scale);
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconWidth));
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        }];
    }
    return self;
}

#pragma mark - CLThemeListenerProtocol
- (void)CLThemeDidNeedUpdateStyle
{
    
}

- (void)bindData:(PHAsset *)asset {
    self.imageView.image = BT_LOADIMAGE(@"music_ic_albumcover");
    PHCachingImageManager *imageManager = [[PHCachingImageManager alloc] init];
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    WS(weakSelf);
    [imageManager requestImageForAsset:asset
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFill
                               options:options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             weakSelf.imageView.image = result;
                             
                         }];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor blueColor];
    }
    return _imageView;
}

@end
