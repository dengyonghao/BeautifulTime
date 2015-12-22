//
//  BTJournalController.h
//  BeatuifulTime
//
//  Created by deng on 15/11/22.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BTJournalControllerDelegate;

@interface BTJournalController : NSObject

/**
 *  日记编辑控制器
 */
+ (instancetype)sharedInstance;

@property (nonatomic, weak) id <BTJournalControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) NSDate *currentDate;
@property (nonatomic, strong) NSData *record;

@end

@protocol BTJournalControllerDelegate <NSObject>

@optional

@end
