//
//  BTAddTimelineViewController.m
//  BeatuifulTime
//
//  Created by deng on 15/12/6.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddTimelineViewController.h"
#import "BTAddressBookViewController.h"
#import "BTCalendarView.h"

@interface BTAddTimelineViewController () <BTStatusViewDelegate>

@property (nonatomic, strong) UIButton *addressBook;

@end

@implementation BTAddTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记点滴";
    [self.bodyView addSubview:self.addressBook];
    BTCalendarView *view = [[BTCalendarView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    view.delegate = self;
    NSDate *date = [NSDate date];
    [view bindData:date];
    [self.bodyView addSubview:view];
}

- (void)viewDidLayoutSubviews {
    WS(weakSelf);
    [self.addressBook mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.centerY.equalTo(weakSelf.bodyView);
        make.height.equalTo(@(40));
        make.width.equalTo(@(100));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark BTCalendarViewViewDelegate

- (void)tapCurrentView {
    NSLog(@"1234567890-=234567890");
}

- (void)addressBookClick {
    BTAddressBookViewController *vc = [[BTAddressBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)addressBook {
    if (!_addressBook) {
        _addressBook = [[UIButton alloc] init];
        [_addressBook setTitle:@"联系人" forState:UIControlStateNormal];
        [_addressBook addTarget:self action:@selector(addressBookClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addressBook;
}

@end
