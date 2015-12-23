//
//  BTJournalDetailsViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalDetailsViewController.h"

@interface BTJournalDetailsViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation BTJournalDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"详情";
    [self.finishButton setHidden:NO];
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {

}

@end
