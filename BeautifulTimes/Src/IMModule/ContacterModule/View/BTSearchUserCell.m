//
//  BTSearchUserCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTSearchUserCell.h"

@interface BTSearchUserCell ()

@property (nonatomic, strong) UILabel *nickName;
@property (nonatomic, strong) UILabel *userName;

@end

@implementation BTSearchUserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.nickName];
        
        WS(weakSelf);
        [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(weakSelf).offset(10);
            make.right.equalTo(weakSelf).offset(-10);
            make.height.equalTo(@(20));
        }];
        
        [self.nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
    }
    return self;
}

- (void)bindData:(BTContacterModel *)model {
    self.nickName.text = model.nickName;
    self.userName.text = model.jid.description;
}

- (UILabel *)userName {
    if (!_userName) {
        _userName = [[UILabel alloc] init];
    }
    return _userName;
}

- (UILabel *)nickName {
    if (!_nickName) {
        _nickName = [[UILabel alloc] init];
    }
    return _nickName;
}

@end
