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
    }
    return self;
}

- (void)bindData:(BTAddressBook *)addressBook {

}

- (UILabel *)name {
    if (!_name) {
        _name = [[UILabel alloc] init];
    }
    return _name;
}

@end
