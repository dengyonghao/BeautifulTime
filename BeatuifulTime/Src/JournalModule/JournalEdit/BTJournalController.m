//
//  BTJournalController.m
//  BeatuifulTime
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalController.h"

static BTJournalController *journalController;

@interface BTJournalController() <BTJournalControllerDelegate>

@end

@implementation BTJournalController

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        journalController = [[BTJournalController alloc] init];
    });
    
    return journalController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [BTJournalController sharedInstance].delegate = self;
    }
    return self;
}

- (NSMutableArray *)photos {
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

- (NSDate *)currentDate {
    if (!_currentDate) {
        _currentDate = [[NSDate alloc] init];
    }
    return _currentDate;
}

- (NSData *)record {
    if (!_record) {
        _record = [[NSData alloc] init];
    }
    return _record;
}

@end
