//
//  BTXMPPTool.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTXMPPTool.h"

static BTXMPPTool *xmppTool;

@interface BTXMPPTool ()<XMPPStreamDelegate>
{
    XMPPResultBlock _resultBlock;
    XMPPReconnect *_reconnect;
    //定义一个消息对象
    XMPPMessageArchiving *_messageArching;
    //电子名片存贮
    XMPPvCardCoreDataStorage *_vCardStorage;
}

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


#pragma mark 初始化xmppstream
-(void)setupXmppStream
{
    _xmppStream=[[XMPPStream alloc]init];
#warning 每一个模块添加都要激活
    //1.添加自动连接模块
    _reconnect=[[XMPPReconnect alloc]init];
    [_reconnect activate:_xmppStream];
    //2.添加电子名片模块
    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];  //激活
    
    //3.添加头像模块
    _avatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    //4.添加花名册模块
    _rosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];  //激活
    //5.添加聊天模块    XMPPMessageArchivingCoreDataStorage
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
    XMPPJID *myJid = [XMPPJID jidWithUser:user domain:ServerName resource:nil];
    self.jid = myJid;
    _xmppStream.myJID = myJid;
    _xmppStream.hostName = ServerAddress;
    _xmppStream.hostPort = ServerPort;
    
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
    [self sendOnlineMessage];
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
    NSLog(@"%@",presence);
    //把在线情况发送给服务器
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

- (void)addFried:(NSString *)friedJid {
    XMPPJID *myJid=[XMPPJID jidWithUser:friedJid domain:ServerName resource:nil];
    [_roster subscribePresenceToUser:myJid];
}
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [NSString stringWithFormat:@"%@", [presence type]]; //online/offline
    //请求的用户
    NSString *presenceFromUser =[NSString stringWithFormat:@"%@", [[presence from] user]];
    NSLog(@"presenceType:%@",presenceType);
    
    NSLog(@"presence2:%@  sender2:%@",presence,sender);
    
    XMPPJID *jid = [XMPPJID jidWithString:presenceFromUser];
    [_roster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];
    
}

#pragma mark 调用注册的方法
-(void)regist:(XMPPResultBlock)xmppType {
    _resultBlock = xmppType;
    [_xmppStream disconnect];
    [self connectToHost];
}
#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterSuccess);
    }
}
#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterFailture);
    }
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
    NSString *body=[[message elementForName:@"body"] stringValue];
    //本地通知
    UILocalNotification *local = [[UILocalNotification alloc]init];
    local.alertBody = body;
    local.alertAction = body;
    //声音
    local.soundName = [[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    //时区  根据用户手机的位置来显示不同的时区
    local.timeZone = [NSTimeZone defaultTimeZone];
    //开启通知
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    if(body){
        NSDictionary *dict = @{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid,@"user":@"other"};
        NSNotification *note = [[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

#pragma mark 发送消息的函数
- (void)sendMessage:(NSString *)msg type:(NSString *)type to:(XMPPJID *)toName{
    XMPPMessage *msssage = [XMPPMessage messageWithType:@"chat" to:toName];
    // 设置内容   text指纯文本  image指图片  audio指语音
    [msssage addAttributeWithName:@"bodyType" stringValue:type];
    [msssage addBody:msg];
    [_xmppStream sendElement:msssage];
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

#pragma mark 查找好友
- (void)searchUserInfo:(NSString *)searchValue
{
    NSXMLElement *iq = [NSXMLElement elementWithName:@"iq"];
    [iq addAttributeWithName:@"type" stringValue:@"set"];
    XMPPJID *myJID = self.xmppStream.myJID;
    [iq addAttributeWithName:@"from" stringValue:myJID.description];
    [iq addAttributeWithName:@"to" stringValue:@"sh.m.tie1tie.com"];
    [iq addAttributeWithName:@"id" stringValue:@"search2"];
    
    NSXMLElement *query = [NSXMLElement elementWithName:@"query" xmlns:@"jabber:iq:search"];
    NSXMLElement *x = [NSXMLElement elementWithName:@"x" xmlns:@"jabber:x:data"];
    [x addAttributeWithName:@"type" stringValue:@"submit"];
    
    NSXMLElement *field1 = [NSXMLElement elementWithName:@"field"];
    [field1 addAttributeWithName:@"type" stringValue:@"hidden"];
    [field1 addAttributeWithName:@"var" stringValue:@"FROM_TYPE"];
    NSXMLElement *value1 = [NSXMLElement elementWithName:@"value" stringValue:@"jabber:iq:search"];
    [field1 addChild:value1];
    
    NSXMLElement *field2 = [NSXMLElement elementWithName:@"field"];
    [field2 addAttributeWithName:@"type" stringValue:@"text-single"];
    [field2 addAttributeWithName:@"var" stringValue:@"search"];
    NSXMLElement *value2 = [NSXMLElement elementWithName:@"value" stringValue:searchValue];
    [field2 addChild:value2];
    
    NSXMLElement *field3 = [NSXMLElement elementWithName:@"field"];
    [field3 addAttributeWithName:@"type" stringValue:@"boolean"];
    [field3 addAttributeWithName:@"var" stringValue:@"Username"];
    NSXMLElement *value3 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [field3 addChild:value3];
    
    NSXMLElement *field4 = [NSXMLElement elementWithName:@"field"];
    [field4 addAttributeWithName:@"type" stringValue:@"boolean"];
    [field4 addAttributeWithName:@"var" stringValue:@"Name"];
    NSXMLElement *value4 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [field4 addChild:value4];
    
    NSXMLElement *field5 = [NSXMLElement elementWithName:@"field"];
    [field5 addAttributeWithName:@"type" stringValue:@"boolean"];
    [field5 addAttributeWithName:@"var" stringValue:@"Email"];
    NSXMLElement *value5 = [NSXMLElement elementWithName:@"value" stringValue:@"1"];
    [field5 addChild:value5];
    
    [x addChild:field1];
    [x addChild:field2];
    [x addChild:field3];
    [x addChild:field4];
    [x addChild:field5];
    
    [query addChild:x];
    
    [iq addChild:query];
    
    [self.xmppStream sendElement:iq];
}


- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
    //返回用户信息查询结果
    if ([@"result" isEqualToString:iq.type] && [[iq attributeStringValueForName:@"id"] isEqualToString:@"search2"]) {
        NSString *name;
        XMPPJID *jid;
        NSXMLElement *query = iq.childElement;
        if ([@"query" isEqualToString:query.name]) {
//            NSXMLElement *x = [self childElement:query];
//            NSArray *elements = [x children];
//            for (NSXMLElement *item in elements) {
//                if ([item.name isEqualToString:@"item"]) {
//                    NSArray *fields = [item children];
//                    for (NSXMLElement *field in fields) {
//                        if ([[field attributeStringValueForName:@"var"] isEqualToString:@"Name"]) {
//                            name = [[[field elementsForName:@"value"] firstObject] stringValue];
//                        }
//                        if ([[field attributeStringValueForName:@"var"] isEqualToString:@"jid"]) {
//                            NSString *jidStr = [[[field elementsForName:@"value"] firstObject] stringValue];
//                            jid = [XMPPJID jidWithString:jidStr];
//                        }
//                    }
//                }
//            }
        }
//        [self handlePresence:jid name:name];
        
    }
    return YES;
}


#pragma mark  当对象销毁的时候
-(void)teardownXmpp
{
    [_xmppStream removeDelegate:self];
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    [_xmppStream disconnect];
    _reconnect=nil;
    _vCard=nil;
    _vCardStorage=nil;
    _avatar=nil;
    _rosterStorage=nil;
    _roster=nil;
    _xmppStream=nil;
}

-(void)dealloc
{
    [self teardownXmpp];
}

@end