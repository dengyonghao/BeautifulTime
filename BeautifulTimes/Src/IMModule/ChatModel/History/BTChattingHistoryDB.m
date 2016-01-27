//
//  BTChattingHistoryDB.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChattingHistoryDB.h"
#import "FMDB.h"

@interface BTChattingHistoryDB ()

@property (nonatomic, strong) FMDatabaseQueue * queue;

@end

static BTChattingHistoryDB * historyDB = nil;

@implementation BTChattingHistoryDB

+ (BTChattingHistoryDB *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        historyDB = [[BTChattingHistoryDB alloc]init];
    });
    return historyDB;
}

- (BTChattingHistoryDB *) init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)getDBPathWithFriendId:(NSString *)friendId {
    
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    
    if (!friendId) {
        return nil;
    }
    NSString *path = [BTTool getLibraryDirectory];
    NSString *userSavePath = [NSString stringWithFormat:@"BTCaches/%@", currentUser];
    path = [path stringByAppendingPathComponent:userSavePath];
    if ([BTTool createDirectory:path]) {
        path = [path stringByAppendingPathComponent:friendId];
        if ([BTTool createDirectory:path]) {
            path = [path stringByAppendingPathComponent:@"ChattingHistory.db"];
            return path;
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

- (void) createHistoryDBWithFriendId:(NSString *)friendId {
    
    NSString * path = [self getDBPathWithFriendId:friendId];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        //创建表
        BOOL createTableResult = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS chattingHistory (historyID INTEGER PRIMARY KEY AUTOINCREMENT, isCurrentUser INTEGER, message text, chatTime date)"];
        if (createTableResult) {
            NSLog(@"创建记录表成功");
        } else {
            NSLog(@"创建记录表失败");
        }
    }];
}

- (void)addHistory:(BTChattingHistory *)message {
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"insert into chattingHistory (isCurrentUser, message, chatTime) values (?, ?, ?)";
        [db executeUpdate:sql, message.isCurrentUser, message.message, message.chatTime];
    }];
}

- (void) dealloc {
    _queue = nil;
}

@end
