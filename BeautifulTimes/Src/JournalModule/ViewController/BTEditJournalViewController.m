//
//  BTEditJournalViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTEditJournalViewController.h"
#import "BTCalendarView.h"
#import "BTWeatherStatusVeiw.h"
#import "UIView+BTAddition.h"

static const CGFloat itemWidth = 70;

@interface BTEditJournalViewController () <UITextViewDelegate>

@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) BTWeatherStatusVeiw *weatherStatusView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIImageView *photos;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UITextView *content;

@end

@implementation BTEditJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"编辑日记";
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.view addSubview:self.toolsView];
    [self.toolsView addSubview:self.calendarView];
    [self.toolsView addSubview:self.weatherStatusView];
    [self.toolsView addSubview:self.photos];
    [self.toolsView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat OFFSET = 10.0f;
    CGFloat BUTTONWIDTH = (BT_SCREEN_WIDTH - 2 * OFFSET) / 4;
    
    WS(weakSelf);
    
    [self.toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView);
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@(80));
    }];
    CGFloat offset = (BT_SCREEN_WIDTH - 20 - itemWidth * 4) / 5;
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.toolsView).offset(offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.weatherStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.calendarView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.weatherStatusView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(BUTTONWIDTH + OFFSET);
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

- (UIView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[UIView alloc] init];
        _toolsView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_press_e"] ;
        [_toolsView setBorderWithWidth:1 color:nil cornerRadius:8];
    }
    return _toolsView;
}

- (BTCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[BTCalendarView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        [_calendarView bindData:self.journal.journalDate];
    }
    return _calendarView;
}

- (BTWeatherStatusVeiw *)weatherStatusView {
    if (!_weatherStatusView) {
        _weatherStatusView = [[BTWeatherStatusVeiw alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    }
    return _weatherStatusView;
}

- (UIScrollView *)bodyScrollView {
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] init];
        _bodyScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH - 20, BT_SCREEN_HEIGHT);
        [_content setBorderWithWidth:1 color:nil cornerRadius:6];
    }
    return _bodyScrollView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.delegate = self;
        [_content setBorderWithWidth:1 color:nil cornerRadius:6];
    }
    return _content;
}

- (UIImageView *)photos {
    if (!_photos) {
        _photos = [[UIImageView alloc] init];
        [_photos setImage:BT_LOADIMAGE(@"com_ic_photo")];
        [_photos setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        _photos.userInteractionEnabled = YES;
    }
    return _photos;
}

- (UIButton *)records {
    if (!_records) {
        _records = [[UIButton alloc] init];
        [_records setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        [_records setImage:BT_LOADIMAGE(@"com_ic_voice") forState:UIControlStateNormal];
        [_records addTarget:self action:@selector(recordsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _records;
}

@end
