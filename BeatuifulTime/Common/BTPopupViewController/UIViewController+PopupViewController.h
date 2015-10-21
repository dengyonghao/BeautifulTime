//
//  UIViewController+PopupViewController.h
//  CarLife
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLPopupAnimation <NSObject>
@required
- (void)showView:(UIView*)popupView overlayView:(UIView*)overlayView;
- (void)dismissView:(UIView*)popupView overlayView:(UIView*)overlayView completion:(void (^)(void))completion;
@end

@interface UIViewController (PopupViewController)

@property (nonatomic, retain, readonly) UIView *popupView;
@property (nonatomic, retain, readonly) UIView *overlayView;
@property (nonatomic, retain, readonly) id<CLPopupAnimation> popupAnimation;

- (void)presentPopupView:(UIView *)popupView;
- (void)presentPopupView:(UIView *)popupView animation:(id<CLPopupAnimation>)animation;

- (void)dismissPopupView;
- (void)dismissPopupViewWithanimation:(id<CLPopupAnimation>)animation;

@end
