//
//  BTMessageListDBTool.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTMessageListDBTool.h"
#import "FMDB.h"
#import "BTMessageListModel.h"

@interface BTMessageListDBTool ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

static BTMessageListDBTool *_db = nil;

@implementation BTMessageListDBTool

+ (BTMessageListDBTool *)sharedInstance {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _db = [[BTMessageListDBTool alloc] init];
//    });
    if (!_db) {
        _db = [[BTMessageListDBTool alloc] init];
    }
    return _db;
}

- (instancetype)init
{
    
    if (self = [super init]) {
        NSString *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
        
        if (!currentUser) {
            NSLog(@"用户没有登录！！！");
        }
        NSString *path = [BTTool getDocumentDirectory];
        NSString *userSavePath = [NSString stringWithFormat:@"BTCaches/%@", currentUser];
        path = [path stringByAppendingPathComponent:userSavePath];
        if ([BTTool createDirectory:path]) {
            if ([BTTool createDirectory:path]) {
                path = [path stringByAppendingPathComponent:@"BTConversationList.db"];
            }
            else {
                NSLog(@"path: %@ not exist", path);
            }
        }
        else {
            NSLog(@"path: %@ not exist", path);
        }
        _queue=[FMDatabaseQueue databaseQueueWithPath:path];
        //创建表
        [_queue inDatabase:^(FMDatabase *db) {
            BOOL b=[db executeUpdate:@"create table if not exists message(ID integer primary key autoincrement,head blob,uname text,detailname text,time date,badge text,jid blob)"];
            if(!b){
                NSLog(@"创建表失败");
            }
        }];
        NSLog(@"%@",path);
    }
    return self;
}

- (NSString *)getCurrentUserDBPath {
    
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    
    if (!currentUser) {
        return nil;
    }
    NSString *path = [BTTool getDocumentDirectory];
    NSString *userSavePath = [NSString stringWithFormat:@"BTCaches/%@", currentUser];
    if ([BTTool createDirectory:userSavePath]) {
        if ([BTTool createDirectory:userSavePath]) {
            userSavePath = [userSavePath stringByAppendingPathComponent:@"BTConversationList.db"];
            return userSavePath;
        }
        else {
            NSLog(@"path: %@ not exist", path);
        }
    }
    else {
        NSLog(@"path: %@ not exist", path);
    }
    return nil;
}

//数据库添加数据
- (BOOL)addHead:(NSData *)head uname:(NSString *)uname detailName:(NSString *)detailName time:(NSDate *)time badge:(NSString *)badge xmppjid:(XMPPJID *)jid
{
    __block  BOOL b;
    [_queue inDatabase:^(FMDatabase *db) {
        //将对象转为二进制
        NSData *xmjid=[NSKeyedArchiver archivedDataWithRootObject:jid];
        b=[db executeUpdate:@"insert into message(head,uname,detailname,time,badge,jid) values(?,?,?,?,?,?)",head,uname,detailName,time,badge,xmjid];
    }];
    return b;
}
//判断用户是否已经存在
- (BOOL)selectUname:(NSString *)uname
{
    __block BOOL b=NO;
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from message where uname=?",uname];
        
        while ([result next]) {
            b=YES;
            
        }
    }];
    
    return b;
}

//更新数据
- (BOOL)updateWithName:(NSString *)uname detailName:(NSString *)detailName time:(NSDate *)time badge:(NSString *)badge
{
    __block BOOL b;
    
    [_queue inDatabase:^(FMDatabase *db) {
        b=[db executeUpdate:@"update message set detailname=?, time=? ,badge=? where uname=?",detailName,time,badge,uname];
    }];
    
    return b;
}
/*
 NSDictionary *dict=@{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid};
 */
//查询所有的数据
- (NSArray *)selectAllData
{
    __block NSMutableArray *arr=nil;
    
    [_queue inDatabase:^(FMDatabase *db) {
        FMResultSet *result=[db executeQuery:@"select * from message order by time desc"];
        if(result){
            //创建数组
            arr=[NSMutableArray array];
            while ([result next]) {
                
                //添加模型
                BTMessageListModel *model=[[BTMessageListModel alloc]init];
                model.uname=[result stringForColumn:@"uname"];
                model.body=[result stringForColumn:@"detailname"];
                model.time=[result dateForColumn:@"time"];
                model.badgeValue=[result stringForColumn:@"badge"];
                model.headerIcon=[result dataForColumn:@"head"];
                //获得XmppJid
                model.jid=[NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"jid"]];
                
                [arr addObject:model];
                
            }
        }
    }];
    return arr;
}

//清除小红点
- (void)clearRedPointwithName:(NSString *)uname
{
    [_queue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"update message set badge='' where uname=?",uname];
    }];
}

#pragma mark 删除聊天数据的方法
- (void)deleteWithName:(NSString *)uname
{
    [_queue inDatabase:^(FMDatabase *db) {
        BOOL b=[db executeUpdate:@"delete  from message where uname=?",uname];
        if(!b){
            NSLog(@"删除失败");
        }
    }];
}

- (void)teardownConversationListDB {
    _queue = nil;
    _db = nil;
}

@end
