//
//  BTXMPPTool.h
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "XMPPFramework.h"
#import "BTBlockType.h"
#import "XMPPStreamManagementMemoryStorage.h"
#import "XMPPIncomingFileTransfer.h"
#import "XMPPOutgoingFileTransfer.h"

typedef enum{
    XMPPResultSuccess,   //登陆成功
    XMPPResultFaiture,     //登陆失败
    XMPPResultNetworkErr,  //网络出错
    XMPPResultRegisterSuccess,  //注册成功
    XMPPResultRegisterFailture,  //注册失败
} XMPPResultType;

typedef  void (^XMPPResultBlock)(XMPPResultType xmppType);

@interface BTXMPPTool : NSObject

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPJID *jid;

@property (nonatomic, strong) XMPPStreamManagementMemoryStorage *storage;
@property (nonatomic, strong) XMPPStreamManagement *xmppStreamManagement;
@property (nonatomic, strong) XMPPIncomingFileTransfer *xmppIncomingFileTransfer;
@property (nonatomic, strong) XMPPOutgoingFileTransfer *xmppOutgoingFileTransfer;

@property (nonatomic,strong,readonly) XMPPRoster *roster;
@property (nonatomic,strong,readonly) XMPPRosterCoreDataStorage *rosterStorage;
@property (nonatomic,strong,readonly) XMPPMessageArchivingCoreDataStorage *messageStroage;//聊天内容模块
@property (nonatomic,strong,readonly) XMPPvCardTempModule *vCard; //电子名片
@property (nonatomic,strong,readonly) XMPPvCardAvatarModule *avatar; //头像模块
@property (nonatomic, assign,getter = isRegisterOperation) BOOL registerOperation;

/**
 *  单例
 *
 *  @return self
 */
+ (instancetype)sharedInstance;

/**
 *  用户登录
 *
 *  @param xmppBlock 返回状态
 */
- (void)login:(XMPPResultBlock)xmppBlock;

/**
 *  退出登录
 */
- (void)xmppLoginOut;

/**
 *  注册用户
 *
 *  @param xmppType 返回状态
 */
- (void)regist:(XMPPResultBlock)xmppType;

/**
 *  查找用户
 *
 *  @param searchValue 查找内容
 */
- (void)searchUserInfo:(NSString *)searchValue Success:(ArrayResponseBlock)success failure:(errorBlock)error;

/**
 *  添加好友
 *
 *  @param friedJid 好友id
 */
- (void)addFried:(XMPPJID *)friedJid;

/**
 *  处理好友申请
 *
 *  @param userJid 用户jid
 *  @param result  YES为同意， NO不拒绝
 */
- (void)handleAddFriendReqest:(XMPPJID *)userJid result:(BOOL)result;

/**
 *  删除好友
 *
 *  @param friedJid 好友id
 */
- (void)removeFried:(XMPPJID *)friedJid;

/**
 *  好友分组
 *
 *  @return 分组信息
 */
- (NSFetchedResultsController *)fetchedGroupResultsController;

/**
 *  发送信息
 *
 *  @param msg    内容
 *  @param type   类型
 *  @param toName 接收方
 */
- (void)sendMessage:(NSString *)msg type:(NSString *)type to:(XMPPJID *)toName;

/**
 *  修改密码
 *
 *  @param checkPassword 新密码
 */
- (void)changePassworduseWord:(NSString *)checkPassword;

@end
