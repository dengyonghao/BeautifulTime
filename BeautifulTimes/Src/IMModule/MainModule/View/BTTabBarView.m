//
//  BTTabBarView.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTabBarView.h"
#import "BTTabBarButton.h"

@interface BTTabBarView ()

@property (nonatomic,strong) NSMutableArray *buttons;
@property (nonatomic,weak) BTTabBarButton *tabButton;

@end


@implementation BTTabBarView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //self.backgroundColor=[UIColor redColor];
    }
    return self;
}

#pragma mark  添加按钮的方法
-(void)addTabBarButtonItem:(UITabBarItem *)item
{
    
    //1.添加按钮
    BTTabBarButton *tabButton = [[BTTabBarButton alloc]init];
    [self addSubview:tabButton];
    [self.buttons addObject:tabButton];
    
    tabButton.item = item;  //属性传给自定义的按钮
    [tabButton addTarget:self action:@selector(tabButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //2.如果是第一个的话  默认选中
    if(self.buttons.count == 1){
        [self tabButtonClick:tabButton];
    }
}

#pragma mark 按钮点击的方法
-(void)tabButtonClick:(BTTabBarButton*)sender
{
    //调用代理方法
    if([self.delegate respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)]){
        [self.delegate tabBar:self didSelectedButtonFrom:self.tabButton.tag to:sender.tag];
    }
    
    self.tabButton.selected=NO;  //当前选中的按钮取消选中状态
    sender.selected=YES; //被点击的按钮选中
    self.tabButton=sender;
    
}

-(void)layoutSubviews
{
    [super subviews];
    CGFloat btnW = self.width / self.buttons.count;
    CGFloat btnH = self.height;
    CGFloat btnY = 0;
    for(int i = 0; i < self.buttons.count; i++){
        BTTabBarButton *tabButton = self.buttons[i];
        tabButton.tag = i;
        CGFloat btnX = i * btnW;
        tabButton.frame = CGRectMake(btnX, btnY, btnW, btnH);
    }
}

-(NSMutableArray *)buttons
{
    if(_buttons == nil){
        _buttons = [NSMutableArray arrayWithCapacity:5];
    }
    return _buttons;
}

@end