//
//  BTMessageListDBTool.h
//  BeautifulTimes
//
//  Created by dengyonghao on 16/2/15.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTMessageListDBTool : NSObject

/**
 *  获取通讯记录数据库单例
 *
 *  @return 数据库单例
 */
+ (BTMessageListDBTool *) sharedInstance;

/*
    head blob,uname text,detailname text,time text,badge text
 */

//添加数据
- (BOOL)addHead:(NSData*)head uname:(NSString*)uname detailName:(NSString*)detailName time:(NSDate*)time badge:(NSString*)badge xmppjid:(XMPPJID*)jid ;

//查询判断数据有没有存在
- (BOOL)selectUname:(NSString*)uname;

//更新数据库里面的东西
- (BOOL)updateWithName:(NSString*)uname detailName:(NSString*)detailName time:(NSDate*)time badge:(NSString*)badge;

//查询所有的数据
- (NSArray*)selectAllData;

//清除小红点的方法
- (void)clearRedPointwithName:(NSString*)uname;

//删除聊天数据的方法
- (void)deleteWithName:(NSString*)uname;

#pragma mark  当对象销毁的时候
- (void)teardownConversationListDB;

@end
