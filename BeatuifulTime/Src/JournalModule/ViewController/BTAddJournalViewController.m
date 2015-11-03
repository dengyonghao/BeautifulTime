//
//  BTAddJournalViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTAddJournalViewController.h"
#import "AppDelegate.h"
#import "Journal.h"

@interface BTAddJournalViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *site;
@property (nonatomic, strong) UIButton *weather;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UIButton *date;
@property (nonatomic, strong) UITextView *content;

@end

@implementation BTAddJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记笔记";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.date];
    [self.bodyView addSubview:self.site];
    [self.bodyView addSubview:self.weather];
    [self.bodyView addSubview:self.photos];
    [self.bodyView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat OFFSET = 10.0f;
    CGFloat BUTTONWIDTH = (BT_SCREEN_WIDTH - 2 * OFFSET) / 4;
    
    WS(weakSelf);
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.site mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(BUTTONWIDTH + OFFSET);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(BUTTONWIDTH + OFFSET);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    Journal *newJournal = [NSEntityDescription insertNewObjectForEntityForName:@"Journal" inManagedObjectContext:[AppDelegate getInstance].coreDataHelper.context];
    newJournal.journalContent = self.content.text;
    [[AppDelegate getInstance].coreDataHelper saveContext];
}

- (UIScrollView *)bodyScrollView {
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] init];
        _bodyScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH - 20, BT_SCREEN_HEIGHT);
//        _bodyScrollView.backgroundColor = [UIColor redColor];
    }
    return _bodyScrollView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.delegate = self;
    }
    return _content;
}

- (UIButton *)photos {
    if (!_photos) {
        _photos = [[UIButton alloc] init];
    }
    return _photos;
}

- (UIButton *)site {
    if (!_site) {
        _site = [[UIButton alloc] init];
    }
    return _site;
}

- (UIButton *)weather {
    if (!_weather) {
        _weather = [[UIButton alloc] init];
    }
    return _weather;
}

- (UIButton *)records {
    if (!_records) {
        _records = [[UIButton alloc] init];
    }
    return _records;
}

- (UIButton *)date {
    if (!_date) {
        _date = [[UIButton alloc] init];
    }
    return _date;
}

@end
