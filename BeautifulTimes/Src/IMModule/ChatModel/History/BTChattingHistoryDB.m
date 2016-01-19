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

+ (BTChattingHistoryDB *) getInstance {
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

- (NSString *)getDBPath {
    NSString *path = [BTTool getLibraryDirectory];
    path = [path stringByAppendingPathComponent:@"BTCaches"];
    if ([BTTool createDirectory:path]) {
        path = [path stringByAppendingPathComponent:@"CommonDB"];
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

- (void) createHistoryDB {
    
    NSString * path = [self getDBPath];
    
    self.queue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    [self.queue inDatabase:^(FMDatabase *db) {
        //创建表
        BOOL createTableResult=[db executeUpdate:@"CREATE TABLE  IF NOT EXISTS CallHistory (historyID INTEGER PRIMARY KEY, name text, callphone text, count integer, calltime date, photo data, calltype integer)"];
        if (createTableResult) {
            NSLog(@"创建通话记录表成功");
        }else{
            NSLog(@"创建通话记录表失败");
        }
    }];
}

- (void) dealloc {
    //    [_db close];
    _queue = nil;
}


@end
