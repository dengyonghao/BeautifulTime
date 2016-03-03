//
//  BTTimelineDBManager.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/25.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTTimelineModel.h"

@interface BTTimelineDBManager : NSObject

+ (BTTimelineDBManager *)sharedInstance;

/**
 *  添加 timeline message
 *
 *  @param timeline message
 */
- (void)addTimelineMessage:(BTTimelineModel *)message;

@end
