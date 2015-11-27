//
//  BTPhotoCollectionViewCell.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/11/18.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BTPhotoCollectionViewCell : UICollectionViewCell

- (void)bindData:(PHAsset *)asset;

@end
