//
//  BTPhotoDetailsViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/27.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTPhotoDetailsViewController.h"

@interface BTPhotoDetailsViewController ()

@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation BTPhotoDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}


@end
