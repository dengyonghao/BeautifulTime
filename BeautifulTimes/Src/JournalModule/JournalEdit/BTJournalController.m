//
//  BTJournalController.m
//  BeautifulTimes
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalController.h"

static BTJournalController *journalController;

@interface BTJournalController() <BTJournalControllerDelegate>

@end

@implementation BTJournalController

@synthesize photos = _photos;
@synthesize currentDate = _currentDate;
@synthesize record = _record;

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
        
    }
    return self;
}

- (NSArray *)photos {
    if (!_photos) {
        _photos = [[NSArray alloc] init];
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
