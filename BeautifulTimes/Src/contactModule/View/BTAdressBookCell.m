//
//  BTAdressBookCell.m
//  BeautifulTimes
//
//  Created by deng on 16/2/22.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAdressBookCell.h"

@interface BTAdressBookCell ()

@property (nonatomic, strong) UILabel *name;

@end

@implementation BTAdressBookCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.name];
        
        WS(weakSelf);
        [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf.contentView);
            make.left.equalTo(weakSelf.contentView).offset(20);
            make.right.equalTo(weakSelf.contentView).offset(-20);
            make.height.equalTo(@(20));
        }];
    }
    return self;
}

- (void)bindData:(BTAddressBook *)addressBook {
    self.name.text = addressBook.name;
}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
    }
    return _name;
}

@end
