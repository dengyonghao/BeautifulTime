//
//  BTTimelineListItemTableViewCell.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/3/4.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineListItem.h"

@implementation BTTimelineListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)bindDate:(BTTimelineModel *)model {

}

@end
