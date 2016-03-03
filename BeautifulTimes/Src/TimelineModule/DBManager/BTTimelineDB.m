//
//  BTTimelineDB.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDB.h"
#import "FMDB.h"

@interface BTTimelineDB ()

@property (nonatomic, strong) FMDatabaseQueue * queue;

@end

static BTTimelineDB * timelineDB = nil;

@implementation BTTimelineDB

+ (BTTimelineDB *) sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timelineDB = [[BTTimelineDB alloc]init];
    });
    return timelineDB;
}

- (BTTimelineDB *) init
{
    if (self = [super init]) {
    }
    return self;
}

- (NSString *)getDBPath {
    
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    
    if (!currentUser) {
        return nil;
    }
    NSString *path = [BTTool getLibraryDirectory];
    NSString *userSavePath = [NSString stringWithFormat:@"BTCaches/%@", currentUser];
    path = [path stringByAppendingPathComponent:userSavePath];
    if ([BTTool createDirectory:path]) {
        path = [path stringByAppendingPathComponent:currentUser];
        if ([BTTool createDirectory:path]) {
            path = [path stringByAppendingPathComponent:@"BTTimeline"];
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
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        return;
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
        //创建表
        BOOL createTableResult = [db executeUpdate:@"CREATE TABLE  IF NOT EXISTS bttimeline (timelineId INTEGER PRIMARY KEY AUTOINCREMENT, timelineContent data, timelineDate date, weather data, site text, photos text, record text, friends text)"];
        if (createTableResult) {
            NSLog(@"创建记录表成功");
        } else {
            NSLog(@"创建记录表失败");
        }
    }];
}

- (void)addHistory:(BTTimelineModel *)message {
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sql = @"insert into bttimeline (timelineContent, timelineDate, weather, site, photos, record, friends) values (?, ?, ?, ?, ?, ?, ?)";
        [db executeUpdate:sql, message.timelineContent, message.timelineDate, message.weather, message.site, message.photos, message.record, message.friends];
    }];
}

- (void) dealloc {
    _queue = nil;
}

@end
