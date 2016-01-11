//
//  BTChatMessageCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatMessageCell.h"

@interface BTChatMessageCell ()

@property (nonatomic, strong) UIImageView *headIcon;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *time;

@end

@implementation BTChatMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.headIcon];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
        [self.contentView addSubview:self.time];
        
        WS(weakSelf);
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            
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

- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
    }
    return _content;
}

- (UILabel *)time {
    if (!_time) {
        _time = [[UILabel alloc] init];
    }
    return _time;
}

@end
