//
//  BTChattingHistoryDB.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTChattingHistoryDB : NSObject

/**
 *  获取通讯记录数据库单例
 *
 *  @return 数据库单例
 */
+ (BTChattingHistoryDB *) getInstance;

/**
 *  数据库路径
 *
 *  @return 数据库路径
 */
- (NSString *) getDBPath;

/**
 *  创建数据库
 */
- (void) createHistoryDB;

@end
