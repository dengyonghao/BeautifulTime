//
//  UIViewController+PopupViewController.m
//  CarLife
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "UIViewController+PopupViewController.h"
#import <objc/runtime.h>

#define KeyPopupView @"KeyPopupView"
#define KeyOverlayView @"KeyOverlayView"
#define KeyPopupAnimation @"KeyPopupAnimation"

#define PopupViewTag 930525
#define OverlayViewTag 930526
#define BackgoundViewTag 930527

@interface UIViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, retain) UIView *popupView;
@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) id<CLPopupAnimation> popupAnimation;
@end

@implementation UIViewController (CLPopupViewController)

#pragma public method
- (void)cl_dismissPopupView{
    [self dismissPopupViewWithAnimation:self.popupAnimation];
}
#pragma mark - inline property
- (UIView *)popupView {
    return objc_getAssociatedObject(self, KeyPopupView);
}

- (void)setPopupView:(UIViewController *)popupView {
    objc_setAssociatedObject(self, KeyPopupView, popupView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)overlayView{
    return objc_getAssociatedObject(self, KeyOverlayView);
}

- (void)setOverlayView:(UIView *)overlayView {
    objc_setAssociatedObject(self, KeyOverlayView, overlayView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (id<CLPopupAnimation>)popupAnimation{
    return objc_getAssociatedObject(self, KeyPopupAnimation);
}

- (void)setPopupAnimation:(id<CLPopupAnimation>)popupAnimation{
    objc_setAssociatedObject(self, KeyPopupAnimation, popupAnimation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
#pragma mark - view handle

- (void)presentPopupView:(UIView*)popupView animation:(id<CLPopupAnimation>)animation {
    
    self.popupAnimation = animation;
    [self cl_presentPopupView:popupView];
    if (animation) {
        [animation showView:popupView overlayView:self.overlayView];
    }
}

- (void)presentPopupView:(UIView *)popupView {
    [self cl_presentPopupView:popupView];
}

- (void)cl_presentPopupView:(UIView *)popupView {
    if ([self.overlayView.subviews containsObject:popupView]) return;
    self.popupView = nil;
    self.popupView = popupView;
    self.popupAnimation = nil;
    
    UIView *sourceView = [self topView];
    
    popupView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin |UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    popupView.tag = PopupViewTag;
    
    if (self.overlayView == nil) {
        UIView *overlayView = [[UIView alloc] initWithFrame:sourceView.bounds];
        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayView.tag = OverlayViewTag;
        overlayView.backgroundColor = [UIColor clearColor];
        
        UIView *backgroundView = [[UIView alloc]initWithFrame:sourceView.bounds];
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        backgroundView.tag = BackgoundViewTag;
        [overlayView addSubview:backgroundView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cl_dismissPopupView)];
        tap.delegate = self;
        [overlayView addGestureRecognizer:tap];
        self.overlayView = overlayView;
    }
    [self.overlayView addSubview:popupView];
    [sourceView addSubview:self.overlayView];
    self.overlayView.alpha = 1.0f;
}


- (void)dismissPopupViewWithAnimation:(id<CLPopupAnimation>)animation{
    if (animation) {
        [animation dismissView:self.popupView overlayView:self.overlayView completion:^(void) {
            [self.overlayView removeFromSuperview];
            [self.popupView removeFromSuperview];
            self.popupView = nil;
            self.popupAnimation = nil;
    }];
    }else{
        [self.overlayView removeFromSuperview];
        [self.popupView removeFromSuperview];
        self.popupView = nil;
        self.popupAnimation = nil;
    }
}

- (void)dismissPopupView {
    [self.overlayView removeFromSuperview];
    [self.popupView removeFromSuperview];
    self.popupView = nil;
    self.popupAnimation = nil;
}

- (UIView *)topView {
    UIViewController *recentView = self;
    
    while (recentView.parentViewController != nil) {
        recentView = recentView.parentViewController;
    }
    return recentView.view;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view.tag == BackgoundViewTag) {
        return YES;
    }
    return NO;
}

@end
