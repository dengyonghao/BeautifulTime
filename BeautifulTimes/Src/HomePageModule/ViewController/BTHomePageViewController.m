//
//  ViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTHomePageViewController.h"
#import "BTThemeManager.h"
#import "BTRestPasswordViewController.h"
#import "BTUserLoginViewController.h"
#import "BTAddJournalViewController.h"
#import "BTMyAlbumViewController.h"
#import "BTTimelineViewController.h"
#import "BTAddTimelineViewController.h"
#import "BTUserCenterViewController.h"
#import "BTSettingViewController.h"
#import "BTJournalListViewController.h"
#import "BTUserLoginViewController.h"
#import "BTIMHomePageViewController.h"
#import "BTXMPPTool.h"

static const CGFloat BUTTONWIDTH = 48;

@interface BTHomePageViewController ()<BTThemeListenerProtocol>

@property (nonatomic, assign) BOOL themeInit;

@property (nonatomic, strong) UIButton *timeline;
@property (nonatomic, strong) UIButton *journals;
@property (nonatomic, strong) UIButton *album;
@property (nonatomic, strong) UIButton *chat;
@property (nonatomic, strong) UIButton *addJournal;
@property (nonatomic, strong) UIButton *addTimeline;
@property (nonatomic, strong) UIButton *reminiscence;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *userCenter;
@property (nonatomic, strong) UIButton *setting;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeInit = YES;
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.timeline];
    [self.view addSubview:self.album];
    [self.view addSubview:self.journals];
    [self.view addSubview:self.chat];
    [self.view addSubview:self.addJournal];
    [self.view addSubview:self.addTimeline];
    [self.view addSubview:self.reminiscence];
    [self.view addSubview:self.userCenter];
    [self.view addSubview:self.setting];
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

    [self.userCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(10);
        make.width.mas_equalTo(@(48));
        make.height.equalTo(@(48));
        make.top.equalTo(weakSelf.view).offset(10);
    }];
    [self.setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-10);
        make.width.mas_equalTo(@(48));
        make.height.equalTo(@(48));
        make.top.equalTo(weakSelf.view).offset(10);
    }];
    
    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.album.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.album);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.view).offset(-15);
    }];
    [self.album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeline.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.journals.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.journals);
        make.height.equalTo(weakSelf.timeline);
        make.bottom.equalTo(weakSelf.timeline);

    }];
    [self.journals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.album.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.chat.mas_left).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.chat);
        make.height.equalTo(weakSelf.album);
        make.bottom.equalTo(weakSelf.album);

    }];
    [self.chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.journals.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.view).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.timeline);
        make.height.equalTo(weakSelf.journals);
        make.bottom.equalTo(weakSelf.journals);

    }];
    
    [self.addJournal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view);
        make.centerY.equalTo(weakSelf.view);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
    }];
    
    [self.addTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.addJournal);
        make.centerY.equalTo(self.addJournal).offset(50);
        make.height.equalTo(@(40));
        make.width.equalTo(@(80));
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
//        [weakSelf.album setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.album setImage:image forState:UIControlStateHighlighted];
//    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_journal" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_journal_press" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateHighlighted];
    }];
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

- (void)addJournalClick {
    BTAddJournalViewController *vc = [[BTAddJournalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumClick {
    BTMyAlbumViewController *vc = [[BTMyAlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timelineClick {
    BTTimelineViewController *vc = [[BTTimelineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTimelineClick {
    BTAddTimelineViewController *vc = [[BTAddTimelineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userCenterClick {
    BTUserCenterViewController *vc = [[BTUserCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)journalsClick {
    BTJournalListViewController *vc = [[BTJournalListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatClick {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:userID] && [[NSUserDefaults standardUserDefaults] valueForKey:userPassword]) {
        [[BTXMPPTool sharedInstance] login:nil];
        BTIMHomePageViewController *vc = [[BTIMHomePageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)settingClick {
    BTSettingViewController *vc = [[BTSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)userCenter {
    if (!_userCenter) {
        _userCenter = [[UIButton alloc] init];
        _userCenter.backgroundColor = [UIColor blueColor];
        [_userCenter setTitle:@"我的" forState:UIControlStateNormal];
        [_userCenter addTarget:self action:@selector(userCenterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userCenter;
}

- (UIButton *)setting {
    if (!_setting) {
        _setting = [[UIButton alloc] init];
        _setting.backgroundColor = [UIColor blueColor];
        [_setting setTitle:@"设置" forState:UIControlStateNormal];
        [_setting addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setting;
}

- (UIButton *)timeline {
    if (!_timeline) {
        _timeline = [[UIButton alloc] init];
        _timeline.backgroundColor = [UIColor blueColor];
        [_timeline setTitle:@"时光轴" forState:UIControlStateNormal];
        [_timeline addTarget:self action:@selector(timelineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeline;
}

- (UIButton *)album {
    if (!_album) {
        _album = [[UIButton alloc] init];
        _album.backgroundColor = [UIColor blueColor];
        [_album setTitle:@"相册" forState:UIControlStateNormal];
        [_album addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _album;
}

- (UIButton *)journals {
    if (!_journals) {
        _journals = [[UIButton alloc] init];
        [_journals addTarget:self action:@selector(journalsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _journals;
}

- (UIButton *)chat {
    if (!_chat) {
        _chat = [[UIButton alloc] init];
        [_chat addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chat;
}

- (UIButton *)addJournal {
    if (!_addJournal) {
        _addJournal = [[UIButton alloc] init];
        [_addJournal setTitle:@"记日记" forState:UIControlStateNormal];
        _addJournal.backgroundColor = [UIColor blueColor];
        [_addJournal addTarget:self action:@selector(addJournalClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addJournal;
}

- (UIButton *)addTimeline {
    if (!_addTimeline) {
        _addTimeline = [[UIButton alloc] init];
        [_addTimeline setTitle:@"记点滴" forState:UIControlStateNormal];
        _addTimeline.backgroundColor = [UIColor blueColor];
        [_addTimeline addTarget:self action:@selector(addTimelineClick) forControlEvents:UIControlEventTouchUpInside];
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
