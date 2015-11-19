//
//  BTRecordViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTRecordViewController.h"
#import "BTCircularProgressButton.h"
#import <AVFoundation/AVFoundation.h>

static CGFloat const durationCircleSize = 112.0f;
static CGFloat const recorderDuration = 600;

@interface BTRecordViewController () <AVAudioRecorderDelegate> {
    int count;
}

@property (nonatomic, strong) BTCircularProgressButton *progressButton; /**< 进度环 */
@property (nonatomic, strong) UIButton *recordIcon;
@property (nonatomic, strong) UIImageView *circlesImageView;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) AVAudioSession * audioSession;
@property (nonatomic, strong) NSTimer *timer;                    //定时器
@property (nonatomic, strong) AVAudioRecorder *recorder;         //录音
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSString *audioRecordFilePath;

@end

@implementation BTRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"录音";
    [self.bodyView addSubview:self.progressButton];
    [self.bodyView addSubview:self.recordIcon];
    [self.bodyView addSubview:self.circlesImageView];
    [self.bodyView addSubview:self.recordButton];
    [self.bodyView addSubview:self.playButton];
    [self.bodyView addSubview:self.resetButton];
    [self.bodyView addSubview:self.saveButton];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    [self.progressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(durationCircleSize));
        make.height.equalTo(@(durationCircleSize));
        make.centerX.equalTo(weakSelf.bodyView.mas_centerX);
        make.centerY.equalTo(weakSelf.bodyView).with.offset(-48);
    }];
    
    [self.recordIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressButton);
        make.centerY.equalTo(weakSelf.progressButton);
        make.width.equalTo(@(100));
        make.height.equalTo(@(44));
    }];
    
    [self.circlesImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.progressButton);
        make.centerY.equalTo(weakSelf.progressButton);
        make.width.equalTo(@(132));
        make.height.equalTo(@(132));
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(100));
        make.height.equalTo(@(40));
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)initAudioSession {
    if (!self.audioSession) {
        self.audioSession = [AVAudioSession sharedInstance];
        [self.audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
        [self.audioSession setActive:YES error:nil];
    }
}

- (void)deallocAudioSession {
    if (self.audioSession) {
        self.audioSession = [AVAudioSession sharedInstance];
        [self.audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.audioSession setActive:NO error:nil];
    }
}

- (void)playRecord {
    [self.recorder stop];
    [self initAudioSession];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSURL alloc] initWithString:self.audioRecordFilePath] error:nil];
    [self.player play];
}

- (void)stopPlay {
    if (!self.player) {
        [self.player stop];
    }
    [self deallocAudioSession];
}

#pragma mark AVAudioRecorder设置
- (void)startRecord {
    [self initAudioSession];
    //录音参数设置设置
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey];
    //录音通道数  1 或 2
    [recordSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    //录音文件保存的URL
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    NSString *catchPath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    self.audioRecordFilePath=[catchPath stringByAppendingPathComponent:[NSString stringWithFormat:@"AudioRecord/%@.aac", cfuuidString]];
    
    //判断目录是否存在不存在则创建
    NSString *audioRecordDirectories = [self.audioRecordFilePath stringByDeletingLastPathComponent];
    NSLog(@"------------%@",audioRecordDirectories);
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:audioRecordDirectories]) {
        [fileManager createDirectoryAtPath:audioRecordDirectories withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSURL *url = [NSURL fileURLWithPath:self.audioRecordFilePath];
    NSError *error=nil;
    //初始化AVAudioRecorder
    _recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    if (error != nil) {
        
    }else{
        if ([_recorder prepareToRecord]) {
            //录音最长时间
            [_recorder recordForDuration:recorderDuration];
            _recorder.delegate = self;
            [_recorder record];
            
            //开启定时器
            count = 0;
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(progressTime:) userInfo:nil repeats:YES];
        }
    }
    [self deallocAudioSession];
}

- (void)progressTime:(NSTimer *)timer {
    count ++;
    [self nowPlayingRecordCurrentTime:count * [timer timeInterval] duration:recorderDuration];
}

- (void)stopRecord {
    [_recorder stop];
    _recorder = nil;
    [_timer invalidate];
    _timer = nil;
    count = 0;
    [self deallocAudioSession];
    [self stopWork];
}

- (void)startWorking
{
    self.circlesImageView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(1.0);
    animation.toValue = @(2.0);
    animation.repeatCount = MAXFLOAT;
    [self.circlesImageView.layer addAnimation:animation forKey:@"animateTransform"];
    [self startRecord];
}

- (void)stopWork
{
    self.circlesImageView.hidden = YES;
    [self.circlesImageView.layer removeAllAnimations];
}

#pragma mark - AVAudioRecorder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //录音结束
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    //录音编码错误
}

- (void)nowPlayingRecordCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    [self.progressButton setProgress:currentTime duration:duration];
}

- (BTCircularProgressButton *)progressButton
{
    if (!_progressButton) {
        _progressButton = [[BTCircularProgressButton alloc] initWithFrame:CGRectMake(0, 0, durationCircleSize, durationCircleSize)
                                                            progressColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_c"]
                                                                lineWidth:8.0f];
        _progressButton.userInteractionEnabled = NO;
    }
    return _progressButton;
}

- (UIButton *)recordIcon {
    if (!_recordIcon) {
        _recordIcon = [[UIButton alloc] init];
        [_recordIcon setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(playRecord) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordIcon;
}

- (UIImageView *)circlesImageView {
    if (!_circlesImageView) {
        _circlesImageView = [[UIImageView alloc] init];
        _circlesImageView.hidden = NO;
        _circlesImageView.image = BT_LOADIMAGE(@"ic_circle1");

    }
    return _circlesImageView;
}

- (UIButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[UIButton alloc] init];
        [_recordButton setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_recordButton addTarget:self action:@selector(startWorking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _recordButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
        [_playButton setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(startWorking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        [_saveButton setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(startWorking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}


- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        [_resetButton setImage:BT_LOADIMAGE(@"btn_voice") forState:UIControlStateNormal];
        [_resetButton addTarget:self action:@selector(startWorking) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}



@end
