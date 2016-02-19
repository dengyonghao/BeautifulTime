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
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.content];
        
        WS(weakSelf);
        [self.headIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(8);
            make.left.equalTo(weakSelf).offset(8);
            make.width.equalTo(@(48));
            make.height.equalTo(@(48));
        }];
        
        [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(8);
            make.right.equalTo(weakSelf).offset(-5);
            make.width.equalTo(@(100));
            make.height.equalTo(@(20));
        }];
        
        [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headIcon);
            make.left.equalTo(weakSelf.headIcon).offset(48 + 5);
            make.height.equalTo(@(20));
            make.right.equalTo(weakSelf.time).offset(-(100 + 5));
        }];
        
        [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.title).offset(20 + 8);
            make.left.equalTo(weakSelf.headIcon).offset(48 + 5);
            make.height.equalTo(@(16));
            make.right.equalTo(weakSelf).offset(-5);
        }];
    }
    return self;
}

- (void)bindData:(BTMessageListModel *)model {
        UIImage *image = [[UIImage alloc] initWithData:[[BTXMPPTool sharedInstance].avatar photoDataForJID:model.jid]];
    if (!image) {
        image = BT_LOADIMAGE(@"com_ic_defaultIcon");
    }
    self.headIcon.image = image;
    self.title.text = model.uname;
    self.content.text = model.body;
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
