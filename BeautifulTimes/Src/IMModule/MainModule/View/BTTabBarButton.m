//
//  BTTabBarButton.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTabBarButton.h"

#define tabbarButtonImageRatio 0.65

@interface BTTabBarButton ()


@end

@implementation BTTabBarButton

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        self.imageView.contentMode=UIViewContentModeCenter;
        self.titleLabel.textAlignment=NSTextAlignmentCenter;
        self.titleLabel.font = BT_FONTSIZE(11);
        
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect {
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;
    return CGRectMake(0, 0, imageW, imageH);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGFloat titleW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height * tabbarButtonImageRatio;
    CGFloat titleH = contentRect.size.height - imageH;
    
    return CGRectMake(0, imageH, titleW, titleH);
}
#pragma mark 设置item
-(void)setItem:(UITabBarItem *)item
{
    _item=item;
    //1.KVO  监听属性值的改变
    
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"image" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImage" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    
    //设置按钮的颜色
    [self setImage:item.image forState:UIControlStateNormal];
    [self setImage:item.selectedImage forState:UIControlStateSelected];
    [self setTitle:item.title forState:UIControlStateNormal];
    
}


#pragma mark 监听item值的改变
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    [self setTitle:self.item.title forState:UIControlStateNormal];
        
}

-(void)dealloc {
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"title"];
    [self.item removeObserver:self forKeyPath:@"image"];
    [self.item removeObserver:self forKeyPath:@"selectedImage"];
}

@end
