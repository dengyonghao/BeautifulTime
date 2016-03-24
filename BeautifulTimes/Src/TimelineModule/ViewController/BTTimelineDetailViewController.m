//
//  BTTimelineDetailViewController.m
//  BeautifulTimes
//
//  Created by 邓永豪 on 16/3/24.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDetailViewController.h"
#import "BTTimelineEditViewController.h"

@interface BTTimelineDetailViewController ()

@end

@implementation BTTimelineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"时光轴详情";
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    BTTimelineEditViewController *vc = [[BTTimelineEditViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
