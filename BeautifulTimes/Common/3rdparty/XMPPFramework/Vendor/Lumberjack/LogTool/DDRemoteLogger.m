//
//  DDRemoteLogger.m
//  CarLife
//
//  Created by lihejun on 15/12/7.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "DDRemoteLogger.h"
#import "CLMessage.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h> // for interface addresses needed to find local IP
#include <arpa/inet.h>
#include <netinet/tcp.h>
#include <netinet/in.h>
#include <net/if.h>
#import <mach/mach.h>
#import <sys/sysctl.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_ETH         @"en"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

#define LOGHEADLENGTH 4

@interface DDRemoteLogger()<GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate>
@end
@implementation DDRemoteLogger
{
    GCDAsyncUdpSocket *_udpSocket;
    GCDAsyncSocket *_socket, *_client;
    NSTimer *_connectTimer;
    NSUInteger _calendarUnitFlags;
    CFAbsoluteTime _sendTime;
    NSMutableArray *_buffers;
}
- (instancetype)init {
    return [self initWithSocket];
}

- (instancetype)initWithSocket {
    if ((self = [super init])) {
        _calendarUnitFlags = (NSCalendarUnitYear     |
                              NSCalendarUnitMonth    |
                              NSCalendarUnitDay      |
                              NSCalendarUnitHour     |
                              NSCalendarUnitMinute   |
                              NSCalendarUnitSecond);
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT)];
        NSError *error;
        if (![_udpSocket bindToPort:10086 error:&error]) {
            NSLog(@"_udpSocket bindToPort Failed: %@", error);
        }
        [_udpSocket setPreferIPv4];
        if (![_udpSocket enableBroadcast:YES error:&error]) {
            NSLog(@"_udpSocket enableBroadcast Failed: %@", error);
        }
        _connectTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(connect) userInfo:nil repeats:YES];
        _buffers = [NSMutableArray array];
        _sendTime = 0;
    }
    
    return self;
}

- (void)connect {
        NSDictionary *addresses = [self getIPAddresses];
        NSArray *keys = [addresses allKeys];
        for (NSString *key in keys) {
            NSString *ip = [addresses objectForKey:key];
            if ([key rangeOfString:@"broadcast"].location != NSNotFound && ![ip hasPrefix:@"169.254"]) {
                [_udpSocket sendData:[@"DDRemoteLogger" dataUsingEncoding:NSUTF8StringEncoding] toHost:ip port:10086 withTimeout:-1 tag:0];
            }
        }
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_DEFAULT)];
        NSError *error;
        if (![_socket acceptOnPort:10086 error:&error]) {
            NSLog(@"_socket acceptOnPort Failed:%@", error);
            _socket = nil;
        }
    } else {
        NSDictionary *info = logCpuAndMemUsage();
        NSError *error;
        NSData *jsonData = [NSJSONSerialization
                            dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
        if (!error)
        {
            if ([_client isConnected])
            {
                [self pushData:jsonData];
                
//                [_client writeData:jsonData withTimeout:-1 tag:0];
            }
        }
    }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark DDLogger Protocol
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)logMessage:(DDLogMessage *)logMessage {
    NSString *message = logMessage->_message;
    BOOL isFormatted = NO;
    
    if (_logFormatter) {
        message = [_logFormatter formatLogMessage:logMessage];
        isFormatted = message != logMessage->_message;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"log" forKey:@"type"];
    [dict setObject:message forKey:@"message"];
    NSString *time = nil;
    
    // append timestamp
    if (logMessage->_timestamp) {
        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:_calendarUnitFlags fromDate:logMessage->_timestamp];
        
        NSTimeInterval epoch = [logMessage->_timestamp timeIntervalSinceReferenceDate];
        int milliseconds = (int)((epoch - floor(epoch)) * 1000);
        time = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld:%03d ", // yyyy-MM-dd HH:mm:ss:SSS
                (long)components.year,
                (long)components.month,
                (long)components.day,
                (long)components.hour,
                (long)components.minute,
                (long)components.second, milliseconds];
        [dict setObject:time forKey:@"timestamp"];
    }
    
    // append function
    if (logMessage->_function) {
        [dict setObject:logMessage->_function forKey:@"function"];
    }
    if (logMessage->_fileName) {
        [dict setObject:logMessage->_fileName forKey:@"fileName"];
    }
    [dict setObject:@(logMessage->_level) forKey:@"level"];
    [dict setObject:@(logMessage->_flag) forKey:@"flag"];

    @synchronized(_buffers) {
        [_buffers addObject:dict];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        // 该接口需要RunLoop
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(packLefts) object:nil];
    });
    if (_sendTime == 0 // 首次发送需要初始化
        || CFAbsoluteTimeGetCurrent() - _sendTime >= 0.5// 50ms发送一次，这样的话可能最后0.05s的日志不会被发送，所以在else分支发送
        || _buffers.count >= 20) { // 避免内存问题
        // 打包所有日志
        @synchronized(_buffers) {
            NSError *error;
            NSData *jsonData = [NSJSONSerialization
                                dataWithJSONObject:_buffers options:NSJSONWritingPrettyPrinted error:&error];
            if (error)
            {
                NSLog(@"NSJSONSerialization error = %@", error);
            }
            else
            {
//                [_client writeData:jsonData withTimeout:-1 tag:0];
                [self pushData:jsonData];
            }
            
            //NSLog(@"_buffers count = %d ",_buffers.count);
            
            //for(NSObject* obj in _buffers)
            //{
                //NSLog(@"%@",obj);
            //}
            
            [_buffers removeAllObjects];
        }
        _sendTime = CFAbsoluteTimeGetCurrent();
        
    } else {
        // 保证最后的那些日志会被发送出去
        dispatch_async(dispatch_get_main_queue(), ^(void){
            // 该接口需要RunLoop
            [self performSelector:@selector(packLefts) withObject:nil afterDelay:1];
        });
    }
}

- (void)packLefts {
    // 不要阻塞主线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        @synchronized(_buffers) {
            if (_buffers.count > 0) {
                NSError *error;
                NSData *jsonData = [NSJSONSerialization
                                    dataWithJSONObject:_buffers options:NSJSONWritingPrettyPrinted error:&error];
                if (error) {
                    NSLog(@"%@", error);
                } else {
                    [self pushData:jsonData];
//                    [_client writeData:jsonData withTimeout:-1 tag:0];
                }
                [_buffers removeAllObjects];
            }
            
        }
        _sendTime = CFAbsoluteTimeGetCurrent();
    });
    
}

#pragma mark - Transfer
- (void)transfer {
    if (!_client || ![_client isConnected]) {
        return;
    } else {
        @synchronized(_buffers) {
            // 只发送一个包
            if (_buffers.count > 0) {
//                [_client writeData:[_buffers firstObject] withTimeout:-1 tag:0];
            }
        }
        
    }
}

#pragma mark -GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    _client = newSocket;
    _sendTime = 0;
    // 获取手机型号及系统
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:@"device" forKey:@"type"];
    UIDevice* device = [UIDevice currentDevice];
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    [dict setObject:[NSString stringWithUTF8String:machine] forKey:@"machine"];
    [dict setObject:[device systemVersion] forKey:@"systemVersion"];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if (!error)
    {
        
        [self pushData:jsonData];
//        [newSocket writeData:jsonData withTimeout:-1 tag:0];
        _sendTime = CFAbsoluteTimeGetCurrent();
    }
}

#pragma mark - Get IPAddresses
- (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                        
                        if (interface->ifa_dstaddr != NULL) {
                            NSString *key = [NSString stringWithFormat:@"%@/%@", name, @"broadcast"];
                            addresses[key] = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)interface->ifa_dstaddr)->sin_addr)];
                        }
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - CPU Usage
float cpu_usage()
{
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads
    
    basic_info = (task_basic_info_t)tinfo;
    
    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    } // for each thread
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

vm_size_t usedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t freeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

NSDictionary* logCpuAndMemUsage(void) {
    // compute memory usage and log if different by >= 100k
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    static long prevMemUsage = 0;
    long curMemUsage = usedMemory();
    long memUsageDiff = curMemUsage - prevMemUsage;
    float cpuUsage = cpu_usage();
    [dict setObject:@"statistics" forKey:@"type"];
    [dict setObject:@(cpuUsage) forKey:@"cpuUsage"];
    if (memUsageDiff > 100000 || memUsageDiff < -100000) {
        prevMemUsage = curMemUsage;
        [dict setObject:@(curMemUsage/1000.0f) forKey:@"memUsage"];
        [dict setObject:@(memUsageDiff/1000.0f) forKey:@"memDiff"];
        [dict setObject:@(freeMemory()/1000.0f) forKey:@"freeMem"];
//        return [NSString stringWithFormat:@"CPU使用率：%3.1f%%，内存使用：已使用 %7.1f (%+5.0f), 空闲 %7.1f kb \n", cpuUsage, curMemUsage/1000.0f, memUsageDiff/1000.0f, ];
    }
    return dict;
}



-(void)pushData:(NSData*)jsonData
{
    NSData* header =  [[CLMessageHeader alloc]intToNSData:jsonData.length withLength:LOGHEADLENGTH];
    
    NSMutableData* senddata = [[NSMutableData alloc]init];
    [senddata appendData:header];
    [senddata appendData:jsonData];
    
    if([_client isConnected])
    {
        [_client writeData:senddata withTimeout:-1 tag:0];
    }
    
}

@end
