//
//  BTMessageFrameModel.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/20.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTMessageFrameModel.h"

#define headIconW 40
//聊天内容的文字距离四边的距离
#define ContentEdgeInsets 20

@implementation BTMessageFrameModel



//根据模型设置frame
-(void)setMessageModel:(BTChatMessageModel *)messageModel
{
    _messageModel=messageModel;
    CGFloat padding =10;  //间距为10
    
    //1.设置时间的frame (不需要隐藏时间)
    if(messageModel.hiddenTime==NO){
        CGFloat timeX=0;
        CGFloat timeY=0;
        CGFloat timeW=BT_SCREEN_WIDTH;
        CGFloat timeH=30;
        _timeFrame=CGRectMake(timeX, timeY, timeW, timeH);
    }
    //2.设置头像
    CGFloat iconW=headIconW;
    CGFloat iconH=iconW;
    CGFloat iconX=0;
    CGFloat iconY=CGRectGetMaxY(_timeFrame)+padding;
    //如果是自己
    if(messageModel.isCurrentUser){
        iconX=BT_SCREEN_WIDTH-iconW-padding;
    }else{  //是正在和自己聊天的用户
        iconX=padding;
    }
    _headFrame=CGRectMake(iconX, iconY, iconW, iconH);
    //3.设置聊天内容的frame  (聊天内容的宽度最大100  高不限)
    CGSize contentSize=CGSizeMake(200, MAXFLOAT);
    CGRect contentR;
    //如果有表情的话
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:messageModel.attributedBody];
    contentR=[text boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    //    }else{
    //        contentR=[messageModel.body boundingRectWithSize:contentSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:contentFont} context:nil];
    //    }
    
    
    CGFloat contentW=contentR.size.width+ContentEdgeInsets*2;
    CGFloat contentH=contentR.size.height+ContentEdgeInsets*2;
    CGFloat contentY=iconY-2;
    CGFloat contentX=0;
    //如果是自己
    if(messageModel.isCurrentUser){
        contentX=iconX-padding-contentW;
    }else{  //如果是聊天用户
        contentX=CGRectGetMaxX(_headFrame)+padding;
    }
    _contentFrame=CGRectMake(contentX, contentY, contentW, contentH);
    //单元格的高度
    CGFloat maxIconY=CGRectGetMaxY(_headFrame);
    CGFloat maxContentY=CGRectGetMaxY(_contentFrame);
    
    _cellHeight=MAX(maxIconY, maxContentY)+padding;
    //4.聊天单元view的frame
    _chatFrame=CGRectMake(0, 0, BT_SCREEN_WIDTH, _cellHeight);
}

@end
