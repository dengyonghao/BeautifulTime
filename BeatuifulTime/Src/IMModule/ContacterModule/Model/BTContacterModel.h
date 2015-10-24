//
//  BTContacterModel.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/23.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTContacterModel : NSObject

@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic,copy) NSString *tidStr;  //好朋友的名字
@property (nonatomic,weak) UIImage *headIcon ;//好朋友的头像
@property (nonatomic,copy) NSString *nickName; //用户的匿名
@property (nonatomic,copy) NSString *py;  //用户名的拼音 用来处理分区头
//记录用户当前状态    //   “0”- 在线    “1”- 离开    “2”- 离线

@property (nonatomic,assign) int userStatus;  //未用  [user.sectionNum intValue]
//要跳转的类
@property (nonatomic,strong) Class vcClass;

@end
