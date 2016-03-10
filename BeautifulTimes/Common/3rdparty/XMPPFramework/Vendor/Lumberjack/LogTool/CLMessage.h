//
//  CLMessage.h
//  CarLife
//
//  Created by xubin luo on 14-10-13.
//  Copyright (c) 2014年 TJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLMessageDefine.h"



@interface CLMessageHeader : NSObject

//body长度
@property (nonatomic, assign) NSInteger bodyLength;                       //16 bits

//消息类型
@property (nonatomic, assign) EN_MsgCategory_Type type;             //2 bits

//请求ID or 响应ID
@property (nonatomic, assign) NSInteger messageID;                        //14 bits

//消息服务类型
@property (nonatomic, assign) NSInteger serviceType;                       //16 bits

//初始化
- (instancetype)initWithData:(NSData *)data;

- (NSInteger)dataToInt:(NSData *)data;

//序列化成NSData
- (NSData *)toNSData;

- (NSData *)intToNSData:(NSInteger)number withLength:(NSInteger)length;

@end


@interface CLMessage : NSObject

@property (nonatomic, strong) CLMessageHeader *header;

@property (nonatomic, strong) NSData *bodydata;

/**
 *  序列化成NSData
 *
 *  @return data
 */
- (NSData *)toNSData;


/**
 *  初始化方法
 *
 *  @param header 消息头，不可以为空
 *  @param data   消息体,可以为空
 *
 *  @return CLMessage
 */
- (id)initWith:(CLMessageHeader *)header andBody:(NSData*)data;



@end
