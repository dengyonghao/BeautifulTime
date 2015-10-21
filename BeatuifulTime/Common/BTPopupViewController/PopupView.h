//
//  PopupView.h
//  CarLife
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopupView : UIView

@property (nonatomic, weak) UIViewController *parentVC;

- (id)initWithFrame:(CGRect)frame
          parentViewController:(UIViewController *)parentViewController;

@end