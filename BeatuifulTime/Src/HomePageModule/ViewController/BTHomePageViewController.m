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

@property (nonatomic, strong) UIButton *timeline;
@property (nonatomic, strong) UIButton *journals;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *chat;
@property (nonatomic, strong) UIButton *addJournal;
@property (nonatomic, strong) UIButton *addTimeline;
@property (nonatomic, strong) UIButton *reminiscence;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.timeline];
    [self.view addSubview:self.photos];
    [self.view addSubview:self.journals];
    [self.view addSubview:self.chat];
    [self.view addSubview:self.addJournal];
    [self.view addSubview:self.addTimeline];
    [self.view addSubview:self.reminiscence];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.journals mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.chat mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.addTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.addJournal mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    [self.reminiscence mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];

}

- (void)onclick {
    BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)timelineBnt {
    if (!_timeline) {
        _timeline = [[UIButton alloc] init];
    }
    return _timeline;
}

- (UIButton *)photos {
    if (!_photos) {
        _photos = [[UIButton alloc] init];
    }
    return _photos;
}

- (UIButton *)journals {
    if (!_journals) {
        _journals = [[UIButton alloc] init];
    }
    return _journals;
}

- (UIButton *)chat {
    if (!_chat) {
        _chat = [[UIButton alloc] init];
    }
    return _chat;
}

- (UIButton *)addJournal {
    if (!_addJournal) {
        _addJournal = [[UIButton alloc] init];
    }
    return _addJournal;
}

- (UIButton *)addTimeline {
    if (!_addTimeline) {
        _addTimeline = [[UIButton alloc] init];
    }
    return _addTimeline;
}

- (UIButton *)reminiscence {
    if (!_reminiscence) {
        _reminiscence = [[UIButton alloc] init];
    }
    return _reminiscence;
}



@end
