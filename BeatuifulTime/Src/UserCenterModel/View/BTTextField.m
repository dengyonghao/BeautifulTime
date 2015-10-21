//
//  BTTextField.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTTextField.h"

@interface BTTextField ()

@property (nonatomic,strong) UIImageView *img;

@end

@implementation BTTextField

-(instancetype)init
{
    self=[super init];
    if (self) {
        self.font=[UIFont systemFontOfSize:13];
    }
    return self;
}

-(void)setContentPlaceholder:(NSString *)constomPlaceholder
{
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName]=[UIColor grayColor];
    self.attributedPlaceholder=[[NSAttributedString alloc]initWithString:constomPlaceholder attributes:dict];
    
}
-(void)setImage:(NSString *)image
{
    UIImageView *img=[[UIImageView alloc]init];
    img.frame=CGRectMake(0, 10, 30, 30);
    img.image=[UIImage imageNamed:image];
    self.leftViewMode=UITextFieldViewModeAlways; //总是显示
    self.leftView=img;
    self.img=img;
}
-(CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, 10, 30, 0);
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.img.frame=CGRectMake(0, 0, 30, 30);
}

@end
