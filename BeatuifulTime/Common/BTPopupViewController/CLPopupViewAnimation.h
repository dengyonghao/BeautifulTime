//
//  CLPopupViewAnimation.h
//  CarLife
//
//  Created by dengyonghao on 15/9/8.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+PopupViewController.h"

@interface CLPopupViewAnimation : UIView<CLPopupAnimation>

- (id)initWithPopupStartRect:(CGRect)popupStartRect
       popupEndRect:(CGRect)popupEndRect
     dismissEndRect:(CGRect)dismissEndRect;

@end
