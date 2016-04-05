//
//  BTXMPPTool.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTXMPPTool.h"
#import "BTContacterModel.h"
#import "DDLog.h"
#import "BTNetManager.h"
#import "BTMessageListDBTool.h"

#define kSearchNamespace           @"jabber:iq:search"
#define kSearchXDataNamespace      @"jabber:x:data"
#define kSearchUsersId             @"kSearchUsersId"

#define kChangePasswordNamespace   @"jabber:iq:register"
#define kChangePasswordId          @"kChangePasswordId"

static BTXMPPTool *xmppTool;

@interface BTXMPPTool ()<XMPPStreamDelegate, XMPPRosterDelegate, XMPPIncomingFileTransferDelegate, XMPPOutgoingFileTransferDelegate>
{
    XMPPResultBlock _resultBlock;
    ArrayResponseBlock _searchDataBlock;
    BOOLBlock _successBlock;
    errorBlock _errorBlock;
    XMPPReconnect *_reconnect;
    XMPPMessageArchiving *_messageArching; //定义一个消息对象
    XMPPvCardCoreDataStorage *_vCardStorage; //电子名片存贮
}

@property (nonatomic, strong) XMPPJID *userJid;

@end

@implementation BTXMPPTool

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        xmppTool = [[BTXMPPTool alloc] init];
    });
    
    return xmppTool;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

#pragma mark 初始化xmppstream
-(void)setupXmppStream
{
    self.xmppStream = [[XMPPStream alloc] init];
    self.xmppStream.hostName = ServerAddress;
    self.xmppStream.hostPort = ServerPort;
    [self.xmppStream setKeepAliveInterval:30]; //心跳包时间
    //允许xmpp在后台运行
    self.xmppStream.enableBackgroundingOnSocket = YES;
    
    //添加自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect setAutoReconnect:YES];
    [_reconnect activate:self.xmppStream];
    
    //接入流管理模块
    _storage = [XMPPStreamManagementMemoryStorage new];
    _xmppStreamManagement = [[XMPPStreamManagement alloc] initWithStorage:_storage];
    _xmppStreamManagement.autoResume = YES;
    [_xmppStreamManagement addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [_xmppStreamManagement activate:self.xmppStream];

    //文件接收
    _xmppIncomingFileTransfer = [[XMPPIncomingFileTransfer alloc] initWithDispatchQueue:dispatch_get_main_queue()];
    [_xmppIncomingFileTransfer activate:self.xmppStream];
    [_xmppIncomingFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    //设置为自动接收文件
    [_xmppIncomingFileTransfer setAutoAcceptFileTransfers:YES];
//    _xmppIncomingFileTransfer.disableIBB = NO;
//    _xmppIncomingFileTransfer.disableSOCKS5 = NO;
    
    //文件发送
    _xmppIncomingFileTransfer = [XMPPIncomingFileTransfer new];
    [_xmppIncomingFileTransfer activate:_xmppStream];
    [_xmppIncomingFileTransfer addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    //添加电子名片模块
    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    //添加花名册模块
    _rosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //设置好友同步策略,XMPP一旦连接成功，同步好友到本地
    [_roster setAutoFetchRoster:YES];
    [_roster activate:_xmppStream];
    
    //添加聊天模块    XMPPMessageArchivingCoreDataStorage
    _messageStroage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
    _messageArching=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_messageStroage];
    [_messageArching activate:_xmppStream];
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
}

#pragma mark 连接到服务器
-(void)connectToHost
{
    if(!_xmppStream){
        [self setupXmppStream];
    }
    NSString *user = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    XMPPJID *myJid = [XMPPJID jidWithUser:user domain:ServerName resource:@"bttime"];
    self.jid = myJid;
    _xmppStream.myJID = myJid;
    NSError *error = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]){
        NSLog(@"%@",error);
    }
}

#pragma mark 连接成功调用这个方法
-(void)xmppStreamDidConnect:(XMPPStream *)sender
{
    NSLog(@"连接主机成功");    
    if(self.isRegisterOperation) {
        NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:userPassword];
        [_xmppStream registerWithPassword:password error:nil];
    } else {
        [self sendPwdToHost];
    }
}

#pragma mark 连接失败的方法
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    if(error && _resultBlock){
        _resultBlock(XMPPResultNetworkErr);
    }
    NSLog(@"连接断开");
}

#pragma mark .连接到服务器后 在发送密码
-(void)sendPwdToHost
{
    NSError *error=nil;
    NSString *password = [[NSUserDefaults standardUserDefaults] valueForKey:userPassword];
    [_xmppStream authenticateWithPassword:password error:&error];
    if(error){
        NSLog(@"授权失败%@",error);
    }
}

#pragma mark 验证成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"验证成功");
    LogInfo(@"验证成功");
    //发送在线通知给服务器，服务器才会将离线消息推送过来
    [self sendOnlineMessage];
    
    //启用流管理
    [_xmppStreamManagement enableStreamManagementWithResumption:YES maxTimeout:0];
    
    if(_resultBlock){
        _resultBlock(XMPPResultSuccess);
    }
}

#pragma mark 验证失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error
{
    NSLog(@"验证失败");
    if(_resultBlock){
        _resultBlock(XMPPResultFaiture);
    }
}

#pragma mark 验证成功后 发送在线消息
-(void)sendOnlineMessage
{
    XMPPPresence *presence=[XMPPPresence presence];
    [_xmppStream sendElement:presence];
}

//离线消息
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [_xmppStream sendElement:presence];
}

#pragma mark 登录的方法
-(void)login:(XMPPResultBlock)xmppBlock {
    _resultBlock = xmppBlock;
    [_xmppStream disconnect];
    [self connectToHost];
}

#pragma mark 退出登录的操作
-(void)xmppLoginOut
{
    [self goOffline];
    [_xmppStream disconnect];
    
    [[BTMessageListDBTool sharedInstance] teardownConversationListDB];
}

#pragma -mark 好友分组
- (NSFetchedResultsController *)fetchedGroupResultsController
{
    NSManagedObjectContext *context = [_rosterStorage mainThreadManagedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPGroupCoreDataStorageObject"
                                              inManagedObjectContext:context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setFetchBatchSize:10];
    
    NSFetchedResultsController *fetchedGroupResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:context
                                                                          sectionNameKeyPath:@"name"
                                                                                   cacheName:nil];
    NSError *error = nil;
    if (![fetchedGroupResultsController performFetch:&error]) {
        NSLog(@"Error performing fetch: %@", error);
    }
    return fetchedGroupResultsController;
}

#pragma mark 删除好友,取消加好友
- (void)removeFried:(XMPPJID *)friedJid
{
    [_roster removeUser:friedJid];
}

- (void)addFried:(XMPPJID *)friedJid {
    [_roster subscribePresenceToUser:friedJid];
}

#pragma mark 收到请求添加好友回调
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    self.userJid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@", jid, ServerName]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"%@请求添加你为好友", jid.description] delegate:self cancelButtonTitle:@"拒绝" otherButtonTitles:@"同意", nil];
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [alertView show];
    });
}

- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    NSString *subscription = [item attributeStringValueForName:@"subscription"];
    if ([subscription isEqualToString:@"both"]) {
        NSLog(@"双方已经互为好友");
        NSNotification *note = [[NSNotification alloc]initWithName:UpdateContacterList object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

#pragma marks UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self handleAddFriendReqest:self.userJid result:NO];
    } else {
        [self handleAddFriendReqest:self.userJid result:YES];
        NSNotification *note = [[NSNotification alloc]initWithName:AddFriendRequst object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}


- (void)handleAddFriendReqest:(XMPPJID *)userJid result:(BOOL)result
{
    if (result) {
        [_roster acceptPresenceSubscriptionRequestFrom:userJid andAddToRoster:YES];
    } else {
        [_roster rejectPresenceSubscriptionRequestFrom:userJid];
    }
    
}

#pragma mark 调用注册的方法
-(void)regist:(XMPPResultBlock)xmppType {
    _resultBlock = xmppType;
    [_xmppStream disconnect];
    [self connectToHost];
}

#pragma mark 注册delegate
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterSuccess);
    }
}

-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterFailture);
    }
}

#pragma mark 修改密码
- (void)changePassworduseWord:(NSString *)checkPassword
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userId = [defaults stringForKey:userID];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:kChangePasswordNamespace];
    NSXMLElement *msgXml = [NSXMLElement elementWithName:@"iq"];
    
    [msgXml addAttributeWithName:@"type" stringValue:@"set"];
    [msgXml addAttributeWithName:@"to" stringValue:ServerName];
    [msgXml addAttributeWithName:@"id" stringValue:kChangePasswordId];
     
    DDXMLNode *username=[DDXMLNode elementWithName:@"username" stringValue:userId];//不带@后缀
    DDXMLNode *password=[DDXMLNode elementWithName:@"password" stringValue:checkPassword];//要改的密码
    [query addChild:username];
    [query addChild:password];
    [msgXml addChild:query];
     
    [_xmppStream sendElement:msgXml];
}

#pragma mark 查找好友
- (void)searchUserInfo:(NSString *)searchValue  Success:(ArrayResponseBlock)success failure:(errorBlock)error
{
    _searchDataBlock = success;
    _errorBlock = error;
    
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    [iq addAttributeWithName:@"from" stringValue:self.jid.description];
    [iq addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"search.%@",ServerName]];
    [iq addAttributeWithName:@"id" stringValue:kSearchUsersId];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:kSearchNamespace];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:kSearchXDataNamespace];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    NSXMLElement *field = [NSXMLElement elementWithName:@"field"];
    [field addAttributeWithName:@"type" stringValue:@"hidden"];
    [field addAttributeWithName:@"var" stringValue:@"FROM_TYPE"];
    NSXMLElement *value = [NSXMLElement elementWithName:@"value" stringValue:kSearchNamespace];
    [field addChild:value];
    [x addChild:field];
    
    NSXMLElement *searchValueField = [NSXMLElement elementWithName:@"field"];
    [searchValueField addAttributeWithName:@"type" stringValue:@"text-single"];
    [searchValueField addAttributeWithName:@"var" stringValue:@"search"];
    NSXMLElement *searchvalue = [NSXMLElement elementWithName:@"value" stringValue:searchValue];
    [searchValueField addChild:searchvalue];
    [x addChild:searchValueField];
    
    NSXMLElement *userNameField = [NSXMLElement elementWithName:@"field"];
    [userNameField addAttributeWithName:@"type" stringValue:@"boolean"];
    [userNameField addAttributeWithName:@"var" stringValue:@"Username"];
    NSXMLElement *userNameValue = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [userNameField addChild:userNameValue];
    [x addChild:userNameField];
    
    NSXMLElement *nameField = [NSXMLElement elementWithName:@"field"];
    [nameField addAttributeWithName:@"type" stringValue:@"boolean"];
    [nameField addAttributeWithName:@"var" stringValue:@"Name"];
    NSXMLElement *nameValue = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [nameField addChild:nameValue];
    [x addChild:nameField];
    
    NSXMLElement *emailField = [NSXMLElement elementWithName:@"field"];
    [emailField addAttributeWithName:@"type" stringValue:@"boolean"];
    [emailField addAttributeWithName:@"var" stringValue:@"Email"];
    NSXMLElement *emailValue = [NSXMLElement elementWithName:@"value" stringValue:@"0"];
    [emailField addChild:emailValue];
    [x addChild:emailField];
    
    [query addChild:x];
    [iq addChild:query];
    
    [_xmppStream sendElement:iq];
}

#pragma mark iq信息发送成功delegate
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    //返回用户信息查询结果
    if ([iq.type isEqualToString:@"result"] && [[iq attributeStringValueForName:@"id"] isEqualToString:kSearchUsersId]) {
        _searchDataBlock([self analyticalSearchResult:iq]);
    }
    return YES;
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"%@", presence);
}

#pragma mark 解析查找好友数据
- (NSArray *)analyticalSearchResult:(XMPPIQ *)iq {
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:1];
    
    NSXMLElement *query = [[iq elementsForName:@"query"] lastObject];
    
    if ([query.name isEqualToString:@"query"]) {
        NSArray *elements = [query children];
        for (NSXMLElement *element in elements) {
            
            if ([element.name isEqualToString:@"x"]) {
                NSArray *fields = [element children];
                for (NSXMLElement *field in fields) {
                    
                    if ([field.name isEqualToString:@"item"]) {
                        NSArray *items = [field children];
                        BTContacterModel *model = [[BTContacterModel alloc] init];
                        for (NSXMLElement *item in items) {
                            
                            if ([[item attributeStringValueForName:@"var"] isEqualToString:@"Name"]) {
                                model.nickName = [[[item elementsForName:@"value"] firstObject] stringValue];
                            }
                            
                            if ([[item attributeStringValueForName:@"var"] isEqualToString:@"Username"]) {
                                model.friendName = [[[item elementsForName:@"value"] firstObject] stringValue];
                            }
                            
                            if ([[item attributeStringValueForName:@"var"] isEqualToString:@"jid"]) {
                                NSString *jidStr = [[[item elementsForName:@"value"] firstObject] stringValue];
                                model.jid = [XMPPJID jidWithString:jidStr];
                            }
                            
                        }
                        [result addObject:model];
                    }
                }
            }
        }
    }
    return result;
}

#pragma mark 发送消息的函数
- (void)sendMessage:(NSString *)msg type:(NSString *)type to:(XMPPJID *)toName{
    XMPPMessage *msssage = [XMPPMessage messageWithType:type to:toName];
    // 设置内容   text指纯文本  image指图片  audio指语音
    [msssage addAttributeWithName:@"bodyType" stringValue:type];
    [msssage addBody:msg];
    [_xmppStream sendElement:msssage];
}

#pragma mark 接收到消息的事件
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSDate *date = [self getDelayStampTime:message];
    if(date == nil){
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [formatter stringFromDate:date];
    XMPPJID *jid = [message from];
    
    //获得body里面的内容
    NSString *body = [[message elementForName:@"body"] stringValue];
//    NSString *bodyType = (NSString *)message.type;
    //本地通知
    UILocalNotification *local = [[UILocalNotification alloc]init];
    if ([body hasSuffix:@".btpng"]) {
        [self downloadFile:jid.user fileName:body];
        local.alertBody = @"发来一张图片";
        local.alertAction = @"发来一张图片";
        NSDictionary *dict = @{@"uname":[jid user],@"time":strDate,@"body":@"收到一张图片",@"jid":jid,@"user":@"other"};
        NSNotification *note = [[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        return;
    }
    local.alertBody = body;
    local.alertAction = body;
    //声音
    local.soundName = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    //时区  根据用户手机的位置来显示不同的时区
    local.timeZone = [NSTimeZone defaultTimeZone];
    //开启通知
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    if (![jid user]) {
        return;
    }
    if(body){
        NSDictionary *dict = @{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid,@"user":@"other"};
        NSNotification *note = [[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

#pragma mark 下载文件
- (void)downloadFile:(NSString *)from fileName:(NSString *)fileName {
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    [infoDic setObject:from forKey:@"fromJid"];
    [infoDic setObject:self.jid.user forKey:@"toJid"];
    [infoDic setObject:fileName forKey:@"fileName"];
    NSString *cachesPath = [BTTool getCachesDirectory];
    NSString *savePath = [cachesPath stringByAppendingPathComponent:fileName];
    [BTNetManager downloadFileWithOption:infoDic withInferface:BTDownloadFileURL savedPath:savePath downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"下载成功");
        NSNotification *note = [[NSNotification alloc]initWithName:DownloadFileFinish object:from userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
//        XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
//        
//        //将这个文件的发送者添加到message的from
//        [message addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@", from, ServerName]];
//        [message addSubject:@"image"];
//        
//        
//        [message addBody:[NSString stringWithFormat:@"%@.png", fileName]];
//        
//        [_messageStroage archiveMessage:message outgoing:NO xmppStream:_xmppStream];
        
    } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    } progress:^(float progress) {
        
    }];
}

#pragma mark 获得离线消息的时间
-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    } else {
        return nil;
    }
}

- (void)sendDate:(NSData *)data name:(NSString *)filename to:(XMPPJID *)jid Success:(BOOLBlock)success failure:(errorBlock)error {
    _successBlock = success;
    _errorBlock = error;
    NSError *err;
    [jid jidWithNewResource:filename];
    [self.xmppOutgoingFileTransfer sendData:data named:filename toRecipient:jid description:nil error:&err];
    if (err) {
        _errorBlock(err);
    }
    
}

#pragma mark ===== 文件接收=======

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
                didFailWithError:(NSError *)error
{
    NSLog(@"%@", error);
}

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
               didReceiveSIOffer:(XMPPIQ *)offer
{
    [sender acceptSIOffer:offer];
}

- (void)xmppIncomingFileTransfer:(XMPPIncomingFileTransfer *)sender
              didSucceedWithData:(NSData *)data
                           named:(NSString *)name
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *fullPath = [[paths lastObject] stringByAppendingPathComponent:name];
    NSLog(@"%@", fullPath);
    [data writeToFile:fullPath options:0 error:nil];
    
}

#pragma mark - 文件发送代理
- (void)xmppOutgoingFileTransfer:(XMPPOutgoingFileTransfer *)sender
                didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError:%@",error);
}

- (void)xmppOutgoingFileTransferDidSucceed:(XMPPOutgoingFileTransfer *)sender
{
    NSLog(@"xmppOutgoingFileTransferDidSucceed");
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:self.jid];
    
    //将这个文件的发送者添加到message的from
    [message addAttributeWithName:@"from" stringValue:_xmppStream.myJID.bare];
    [message addSubject:@"audio"];
    
    NSString *path =  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [path stringByAppendingPathComponent:sender.outgoingFileName];
    
    [message addBody:path.lastPathComponent];
    
    [_messageStroage archiveMessage:message outgoing:NO xmppStream:_xmppStream];
}


#pragma mark  当对象销毁的时候
-(void)teardownXmpp
{
    [_xmppStream removeDelegate:self];
    [_reconnect deactivate];
    [_xmppStreamManagement deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    [_xmppStream disconnect];
    _reconnect=nil;
    _xmppStreamManagement = nil;
    _storage = nil;
    _vCard=nil;
    _vCardStorage=nil;
    _avatar=nil;
    _rosterStorage=nil;
    _roster=nil;
    _xmppStream=nil;
}

#pragma mark -- terminate
/**
 *  申请后台时间来清理下线的任务
 */
-(void)applicationWillTerminate
{
    UIApplication *app=[UIApplication sharedApplication];
    UIBackgroundTaskIdentifier taskId;
    
    taskId=[app beginBackgroundTaskWithExpirationHandler:^(void){
        [app endBackgroundTask:taskId];
    }];
    
    if(taskId==UIBackgroundTaskInvalid){
        return;
    }
    
    //只能在主线层执行
    [self.xmppStream disconnectAfterSending];
}

-(void)dealloc
{
    [self teardownXmpp];
}

@end