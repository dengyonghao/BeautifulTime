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
#import "BTWeatherModel.h"
#import "AppDelegate.h"
#import "BTJournalListViewController.h"
#import "BTCircularProgressButton.h"
#import <AVFoundation/AVFoundation.h>

static const CGFloat itemWidth = 70.0f;

@interface BTEditJournalViewController () <UITextViewDelegate, UIActionSheetDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate> {
    AVAudioPlayer *_player;
    AVAudioSession *_audioSession;
    BOOL isEditModel;
}

@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) BTWeatherStatusVeiw *weatherStatusView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIImageView *photos;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) UIActionSheet * selectActionSheet;
@property (nonatomic, strong) BTCircularProgressButton *progressButton; /**< 进度环 */
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) NSTimer *timer;

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
    [self.toolsView addSubview:self.progressButton];
    [self.toolsView addSubview:self.playButton];
    [self.toolsView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
    _audioSession = [AVAudioSession sharedInstance];
    isEditModel = NO;
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
    
    [self.progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.journal.records == nil || [self.journal.records isEqualToString:@""]) {
        [self.records setHidden:NO];
        [self.progressButton setHidden:YES];
        [self.playButton setHidden:YES];
    } else {
        [self.records setHidden:YES];
        [self.progressButton setHidden:NO];
        [self.playButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backButtonClick {
    [super backButtonClick];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTJournalListViewController class]]) {
            BTJournalListViewController *vc = (BTJournalListViewController *)controller;
            [vc initDataSource];
            [vc.tableView reloadData];
        }
    }
}

- (void)finishButtonClick {
    if (!isEditModel) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:nil];
        [actionSheet addButtonWithTitle:@"修改日记"];
        [actionSheet addButtonWithTitle:@"删除日记"];
        [actionSheet addButtonWithTitle:@"取消"];
        //设置取消按钮
        actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
        [actionSheet showFromRect:self.view.superview.bounds inView:self.view.superview animated:NO];
        
        if (self.selectActionSheet) {
            self.selectActionSheet = nil;
        }
        
        self.selectActionSheet = actionSheet;

    } else {
        isEditModel = NO;
        [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
        self.content.editable = NO;
        NSData* data = [self.content.text dataUsingEncoding:NSUTF8StringEncoding];
        self.journal.journalContent = data;
        
    }
}

- (void)playButtonClick:(UIButton *)sender {
    if (!self.playButton.selected) {
        self.playButton.selected = YES;
        [self playRecord];
    }
    else {
        self.playButton.selected = NO;
        [self stopPlay];
    }
}

- (void)playRecord {
    [_audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [_audioSession setActive:YES error:nil];
    if (self.journal.records){
        if (!_player) {
            NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [directoryPaths objectAtIndex:0];
            NSString *recordPath = [documentDirectory stringByAppendingPathComponent:self.journal.records];
            NSData *recordData = [[NSData alloc] initWithContentsOfFile:recordPath];
            _player = [[AVAudioPlayer alloc] initWithData:recordData error:nil];
            _player.delegate = self;
            _player.volume = 1;
        }
        [_player prepareToPlay];
        [_player play];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(playProgressTime:) userInfo:nil repeats:YES];
    }
}

- (void)stopPlay {
    [_player stop];
    _player.currentTime = 0.0f;
    [self.timer invalidate];
    self.timer = nil;
    [self nowPlayingRecordCurrentTime:0 duration:_player.duration];
    [_audioSession setActive:NO error:nil];
}

- (void)playProgressTime:(NSTimer *)timer {
    [self nowPlayingRecordCurrentTime:_player.currentTime duration:_player.duration];
}

- (void)nowPlayingRecordCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration {
    [self.progressButton setProgress:currentTime duration:duration];
}

#pragma mark - AVAudioPlayer delegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        [self.timer invalidate];
        self.timer = nil;
        self.playButton.selected = NO;
        [self nowPlayingRecordCurrentTime:0 duration:player.duration];
        _player = nil;
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            isEditModel = YES;
            [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
            self.content.editable = YES;
        }
            break;
            
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        [[AppDelegate getInstance].coreDataHelper.context deleteObject:self.journal];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[BTJournalListViewController class]]) {
                BTJournalListViewController *vc = (BTJournalListViewController *)controller;
                [vc initDataSource];
                [vc.tableView reloadData];
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }
}


- (void)recordsClick {

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
        if (self.journal.weather) {
            BTWeatherModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:self.journal.weather];
            [_weatherStatusView bindData:model];
        }
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
        _content.editable = NO;
        [_content setFont:BT_FONTSIZE(18)];
        [_content setBorderWithWidth:1 color:nil cornerRadius:6];
        if (self.journal.journalContent) {
            NSString *content = [[NSString alloc] initWithData:self.journal.journalContent encoding:NSUTF8StringEncoding];
            _content.text = content;
        }
    }
    return _content;
}

- (UIImageView *)photos {
    if (!_photos) {
        _photos = [[UIImageView alloc] init];
        [_photos setImage:BT_LOADIMAGE(@"com_ic_photo")];
        [_photos setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        _photos.userInteractionEnabled = YES;
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [directoryPaths objectAtIndex:0];
        NSString *photosPath = [documentDirectory stringByAppendingPathComponent:self.journal.photos];
        NSData *photosData = [[NSData alloc] initWithContentsOfFile:photosPath];
        
        if (photosData) {
            NSArray *photos = [NSKeyedUnarchiver unarchiveObjectWithData:photosData];
            if (photos.count > 0) {
                _photos.image = photos[0];
            }
        }
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


- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

- (BTCircularProgressButton *)progressButton {
    if (!_progressButton) {
        _progressButton = [[BTCircularProgressButton alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)
                                                            progressColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_c"]
                                                                lineWidth:4.0f];
        _progressButton.userInteractionEnabled = NO;
        [_progressButton setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];

    }
    return _progressButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setTitle:@"开始播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"停止播放" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

@end
