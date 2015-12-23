//
//  UIView+BTAddition.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/15.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "UIView+BTAddition.h"

@implementation UIView (BTAddition)

- (id)setBorderWithWidth:(CGFloat)width color:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    self.layer.borderColor = color.CGColor;
    self.layer.borderWidth = width;
    if (cornerRadius) {
        [self.layer setMasksToBounds:YES];
        self.layer.cornerRadius = cornerRadius;
    }
    return self;
}

@end
