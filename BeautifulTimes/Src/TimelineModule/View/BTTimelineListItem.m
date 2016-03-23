//
//  BTTimelineListItemTableViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineListItem.h"

@interface BTTimelineListItem ()

@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *siteLabel;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UILabel *friendsLabel;

@end

@implementation BTTimelineListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.dateLabel];
        [self.contentView addSubview:self.siteLabel];
        [self.contentView addSubview:self.photoView];
        [self.contentView addSubview:self.playButton];
        [self.contentView addSubview:self.friendsLabel];
        
        [self setupSubview];
        
    }
    return self;
}

- (void)setupSubview {
    WS(weakSelf);
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.siteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.friendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)bindDate:(BTTimelineModel *)model {

}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
    }
    return _contentLabel;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
    }
    return _dateLabel;
}

- (UILabel *)siteLabel {
    if (!_siteLabel) {
        _siteLabel = [[UILabel alloc] init];
    }
    return _siteLabel;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
    }
    
    return _photoView;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
    }
    return _playButton;
}

- (UILabel *)friendsLabel {
    if (!_friendsLabel) {
        _friendsLabel = [[UILabel alloc] init];
    }
    return _friendsLabel;
}

@end
