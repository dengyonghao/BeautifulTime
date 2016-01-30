//
//  BTSettingCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/18.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTSettingCell.h"

@interface BTSettingCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *title;

@end

@implementation BTSettingCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.title];
        
        WS(weakSelf);
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

#pragma -mark getter

- (UIImageView *)headIcon {
    if (!_headIcon) {
        _headIcon = [[UIImageView alloc] init];
    }
    return _headIcon;
}

- (UILabel *)title {
    if (!_title) {
        _title = [[UILabel alloc] init];
    }
    return _title;
}

@end
