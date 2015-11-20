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

@interface BTRecordViewController () <AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
    AVAudioPlayer *player;
    AVAudioRecorder *recorder;
    AVAudioSession * audioSession;
}

@property (nonatomic, strong) BTCircularProgressButton *progressButton; /**< 进度环 */
@property (nonatomic, strong) UIButton *recordIcon;
@property (nonatomic, strong) UIImageView *circlesImageView;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) NSTimer *timer;                    //定时器
@property (nonatomic, strong) NSURL *recordUrl;

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
    audioSession = [AVAudioSession sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self initAudioSession];
    [self.playButton setHidden:YES];
    [self.resetButton setHidden:YES];
    [self.saveButton setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self deallocAudioSession];
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
        make.width.equalTo(@(56));
        make.height.equalTo(@(56));
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
        make.width.equalTo(@(140));
        make.height.equalTo(@(40));
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.bodyView);
        make.bottom.equalTo(weakSelf.bodyView).offset(-60);
        make.width.equalTo(@(140));
        make.height.equalTo(@(40));
    }];
    
    [self.resetButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.left.equalTo(weakSelf.playButton).offset(- (40 + 15));
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];
    
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.playButton);
        make.right.equalTo(weakSelf.playButton).offset(40 + 15);
        make.width.equalTo(@(40));
        make.height.equalTo(@(40));
    }];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)recordButtonClick:(UIButton *)sender {
    if (!self.recordButton.selected) {
        self.recordButton.selected = YES;
        [self startRecord];
        [self startAnimate];
    }
    else {
        self.recordButton.selected = NO;
        [self stopRecord];
        [self stopAnimate];
        self.recordButton.hidden = YES;
        self.playButton.hidden = NO;
    }
    
}

- (void)saveButtonClick:(UIButton *)sender {

}

- (void)resetButtonClick:(UIButton *)sender {

}

- (void)playButtonClick:(UIButton *)sender {
    if (!self.playButton.selected) {
        self.playButton.selected = YES;
        [self playRecord];
        [self startAnimate];
    }
    else {
        self.playButton.selected = NO;
        [self stopPlay];
        [self stopAnimate];
        self.recordButton.hidden = NO;
        self.playButton.hidden = YES;
    }
}

- (void)playRecord {
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
    if (self.recordUrl != nil){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordUrl error:nil];
        player.delegate = self;
        [player prepareToPlay];
        player.volume = 1;
        [player play];
    }
}

- (void)stopPlay {
    [player stop];
    [audioSession setActive:NO error:nil];
}

#pragma mark AVAudioRecorder设置
- (void)startRecord {
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc]init];
    
    //设置录音格式  AVFormatIDKey==kAudioFormatLinearPCM
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）, 采样率必须要设为11025才能使转化成mp3格式后不会失真
    [recordSetting setValue:[NSNumber numberWithFloat:11025.0] forKey:AVSampleRateKey];
    //录音通道数  1 或 2 ，要转换成mp3格式必须为双通道
    [recordSetting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    //线性采样位数  8、16、24、32
    [recordSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音的质量
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSDate *now = [NSDate date];
    NSString *messageId = [NSString stringWithFormat:@"%d",(int)now.timeIntervalSince1970];
    for(int i = 0; i < 5; i++){
        int num = rand() % 10;
        NSString *str = [NSString stringWithFormat:@"%d",num];
        messageId = [messageId stringByAppendingString:str];
    }

    //存储录音文件
    self.recordUrl = [NSURL URLWithString:[NSTemporaryDirectory() stringByAppendingString:@"selfRecord.caf"]];
    
    //初始化
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc] initWithURL:self.recordUrl settings:recordSetting error:nil];

    if (error != nil) {
        
    }
    else {
        if ([recorder prepareToRecord]) {
            [recorder recordForDuration:recorderDuration];
            recorder.delegate = self;
            [recorder record];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(progressTime:) userInfo:nil repeats:YES];
        }
        
        if (![recorder isRecording]) {
            [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];//设置类别,表示该应用同时支持播放和录音
            [audioSession setActive:YES error:nil];//启动音频会话管理,此时会阻断后台音乐的播放.
            
            [recorder prepareToRecord];
            [recorder peakPowerForChannel:0.0];
            [recorder record];
        }
    }
}

- (void)progressTime:(NSTimer *)timer {
    [self nowPlayingRecordCurrentTime:recorder.currentTime duration:recorderDuration];
}

- (void)stopRecord {
    [recorder stop];                          //录音停止
    [audioSession setActive:NO error:nil];         //一定要在录音停止以后再
    [_timer invalidate];
    _timer = nil;
}

- (void)startAnimate {
    self.circlesImageView.hidden = NO;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 1;
    animation.removedOnCompletion = NO;
    animation.fromValue = @(1.0);
    animation.toValue = @(2.0);
    animation.repeatCount = MAXFLOAT;
    [self.circlesImageView.layer addAnimation:animation forKey:@"animateTransform"];
}

- (void)stopAnimate {
    self.circlesImageView.hidden = YES;
    [self.circlesImageView.layer removeAllAnimations];
}

#pragma mark - AVAudioRecorder delegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    //录音结束
    if (flag) {
        [self nowPlayingRecordCurrentTime:0 duration:recorderDuration];
    }
}
- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error
{
    //录音编码错误
}

- (void)nowPlayingRecordCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration
{
    [self.progressButton setProgress:currentTime duration:duration];
}

#pragma mark - BTThemeListenerProtocol
- (void)BTThemeDidNeedUpdateStyle
{
    [super BTThemeDidNeedUpdateStyle];
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
//        _recordButton.backgroundColor = [UIColor blueColor];
        [_recordButton addTarget:self action:@selector(recordButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_recordButton setTitle:@"开始录音" forState:UIControlStateNormal];
        [_recordButton setTitle:@"停止录音" forState:UIControlStateSelected];
    }
    return _recordButton;
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [[UIButton alloc] init];
//        _playButton.backgroundColor = [UIColor blueColor];
        [_playButton setTitle:@"开始播放" forState:UIControlStateNormal];
        [_playButton setTitle:@"停止播放" forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _playButton;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [[UIButton alloc] init];
        _saveButton.backgroundColor = [UIColor yellowColor];
        [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
}


- (UIButton *)resetButton {
    if (!_resetButton) {
        _resetButton = [[UIButton alloc] init];
        _resetButton.backgroundColor = [UIColor redColor];
        [_resetButton addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

@end