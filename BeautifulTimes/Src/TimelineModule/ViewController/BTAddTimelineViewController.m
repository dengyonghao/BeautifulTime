//
//  BTAddTimelineViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/12/6.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddTimelineViewController.h"
#import "BTAddressBookViewController.h"
#import "BTTimelineToolView.h"
#import "BTTimelineModel.h"
#import "BTTimelineDBManager.h"
#import "BTHomePageViewController.h"

@interface BTAddTimelineViewController ()

@property (nonatomic, strong) BTTimelineToolView *toolView;
@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation BTAddTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记点滴";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.toolView];
    [self.bodyView addSubview:self.contentTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    WS(weakSelf);
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bodyView);
        make.right.equalTo(weakSelf.bodyView);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.bodyView);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 48, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) keyboardWasShown:(NSNotification *) notif{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{

    [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48 - keyboardSize.height)];
    [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48 - keyboardSize.height, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48)];
        [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.contentTextView.frame.size.height  + yOffset)];
        [self.toolView setFrame:CGRectMake(0, self.toolView.frame.origin.y + yOffset, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
    
}


- (void)finishButtonClick {
    BTTimelineModel *model = [[BTTimelineModel alloc] init];
    model.timelineContent = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    model.timelineDate = [NSDate date];
    [[BTTimelineDBManager sharedInstance] addTimelineMessage:model];
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTHomePageViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (BTTimelineToolView *)toolView {
    if (!_toolView) {
        _toolView = [[BTTimelineToolView alloc] init];
    }
    return _toolView;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
    }
    return _contentTextView;
}

@end
