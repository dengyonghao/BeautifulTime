//
//  BTTimelineDBManager.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDBManager.h"
#import "BTTimelineDB.h"

static BTTimelineDBManager * timelineDBManager = nil;

@implementation BTTimelineDBManager

+ (BTTimelineDBManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timelineDBManager = [[BTTimelineDBManager alloc] init];
    });
    return timelineDBManager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)addTimelineMessage:(BTTimelineModel *)message {
    BTTimelineDB *db = [BTTimelineDB sharedInstance];
    [db addHistory:message];
}

- (NSArray *)getAllTimelineMessage {
    NSArray *array = [[BTTimelineDB sharedInstance] getAllHistory];
    return array;
}

@end
