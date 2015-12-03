//
//  BTAddAlbumViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/1.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddAlbumViewController.h"
#import <Photos/Photos.h>

@interface BTAddAlbumViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITextField *albumTitle;
@property (nonatomic, strong) UITextView *briefIntroduction;
@property (nonatomic, strong) UIImageView *albumCover;

@end

@implementation BTAddAlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.bodyView addSubview:self.albumTitle];
    [self.bodyView addSubview:self.briefIntroduction];
    [self.bodyView addSubview:self.albumCover];
    [self addGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.albumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.briefIntroduction mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.albumCover mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 添加手势识别器
- (void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
}
#pragma mark 点击的方法
- (void)tapClick:(id)sender {
    [self.bodyView endEditing:YES];
}

#pragma mark textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textFieldView {
    [textFieldView resignFirstResponder];
    return NO;
}

#pragma mark textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        return NO;
    }
    return YES;
}


#pragma mark - 添加相册
- (void)AddAlbum {
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:self.albumTitle.text];
    } completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            
        } else {
        
        }
    }];
}

- (UITextField *)albumTitle {
    if (!_albumTitle) {
        _albumTitle = [[UITextField alloc] init];
        _albumTitle.delegate = self;
    }
    return _albumTitle;
}

- (UITextView *)briefIntroduction {
    if (!_briefIntroduction) {
        _briefIntroduction = [[UITextView alloc] init];
        _briefIntroduction.delegate = self;
    }
    return _briefIntroduction;
}

- (UIImageView *)albumCover {
    if (!_albumCover) {
        _albumCover = [[UIImageView alloc] init];
    }
    return _albumCover;
}


@end
