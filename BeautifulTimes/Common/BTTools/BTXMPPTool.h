//
//  BTXMPPTool.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "XMPPFramework.h"

typedef enum{
    XMPPResultSuccess,   //登陆成功
    XMPPResultFaiture,     //登陆失败
    XMPPResultNetworkErr,  //网络出错
    XMPPResultRegisterSuccess,  //注册成功
    XMPPResultRegisterFailture,  //注册失败
} XMPPResultType;

typedef  void (^XMPPResultBlock)(XMPPResultType xmppType);

@interface BTXMPPTool : NSObject
@property (nonatomic,strong) XMPPStream *xmppStream;
@property (nonatomic,strong) XMPPJID *jid;
@property (nonatomic,assign,getter=isRegisterOperation) BOOL registerOperation;
//添加花名册模块
@property (nonatomic,strong,readonly) XMPPRoster *roster;
@property (nonatomic,strong,readonly) XMPPRosterCoreDataStorage *rosterStorage;
//聊天模块
@property (nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *messageStroage;
//电子名片
@property (nonatomic,strong,readonly) XMPPvCardTempModule *vCard;
//头像模块
@property (nonatomic,strong,readonly) XMPPvCardAvatarModule  *avatar;

+ (instancetype)sharedInstance;

- (void)login:(XMPPResultBlock)xmppBlock;

- (void)xmppLoginOut;

- (void)regist:(XMPPResultBlock)xmppType;

- (void)addFried:(XMPPJID *)friedJid;

@end
