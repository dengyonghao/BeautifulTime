//
//  ViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "HomePageViewController.h"
#import "BTThemeManager.h"

@interface HomePageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    [self.view addSubview:_imageView];
    [[BTThemeManager getInstance] BTThemeImage:@"music_ic_localmusic" completionHandler:^(UIImage *image) {
        [self.imageView setImage:image];
    } ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
