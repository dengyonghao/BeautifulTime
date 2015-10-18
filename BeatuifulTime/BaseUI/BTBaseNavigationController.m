//
//  BTBaseNavigationController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTBaseNavigationController.h"

@interface BTBaseNavigationController ()

@end

@implementation BTBaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden    默认隐藏
}

@end
