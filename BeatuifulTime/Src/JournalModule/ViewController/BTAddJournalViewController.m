//
//  BTAddJournalViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTAddJournalViewController.h"

@interface BTAddJournalViewController ()

@property (nonatomic, strong) UIButton *finshBnt;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *city;
@property (nonatomic, strong) UIButton *weath;
@property (nonatomic, strong) UIButton *phonos;
@property (nonatomic, strong) UIButton *record;

@end

@implementation BTAddJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"写日记";
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
