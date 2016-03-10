//
//  CLMessage.m
//  CarLife
//
//  Created by xubin luo on 14-10-13.
//  Copyright (c) 2014年 TJ. All rights reserved.
//

#import "CLMessage.h"

DEFINE_ENUM(EN_MsgCategory_Type, _EN_MsgCategory_Type)
DEFINE_ENUM(EN_CLMsg_Type, _EN_CLMsg_Type)
@implementation CLMessageHeader

//初始化
- (instancetype)initWithData:(NSData *)data
{
    if ([data length] ==  COMMAND_MSGHEAD_LENGTH)
    {
        if(self = [super init])
        {
            // body长度
            NSData *bodyLength = [data subdataWithRange:NSMakeRange(0, 2)];
            _bodyLength = [self dataToInt:bodyLength];
            
            // 消息类别
            NSData *messageType = [data subdataWithRange:NSMakeRange(2, 1)];
            _type = (int)[self getMsgCategoryType:messageType];
            
            // 消息ID
            NSData *messageID = [data subdataWithRange:NSMakeRange(2, 2)];
            _messageID = [self getMessageID:messageID];
         
            // 服务类型
            NSData *serviceType = [data subdataWithRange:NSMakeRange(4, 4)];
            _serviceType = [self dataToInt:serviceType];
        }
        return  self;
    }    
    return nil;
}

/**
 *  序列化成NSData
 *
 *  @return nsdata
 */
- (NSData *)toNSData
{
    NSMutableData *data = [[NSMutableData alloc ] init];
    
    // body长度
    [data appendData:[self intToNSData:self.bodyLength withLength:2]];
    // 消息类别 * ID
    [data appendData:[self intToNSData:self.type withLength:2]];
    // service type
    [data appendData:[self intToNSData:self.serviceType withLength:4]];
    
    return data;
}
/**
 *  输出描述信息
 *
 *  @return 描述信息字符串
 */
- (NSString *)description
{
    NSString *result = [NSString stringWithFormat:@"{type=%@[0x%x],messageID=%li,serviceType=%@[0x%lx],bodyLength=%li}", NSStringFromEN_MsgCategory_Type(self.type), self.type, (long)self.messageID, NSStringFromEN_CLMsg_Type((EN_CLMsg_Type)(int)self.serviceType), (long)self.serviceType, self.bodyLength];
    return result;
}

/**
 *  NSData 转换成 int
 *
 *  @param data, data长度可为2个字节或者4个字节
 *
 *  @return int
 */
- (NSInteger)dataToInt:(NSData *)data
{
    NSInteger result = 0;
    if (data.length == 4) {
        Byte bodyBytes[4];
        [data getBytes:&bodyBytes];
        result = (bodyBytes[0] << 24) & 0xFF000000;
        result |= ((bodyBytes[1] << 16) & 0xFF0000);
        result |= ((bodyBytes[2] << 8) & 0xFF00);
        result |= bodyBytes[3] & 0xFF;
    }
    else if (data.length == 2) {
        Byte bodyBytes[2];
        [data getBytes:&bodyBytes];
        result = (bodyBytes[0] << 8) & 0xFF00;
        result |= bodyBytes[1] & 0xFF;
    }
    else {
        NSLog(@"不支持该长度的数据转换");
    }
    
    return result;
}

/**
 *  获取类别信息, 类别信息是该字节的前两位
 *
 *  @param data, data长度为1个字节
 *
 *  @return int
 */
- (NSInteger)getMsgCategoryType:(NSData *)data
{
    NSInteger categoryType = 0;
    if (data.length == 1) {
        Byte bytes;
        [data getBytes:&bytes];
        categoryType = (bytes & 0xC0) >> 6;
    }
    else {
        NSLog(@"不支持该长度的数据转换");
    }
    
    return categoryType;
}

/**
 *  获取消息ID
 *  消息ID是一个计数器, 长度为14bits, notify消息没有消息ID
 *
 *  @param data, data长度为2个字节
 *
 *  @return int
 */
- (NSInteger)getMessageID:(NSData *)data
{
    NSInteger messageID = 0;
    if (data.length == 2) {
        Byte bytes[2];
        [data getBytes:&bytes];
        messageID = (bytes[0] << 8) & 0x3F;
        messageID |= bytes[1] & 0xFF;
    }
    else {
        NSLog(@"不支持该长度的数据转换");
    }
    
    return messageID;
}

/**
 *  NSInteger 转换成 NSData
 *
 *  @param number   待转换的数字
 *  @param length   转换后的NSData长度, 只支持2位和4位
 *
 *  @return data
 */
- (NSData *)intToNSData:(NSInteger)number withLength:(NSInteger)length
{
    Byte bytes[4];
    if (length == 4) {
        bytes[0] = (Byte)(number >> 24 & 0xFF);
        bytes[1] = (Byte)(number >> 16 & 0xFF);
        bytes[2] = (Byte)(number >> 8 & 0xFF);
        bytes[3] = (Byte)(number & 0xFF);
    }
    else if (length == 2) {
        bytes[0] = (Byte)(number >> 8 & 0xFF);
        bytes[1] = (Byte)(number & 0xFF);
    }
    else {
        NSLog(@"不能进行转换");
    }
    
    NSData *addFinal = nil;
    if (length ==4 || length ==2) {
        addFinal = [[NSData alloc ]initWithBytes:bytes length:length];
    }
    return addFinal;
}

/**
 *  messageType 转换成 NSData
 *
 *  @param type     消息类别
 *
 *  @return data
 */
- (NSData *)messageTypeToNSData:(EN_MsgCategory_Type)type
{
    if (EN_MsgCategory_Reserved <= type && EN_MsgCategory_Notification >= type) {
        
        if (self.messageID >= maxIndx) {
            self.messageID = 0;
        }
        NSData *messageIDData = [self intToNSData:_messageID++ withLength:2];
        
        Byte bytes[2];
        [messageIDData getBytes:&bytes];
        bytes[0] |= (type << 6);
        
        NSData *finalData = [NSData dataWithBytes:bytes length:2];
        return finalData;
    }
    else{
        NSLog(@"错误的消息类别");
        return nil;
    }
}

@end




@implementation CLMessage


/**
 *  序列化成NSData
 *
 *  @return data
 */
-(NSData *)toNSData
{
    NSMutableData *data = [[NSMutableData alloc]init];
    [data appendData:[_header toNSData]];
    if(_bodydata != nil)
    {
         [data appendData:_bodydata];
    }
    return data;
}

/**
 *  初始化方法
 *
 *  @param header 消息头
 *  @param data   消息体
 *
 *  @return CLMessage
 */
- (id)initWith:(CLMessageHeader*)header andBody:(NSData*)data
{
    if(header != nil) {
        if( self = [super init])
        {
            _header = header;
            _bodydata = data;
            _header.bodyLength = (int)[data length];
        }
        return  self;
    }
    else {
        return nil;
    }
}



/**
 *  初始化方法
 *
 *  @return 生成默认的一个消息对象
 */
-(id)init
{
    if(self = [super init])
    {
        _header = [[CLMessageHeader alloc] init];
        _bodydata = nil;
    }
    return self;
}



-(NSString*)description
{
    NSString* descriptionstring = [NSString stringWithFormat:@"head = %@, body = %@",_header,_bodydata];
    
    return descriptionstring;
}


@end
