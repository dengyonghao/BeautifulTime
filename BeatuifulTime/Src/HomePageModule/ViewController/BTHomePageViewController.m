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

static const CGFloat BUTTONWIDTH = 48;

@interface BTHomePageViewController ()<BTThemeListenerProtocol>

@property (nonatomic, assign) BOOL themeInit;

@property (nonatomic, strong) UIButton *timeline;
@property (nonatomic, strong) UIButton *journals;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *chat;
@property (nonatomic, strong) UIButton *addJournal;
@property (nonatomic, strong) UIButton *addTimeline;
@property (nonatomic, strong) UIButton *reminiscence;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeInit = YES;
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backgroundImageView];
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
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view);
    }];
    
    CGFloat OFFSET = (BT_SCREEN_WIDTH - BUTTONWIDTH * 4) / 5;

    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.photos.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.photos);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.view).offset(-15);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.themeInit) {
        [self BTThemeDidNeedUpdateStyle];
        self.themeInit = NO;
    }
}

- (void)onclick {
    BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];

}

- (void)BTThemeDidNeedUpdateStyle {

    WS(weakSelf);
    //启动图片
    if (BT_47INCH_SCREEN) {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_1242x2208" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];

    }
    else if (BT_55INCH_SCREEN) {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_750x1334" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];

    }
    else {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];
    }
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.timeline setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.timeline setImage:image forState:UIControlStateHighlighted];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.photos setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.photos setImage:image forState:UIControlStateHighlighted];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.journals setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.journals setImage:image forState:UIControlStateHighlighted];
//    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_chat" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_chat_press" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateHighlighted];
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)timeline {
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

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}


@end
