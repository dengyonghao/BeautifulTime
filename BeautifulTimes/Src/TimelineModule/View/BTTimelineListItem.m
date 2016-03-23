//
//  BTTimelineListItemTableViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineListItem.h"

@interface BTTimelineListItem ()

@property (nonatomic, strong) UILabel *content;

@end

@implementation BTTimelineListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.content];
        
        [self setupSubview];
    }
    return self;
}

- (void)setupSubview {
    WS(weakSelf);
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.contentView);
        make.centerY.equalTo(weakSelf.contentView);
        make.height.equalTo(@(30));
        make.width.equalTo(weakSelf.contentView);
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindDate:(BTTimelineModel *)model {
    self.content.text = [[NSString alloc] initWithData:model.timelineContent encoding:NSUTF8StringEncoding];
}

#pragma mark getting && setting
- (UILabel *)content {
    if (!_content) {
        _content = [[UILabel alloc] init];
        _content.font = BT_FONTSIZE(20);
        _content.textAlignment = NSTextAlignmentLeft;
    }
    return _content;
}

@end
