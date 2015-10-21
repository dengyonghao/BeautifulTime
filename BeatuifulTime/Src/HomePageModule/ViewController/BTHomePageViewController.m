//
//  ViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTHomePageViewController.h"
#import "BTThemeManager.h"
#import "BTRestPasswordViewController.h"
#import "BTUserLoginViewController.h"

@interface BTHomePageViewController ()

@property (nonatomic, strong) UIButton *imageView;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerView.hidden = YES;
    _imageView = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_imageView];
    [[BTThemeManager getInstance] BTThemeImage:@"music_ic_localmusic" completionHandler:^(UIImage *image) {
        [self.imageView setImage:image forState:UIControlStateNormal];
    } ];
    [self.imageView addTarget:self action:@selector(onclick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onclick {
    BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
