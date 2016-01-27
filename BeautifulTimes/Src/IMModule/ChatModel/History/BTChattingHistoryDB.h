//
//  BTChattingHistoryDB.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTChattingHistory.h"

@interface BTChattingHistoryDB : NSObject

/**
 *  获取通讯记录数据库单例
 *
 *  @return 数据库单例
 */
+ (BTChattingHistoryDB *) sharedInstance;

/**
 *  数据库路径
 *
 *  @return 数据库路径
 */
- (NSString *) getDBPathWithFriendId:(NSString *)friendId;

/**
 *  创建数据库
 */
- (void) createHistoryDBWithFriendId:(NSString *)friendId;

/**
 *  添加一条通讯记录
 *
 *  @param contact 通讯记录
 */
- (void)addHistory:(BTChattingHistory *)message;

@end
