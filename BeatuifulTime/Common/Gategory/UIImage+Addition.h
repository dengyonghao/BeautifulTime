//
//  UIImage+Addition.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/23.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

/**
 *  创建一个指定大小,颜色值的纯色图片
 *
 *  @param color 颜色
 *  @param size  大小
 *
 *  @return UIImage实例
 */
+(UIImage*)createImageWithColor:(UIColor*)color andSize:(CGSize)size;

@end
