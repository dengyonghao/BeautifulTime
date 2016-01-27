//
//  BTChattingHistory.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/19.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTChattingHistory : NSObject

@property (nonatomic, assign) NSInteger historyID;
@property (nonatomic, assign) NSInteger isCurrentUser;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSDate *chatTime;

@end
