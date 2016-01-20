//
//  BTChatViewShow.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatViewShow.h"
#import "BTMessageFrameModel.h"
#import "BTChatMessageModel.h"

@interface BTChatViewShow ()
//时间
@property (nonatomic,weak) UILabel *timeLabel;
//正文内容
@property (nonatomic,weak) UIButton *contentBtn;
//头像
@property (nonatomic,weak) UIImageView *headImage;
//
@end

@implementation BTChatViewShow

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self){
        //1.添加子控件
        [self setupChildView];
        
        
    }
    return self;
}
#pragma mark 添加子控件
-(void)setupChildView
{
    //1.时间
    UILabel *timeLabel=[[UILabel alloc]init];
    timeLabel.textColor=[UIColor lightGrayColor];
    timeLabel.font=BT_FONTSIZE(15);
    timeLabel.textAlignment=NSTextAlignmentCenter;
    timeLabel.textColor=[UIColor lightGrayColor];
    [self addSubview:timeLabel];
    self.timeLabel=timeLabel;
    //2.正文内容
    UIButton *contentBtn=[[UIButton alloc]init];
    [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    contentBtn.titleLabel.font=BT_FONTSIZE(15);
    contentBtn.titleLabel.numberOfLines=0;  //多行显示
    contentBtn.contentEdgeInsets=UIEdgeInsetsMake(10, 20, 20, 20);
    
    
    [self addSubview:contentBtn];
    self.contentBtn=contentBtn;
    //3.头像
    UIImageView *headImage=[[UIImageView alloc]init];
    [self addSubview:headImage];
    self.headImage=headImage;
    
}

//传递模型
-(void)setFrameModel:(BTMessageFrameModel *)frameModel
{
    _frameModel=frameModel;
    //设置自己的frame
    self.frame=frameModel.chatFrame;
    
    //1.时间的frame
    self.timeLabel.frame=frameModel.timeFrame;
    self.timeLabel.text=frameModel.messageModel.time;
    //2头像的frame
    if(frameModel.messageModel.isCurrentUser){  //如果是自己
        UIImage *head=frameModel.messageModel.ownHeadIcon?[UIImage imageWithData:frameModel.messageModel.ownHeadIcon]:[UIImage imageNamed:@"DefaultCompanyHead"];
        self.headImage.image=head;
    }else{  //如果是聊天的用户
        self.headImage.image=frameModel.messageModel.friendHeadIcon?frameModel.messageModel.friendHeadIcon:[UIImage imageNamed:@"DefaultHead"];
    }
    
    self.headImage.frame=frameModel.headFrame;
    //3.内容的frame
    [self.contentBtn setAttributedTitle:frameModel.messageModel.attributedBody forState:UIControlStateNormal];
    
    
    self.contentBtn.frame=frameModel.contentFrame;
    //4.设置聊天的背景图片
    if(frameModel.messageModel.isCurrentUser){  //如果是自己
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:BT_UIIMAGE(@"SenderTextNodeBkg")] forState:UIControlStateNormal];
    }else {  //别人的
        [self.contentBtn setBackgroundImage:[UIImage resizedImage:BT_UIIMAGE(@"ReceiverAppNodeBkg")] forState:UIControlStateNormal];
    }
    
}


@end