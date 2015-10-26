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

static const CGFloat BUTTONWIDTH = 50.0f;

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
    self.view.backgroundColor = [UIColor whiteColor];
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
    
    CGFloat OFFSET = (BT_SCREEN_WIDTH - BUTTONWIDTH * 4) / 5;

    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.photos.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.photos);
        make.height.equalTo(@(44));
        make.bottom.equalTo(weakSelf.view).offset(-20);
    }];
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeline.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.journals.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.journals);
        make.height.equalTo(weakSelf.timeline);
        make.bottom.equalTo(weakSelf.timeline);

    }];
    [self.journals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.photos.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.chat.mas_left).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.chat);
        make.height.equalTo(weakSelf.photos);
        make.bottom.equalTo(weakSelf.photos);

    }];
    [self.chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.journals.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.view).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.timeline);
        make.height.equalTo(weakSelf.journals);
        make.bottom.equalTo(weakSelf.journals);

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

- (UIButton *)timeline {
    if (!_timeline) {
        _timeline = [[UIButton alloc] init];
//        _timeline.backgroundColor = [UIColor redColor];
        [_timeline setTitle:@"时间轴" forState:UIControlStateNormal];
    }
    return _timeline;
}

- (UIButton *)photos {
    if (!_photos) {
        _photos = [[UIButton alloc] init];
//        _photos.backgroundColor = [UIColor yellowColor];
        [_photos setTitle:@"相册" forState:UIControlStateNormal];
    }
    return _photos;
}

- (UIButton *)journals {
    if (!_journals) {
        _journals = [[UIButton alloc] init];
//        _journals.backgroundColor = [UIColor greenColor];
        [_journals setTitle:@"日记集" forState:UIControlStateNormal];
    }
    return _journals;
}

- (UIButton *)chat {
    if (!_chat) {
        _chat = [[UIButton alloc] init];
        _chat.backgroundColor = [UIColor blueColor];
        [_chat setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_chat setTitle:@"私语" forState:UIControlStateNormal];
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
