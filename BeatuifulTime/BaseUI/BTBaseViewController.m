//
//  BTBaseViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTThemeManager.h"

#define baseHeaderViewHeight        48
#define BACKBUTTONWIDTH             32

@interface BTBaseViewController ()<BTThemeListenerProtocol>

@property (nonatomic, assign) BOOL themeInit;

@end

@implementation BTBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.statusHeight = BT_STATUSBAR_HEIGHT;
        [[BTThemeManager getInstance] addThemeListener:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.themeInit = YES;
    
    self.view.frame = CGRectMake(0, self.statusHeight, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT);
    
    
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.statusHeight, BT_SCREEN_WIDTH, baseHeaderViewHeight)];
    self.headerView.backgroundColor = BT_CLEARCOLOR;
    
    [self.headerView addObserver:self forKeyPath:@"hidden" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self.view addSubview:self.headerView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:self.headerView.bounds];
    self.titleLabel.backgroundColor = BT_CLEARCOLOR;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = BT_FONTSIZE(20);
    [self.headerView addSubview:self.titleLabel];
    
    
    self.finishButton = [[UIButton alloc] initWithFrame:CGRectMake(BT_SCREEN_WIDTH - BACKBUTTONWIDTH - 16, 8, BACKBUTTONWIDTH, BACKBUTTONWIDTH)];
    self.finishButton.exclusiveTouch = YES;
    [self.finishButton addTarget:self action:@selector(finishButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.finishButton];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(16, 8, BACKBUTTONWIDTH, BACKBUTTONWIDTH)];
    self.backButton.exclusiveTouch = YES;
    [self.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headerView addSubview:self.backButton];
    
    self.bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, baseHeaderViewHeight + self.statusHeight, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT-baseHeaderViewHeight-self.statusHeight)];
    [self.view addSubview:self.bodyView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.themeInit) {
        [self BTThemeDidNeedUpdateStyle];
        self.themeInit = NO;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[BTThemeManager getInstance] removeThemeListener:self];
    [self.headerView removeObserver:self forKeyPath:@"hidden" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark 点击事件
- (void)backButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishButtonClick {

}

#pragma mark -
#pragma mark 主题改变回调
- (void) BTThemeDidNeedUpdateStyle
{
    UIColor *bgColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_bg_c_main"];
    self.view.backgroundColor = bgColor;
    
    self.bodyView.backgroundColor = bgColor;
    
    self.titleLabel.textColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_title"];
    
    [[BTThemeManager getInstance] BTThemeImage:@"com_ic_back" completionHandler:^(UIImage *image) {
        [self.backButton setImage:image forState:UIControlStateNormal];
    }];
    
    [[BTThemeManager getInstance] BTThemeImage:@"com_ic_back_press" completionHandler:^(UIImage *image) {
        [self.backButton setImage:image forState:UIControlStateHighlighted];
    }];
}

#pragma mark -
#pragma mark 监听头部header是否被隐藏
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hidden"])
    {
        BOOL isHidden = [[change objectForKey:@"new"] boolValue];
        if (isHidden)
        {
            self.bodyView.frame = CGRectMake(0, self.statusHeight, BT_SCREEN_HEIGHT, BT_SCREEN_HEIGHT - self.statusHeight);
        }
        else
        {
            self.bodyView.frame = CGRectMake(0, baseHeaderViewHeight + self.statusHeight, BT_SCREEN_WIDTH, BT_SCREEN_HEIGHT-baseHeaderViewHeight-self.statusHeight);
        }
    }
}

#pragma mark -状态栏 显示控制
/*
 *状态栏风格控制
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
    //UIStatusBarStyleDefault = 0 黑色文字，浅色背景时使用
    //UIStatusBarStyleLightContent = 1 白色文字，深色背景时使用
}


- (BOOL)prefersStatusBarHidden
{
    return YES; //返回NO表示要显示，返回YES将hiden    默认隐藏
}

@end