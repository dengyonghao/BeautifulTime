//
//  ContacterCell.m
//  微信
//
//  Created by Think_lion on 15/6/18.
//  Copyright (c) 2015年 Think_lion. All rights reserved.
//

#import "BTContacterCell.h"
//#import "BTContacterView.h"

@interface BTContacterCell ()
//@property (nonatomic,weak) ContacterView *cView;

@end


@implementation BTContacterCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        //添加子控件
        [self adChildView];
    }
    return self;
}

//设置模型数据
-(void)setContacerModel:(BTContacterModel *)contacerModel
{
   // _contacerModel=contacerModel;
//    self.cView.BTcontacterModel=contacerModel;
    
}
#pragma mark 初始化单元格
+(instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    BTContacterCell *cell=[tableView dequeueReusableCellWithIdentifier:indentifier];
    if(cell==nil){
        cell=[[BTContacterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    return cell;
}

-(void)adChildView
{
   
}

@end
