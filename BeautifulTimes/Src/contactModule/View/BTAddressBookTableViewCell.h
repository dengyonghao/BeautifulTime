//
//  BTAddressBookTableViewCell.h
//  BeautifulTimes
//
//  Created by deng on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^pullButtonClicked)(NSIndexPath * indexPath);

@interface BTAddressBookTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * telLabel;
@property (nonatomic, strong) UIButton * pullButton;//三角按钮
@property (nonatomic, copy) pullButtonClicked pullBlock;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) NSIndexPath * indexPath;

@end
