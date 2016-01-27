//
//  BTChattingHistoryManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChattingHistoryManager.h"
#import "BTChattingHistoryDB.h"

static BTChattingHistoryManager * historyManager = nil;

@implementation BTChattingHistoryManager

+ (BTChattingHistoryManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        historyManager = [[BTChattingHistoryManager alloc] init];
    });
    return historyManager;
}

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)addHistoryWithFriendId:(NSString *)friendId message:(BTChattingHistory *)message {
    BTChattingHistoryDB *db = [BTChattingHistoryDB sharedInstance];
    [db createHistoryDBWithFriendId:friendId];
    [db addHistory:message];
}

@end
