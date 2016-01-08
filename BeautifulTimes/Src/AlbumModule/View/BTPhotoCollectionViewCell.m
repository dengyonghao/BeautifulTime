//
//  BTPhotoCollectionViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoCollectionViewCell.h"

@interface BTPhotoCollectionViewCell ()

@end

@implementation BTPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.isSelect];
        
        CGFloat iconWidth = BT_SCREEN_WIDTH / 3;
        WS(weakSelf);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf);
            make.left.equalTo(weakSelf);
            make.width.equalTo(@(iconWidth));
            make.height.equalTo(@(iconWidth));
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

- (void)bindData:(UIImage *)image {
    self.imageView.image = image;
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
