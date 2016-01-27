//
//  BTChattingHistoryManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTChattingHistory.h"

@interface BTChattingHistoryManager : NSObject

+ (BTChattingHistoryManager *)sharedInstance;

/**
 *  添加一条通讯记录
 *
 *  @param contact 通讯记录
 */
- (void)addHistoryWithFriendId:(NSString *)friendId message:(BTChattingHistory *)message;

@end
