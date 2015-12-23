//
//  PopupView.m
//  CarLife
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "PopupView.h"

@implementation PopupView

- (id)initWithFrame:(CGRect)frame parentViewController:(UIViewController *)parentViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.parentVC = parentViewController;
    }
    return self;
}

@end
