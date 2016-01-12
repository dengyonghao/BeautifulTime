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
    //    //2.添加电子名片模块
    _vCardStorage=[XMPPvCardCoreDataStorage sharedInstance];
    _vCard=[[XMPPvCardTempModule alloc]initWithvCardStorage:_vCardStorage];
    [_vCard activate:_xmppStream];  //激活
    
    //    //3.添加头像模块
    _avatar=[[XMPPvCardAvatarModule alloc]initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    //    //4.添加花名册模块
    _rosterStorage=[[XMPPRosterCoreDataStorage alloc]init];
    _roster=[[XMPPRoster alloc]initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];  //激活
    //    //5.添加聊天模块    XMPPMessageArchivingCoreDataStorage
    _messageStroage=[[XMPPMessageArchivingCoreDataStorage alloc]init];
    _messageArching=[[XMPPMessageArchiving alloc]initWithMessageArchivingStorage:_messageStroage];
    [_messageArching activate:_xmppStream];
    
    
    //添加代理   把xmpp流放到子线程
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
}
#pragma mark 连接到服务器
-(void)connectToHost
{
    if(!_xmppStream){
        [self setupXmppStream];
    }
    NSString *user = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    XMPPJID *myJid=[XMPPJID jidWithUser:user domain:ServerName resource:nil];
    self.jid=myJid;
    _xmppStream.myJID=myJid;
    _xmppStream.hostName=ServerAddress;
    _xmppStream.hostPort=ServerPort;
    
    NSError *error=nil;
    //连接到服务器
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
        _resultBlock(XMPPResultNetworkErr);  //网路出现问题的时候
    }
    NSLog(@"连接断开");
}
#pragma mark .连接到服务器后 在发送密码
-(void)sendPwdToHost
{
    NSError *error=nil;
    NSString *password=@"x5829189130";
    //验证密码
    [_xmppStream authenticateWithPassword:password error:&error];
    if(error){
        NSLog(@"授权失败%@",error);
    }
}
#pragma mark 验证成功 （就是密码正确）
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    NSLog(@"验证成功");
    //发送在线消息
    [self sendOnlineMessage];
    if(_resultBlock){
        _resultBlock(XMPPResultSuccess);
    }
}

#pragma mark 验证失败 （就是密码错误）
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
    _resultBlock=xmppBlock;
    [_xmppStream disconnect];
    //连接到主机
    [self connectToHost];
}
#pragma mark 退出登录的操作
-(void)xmppLoginOut
{
    [self goOffline];
    [_xmppStream disconnect];
    
//    UserOperation *user=[UserOperation shareduser];
//    user.uname=nil;
//    user.password=nil;
//    user.loginStatus=NO; //退出登录状态
}

#pragma mark 删除好友,取消加好友，或者加好友后需要删除
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
    _resultBlock=xmppType;
    [_xmppStream disconnect];
    [self connectToHost];
}
#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    NSLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterSuccess);
    }
}
#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    NSLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultRegisterFailture);
    }
}
#pragma mark 接收到消息的事件
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message{
    NSDate *date=[self getDelayStampTime:message];
    if(date==nil){
        date=[NSDate date];
    }
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate=[formatter stringFromDate:date];
    XMPPJID *jid=[message from];
    
    //[jid user]; 通过这个行为可获得用户名
    //获得body里面的内容
    NSString *body=[[message elementForName:@"body"] stringValue];
    //NSLog(@"xmpp   %@",body);
    //body=[NSString stringWithFormat:@"%@:%@ %@",[jid user],body,strDate];
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
        NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
    
}

#pragma mark 发送消息的函数
-(void)sendMessage:(NSString *)_msg to:(NSString *)_toName{
    //创建一个xml
    //创建元素
    NSXMLElement *message=[[NSXMLElement alloc]initWithName:@"message"];
    //定制根元素的属性
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"from" stringValue:@"jack@localhost"];
    [message addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",_toName,ServerName]];
    //创建一个子元素
    NSXMLElement *body=[[NSXMLElement alloc]initWithName:@"body"];
    [body setStringValue:_msg];
    [message addChild:body];
    //发送信息
    [_xmppStream sendElement:message];
    NSLog(@"%@",message);
}
#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
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
    }else{
        return nil;
    }
    
}




//#pragma mark  当对象销毁的时候
-(void)teardownXmpp
{
    //1.移除代理
    [_xmppStream removeDelegate:self];
    //2.停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [self.vCard deactivate];
    [_avatar deactivate];
    [_reconnect deactivate];
    [_roster deactivate];
    //3.断开连接
    [_xmppStream disconnect];
    //4 清空对象
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