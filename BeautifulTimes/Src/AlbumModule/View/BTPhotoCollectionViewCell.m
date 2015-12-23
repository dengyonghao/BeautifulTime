//
//  BTPhotoCollectionViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoCollectionViewCell.h"

static CGSize AssetGridThumbnailSize;

@interface BTPhotoCollectionViewCell ()

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *options;

@end

@implementation BTPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.isSelect];
        
        CGFloat iconWidth = BT_SCREEN_WIDTH / 3;
        CGFloat scale = [UIScreen mainScreen].scale;
        AssetGridThumbnailSize = CGSizeMake(iconWidth * scale, iconWidth * scale);
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconWidth));
            make.centerX.equalTo(weakSelf.contentView.mas_centerX);
        }];
        
//        [self.isSelect mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(weakSelf).offset(-5);
//            make.bottom.equalTo(weakSelf).offset(-5);
//            make.width.equalTo(@(24));
//            make.height.equalTo(@(24));
//        }];
    }
    return self;
}

#pragma mark - CLThemeListenerProtocol
- (void)CLThemeDidNeedUpdateStyle
{
    
}

- (void)bindData:(PHAsset *)asset {
    self.imageView.image = BT_LOADIMAGE(@"music_ic_albumcover");
    WS(weakSelf);
    [self.imageManager requestImageForAsset:asset
                            targetSize:AssetGridThumbnailSize
                           contentMode:PHImageContentModeAspectFill
                               options:self.options
                         resultHandler:^(UIImage *result, NSDictionary *info) {
                             
                             weakSelf.imageView.image = result;
                             
                         }];
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

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _imageView;
}

- (UIImageView *)isSelect {
    if (!_isSelect) {
        _isSelect = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _isSelect.image = BT_LOADIMAGE(@"com_ic_selected");
        _isSelect.hidden = YES;
    }
    return _isSelect;
}

@end
