//
//  ViewController.m
//  RemoteLogger
//
//  Created by lihejun on 15/12/16.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "ViewController.h"
#import "GCDAsyncSocket.h"
#import "GCDAsyncUdpSocket.h"
#import <ifaddrs.h> // for interface addresses needed to find local IP
#include <arpa/inet.h>
#include <netinet/tcp.h>
#include <netinet/in.h>
#include <net/if.h>
#import <stdio.h>
#import "DDFileReader.h"
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_ETH         @"en"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"


typedef enum
{
    TAG_MESSAGE_HEADER = 0,
    TAG_MESSAGE_BODY
}MESSAGE;


/**
 *  Flags accompany each log. They are used together with levels to filter out logs.
 */
typedef NS_OPTIONS(NSUInteger, DDLogFlag){
    /**
     *  0...00000 DDLogFlagError
     */
    DDLogFlagError      = (1 << 0),
    
    /**
     *  0...00001 DDLogFlagWarning
     */
    DDLogFlagWarning    = (1 << 1),
    
    /**
     *  0...00010 DDLogFlagInfo
     */
    DDLogFlagInfo       = (1 << 2),
    
    /**
     *  0...00100 DDLogFlagDebug
     */
    DDLogFlagDebug      = (1 << 3),
    
    /**
     *  0...01000 DDLogFlagVerbose
     */
    DDLogFlagVerbose    = (1 << 4)
};
typedef NS_ENUM(NSUInteger, DDLogLevel){
    /**
     *  No logs
     */
    DDLogLevelOff       = 0,
    
    /**
     *  Error logs only
     */
    DDLogLevelError     = (DDLogFlagError),
    
    /**
     *  Error and warning logs
     */
    DDLogLevelWarning   = (DDLogLevelError   | DDLogFlagWarning),
    
    /**
     *  Error, warning and info logs
     */
    DDLogLevelInfo      = (DDLogLevelWarning | DDLogFlagInfo),
    
    /**
     *  Error, warning, info and debug logs
     */
    DDLogLevelDebug     = (DDLogLevelInfo    | DDLogFlagDebug),
    
    /**
     *  Error, warning, info, debug and verbose logs
     */
    DDLogLevelVerbose   = (DDLogLevelDebug   | DDLogFlagVerbose),
    
    /**
     *  All logs (1...11111)
     */
    DDLogLevelAll       = NSUIntegerMax
};

@interface ViewController ()<GCDAsyncUdpSocketDelegate, GCDAsyncSocketDelegate, NSTableViewDataSource, NSTableViewDelegate, NSSearchFieldDelegate>
{
    NSTimer *_broadcastTimer;
    GCDAsyncUdpSocket *_serverSocket;
    GCDAsyncSocket *_localSocket, *_localClientSocket;
    NSMutableArray *_logs, *_errors, *_warnings, *_infos;
    NSMutableArray *_filters;
    CFAbsoluteTime _refreshTime;
    DDLogFlag _filterLevel;
    BOOL _onFilter;
    dispatch_queue_t _logQueue;
}
@end
@implementation ViewController
@synthesize autoScroll = _autoScroll;

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"等待建立连接...\n"];
//    [str addAttribute:NSForegroundColorAttributeName value:[NSColor whiteColor] range:NSMakeRange(0, str.string.length) ];
//    [_textView.textStorage appendAttributedString:str];
//    [_textView setNeedsDisplay:YES];
    _autoScroll = YES;
    [_levelSelector removeAllItems];
    [_levelSelector addItemsWithTitles:@[@"Error", @"Warning", @"Info", @"Verbose"]];
    [_levelSelector selectItemWithTitle:@"Verbose"];
    _filterLevel = DDLogFlagVerbose;
    _logQueue = dispatch_queue_create("logQueue", DISPATCH_QUEUE_SERIAL);
    // Do any additional setup after loading the view, typically from a nib.
    _serverSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(0, DISPATCH_QUEUE_PRIORITY_HIGH) socketQueue:nil]; // 不阻塞主线程
    NSError *error;
    if (![_serverSocket bindToPort:10086 error:&error]) // 监听所有interface
    {
        NSLog(@"bind to port fail: %i", 10086);
    } else {
        NSLog(@"bind to port %i success", 10086);
        if (![_serverSocket beginReceiving:&error]) {
            NSLog(@"server begin receiving faild! %@", error);
        }
    }
    _localSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:_logQueue];
    _logs = [NSMutableArray array];
    _warnings = [NSMutableArray array];
    _errors = [NSMutableArray array];
    _infos = [NSMutableArray array];
    _logTableView.dataSource = self;
    _logTableView.delegate = self;
    _searchField.delegate = self;
    _deviceText.stringValue = @"Waiting...";
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)clearLogs {
    [_errors removeAllObjects];
    [_warnings removeAllObjects];
    [_infos removeAllObjects];
    [_logs removeAllObjects];
    [_logTableView reloadData];
}

- (void)logback {
    if ([_logs count] > 10000) {
        NSUInteger _calendarUnitFlags = (NSCalendarUnitYear     |
                              NSCalendarUnitMonth    |
                              NSCalendarUnitDay      |
                              NSCalendarUnitHour     |
                              NSCalendarUnitMinute   |
                              NSCalendarUnitSecond);
        NSDateComponents *components = [[NSCalendar autoupdatingCurrentCalendar] components:_calendarUnitFlags fromDate:[NSDate date]];
        NSString *timestamp = [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld ", // yyyy-MM-dd HH:mm:ss:SSS
                (long)components.year,
                (long)components.month,
                (long)components.day,
                (long)components.hour,
                (long)components.minute];
        NSString *path = [self _exportToFile:YES];
        NSDictionary *dict;
        if (!path) {
            dict = @{@"type": @"log", @"flag":@(DDLogLevelError), @"timestamp": timestamp, @"message": @"Auto log back failed!"};
            [_errors addObject:dict];
            [_warnings addObject:dict];
        } else {
            dict = @{@"type": @"log", @"flag":@(DDLogFlagInfo), @"timestamp": timestamp, @"message": [NSString stringWithFormat:@"Auto log back succeed at path: %@!", path]};
            [_errors removeAllObjects];
            [_warnings removeAllObjects];
            [_infos removeAllObjects];
            [_logs removeAllObjects];
        }
        [_infos addObject:dict];
        [_logs addObject:dict];
        [_filters addObject:dict];
    }
}

- (NSString *)exportToFile:(BOOL)silence {
    return [self _exportToFile:silence];
}
- (NSString *)_exportToFile:(BOOL)silence {
    // 导出到文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *logPath = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"remote-logs-%f.txt", CFAbsoluteTimeGetCurrent()]]];
    NSError *error;
    if ([fileManager fileExistsAtPath:[logPath path]]) {
        [fileManager removeItemAtURL:logPath error:&error];
    }
    [fileManager createFileAtPath:[logPath path] contents:nil attributes:nil];
    // write to file
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingURL:logPath error:&error];
    if (error) {
        NSLog(@"%@", error);
        NSAlert *alert = [[NSAlert alloc] init];
        [alert addButtonWithTitle:@"OK"];
        [alert setMessageText:@"Open log file failed!"];
        [alert setInformativeText:@"Please try later."];
        [alert setAlertStyle:NSWarningAlertStyle];
        [alert runModal];
        return nil;
    } else {
        [file writeData:[@"remote_log_file_identifier\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [file writeData:[[_deviceText.stringValue stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [file writeData:[[_topText.stringValue stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        for (NSDictionary *dict in _logs) {
            DDLogFlag flag = [[dict objectForKey:@"flag"] intValue];
            NSString *string = @"unknown";
            switch (flag) {
                case DDLogFlagError:
                    string = @"Error";
                    break;
                case DDLogFlagDebug:
                    string = @"Debug";
                    break;
                case DDLogFlagInfo:
                    string = @"Info";
                    break;
                case DDLogFlagWarning:
                    string = @"Warning";
                    break;
                case DDLogFlagVerbose:
                    string = @"Verbose";
                    break;
                default:
                    break;
            }
            NSString *logStr = [NSString stringWithFormat:@"%@ %@ %@\n", string, [dict objectForKey:@"timestamp"], [dict objectForKey:@"message"]];
            [file writeData:[logStr dataUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [file closeFile];
        if (!silence) {
            [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[logPath]];
        }
        return [logPath path];
    }
    
}

static NSArray * openFiles()
{
    NSArray *fileTypes = [NSArray arrayWithObjects:@"txt", @"log", nil];
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setFloatingPanel:YES];
    [panel setAllowedFileTypes:fileTypes];
    [panel setDirectoryURL:[NSURL URLWithString:NSHomeDirectory()]];
    NSInteger result = [panel runModal];
    if(result == NSOKButton)
    {
        return [panel URLs];
    }
    return nil;
}

- (void)importFile {
    [self _importFile];
    [_logTableView reloadData];
}
- (void)_importFile {
    NSArray *urls = openFiles();
    NSURL *url = [urls firstObject];
    __block BOOL available = NO, deviced = NO, topped = NO;
    DDFileReader * reader = [[DDFileReader alloc] initWithFilePath:[url path]];
    [reader enumerateLinesUsingBlock:^(NSString * line, BOOL * stop) {
        if (!available && [line hasPrefix:@"remote_log_file_identifier"]) {
            available = YES;
            line = nil;
        }
        if (!available) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert addButtonWithTitle:@"OK"];
            [alert setMessageText:@"Read log file failed!"];
            [alert setInformativeText:@"This file is not RemoteLogger supported."];
            [alert setAlertStyle:NSWarningAlertStyle];
            [alert runModal];
        }
        if (line && available && !deviced) {
            _deviceText.stringValue = line;
            deviced = YES;
            line = nil;
        }
        if (line && available && deviced && !topped) {
            _topText.stringValue = line;
            topped = YES;
            line = nil;
        }
        if (line && line.length > 0) {
            // add to logs
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            NSMutableArray *parts = [[line componentsSeparatedByString:@" "] mutableCopy];
            NSString *level = parts[0];
            NSString *timestamp = [parts[1] stringByAppendingFormat:@" %@", parts[2]];
            [dict setObject:timestamp forKey:@"timestamp"];
            [parts removeObjectsInRange:NSMakeRange(0, 3)];
            NSString *message = [parts componentsJoinedByString:@" "];
            [dict setObject: message forKey:@"message"];
            if ([level isEqualToString:@"Error"]) {
                [dict setObject:@(DDLogFlagError) forKey:@"flag"];
                [_errors addObject:dict];
                [_warnings addObject:dict];
                [_infos addObject:dict];
            } else if ([level isEqualToString:@"Warnings"]) {
                [dict setObject:@(DDLogFlagWarning) forKey:@"flag"];
                [_warnings addObject:dict];
                [_infos addObject:dict];
            } else if ([level isEqualToString:@"Info"]) {
                [dict setObject:@(DDLogFlagInfo) forKey:@"flag"];
                [_infos addObject:dict];
            } else {
                [dict setObject:@(DDLogFlagVerbose) forKey:@"flag"];
            }
            [_logs addObject:dict];
        }
    }];
    
}

NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

- (IBAction)toggleChange:(id)sender {
    [self toggleAutoScroll];
}

- (void)toggleAutoScroll {
    _autoScroll = !_autoScroll;
}

- (IBAction)levelFilter:(id)sender {
    NSString *str = _levelSelector.selectedItem.title;
    if ([str isEqualToString:@"Error"]) {
        _filterLevel = DDLogFlagError;
    } else if ([str isEqualToString:@"Warning"]) {
        _filterLevel = DDLogFlagWarning;
    } else if ([str isEqualToString:@"Info"]) {
        _filterLevel = DDLogFlagInfo;
    } else {
        _filterLevel = DDLogFlagVerbose;
    }
    [_logTableView reloadData];
}

-(void)applyFilterWithString:(NSString*)filter {
    NSMutableArray *currents = nil;
    if (_filterLevel == DDLogFlagError) {
        currents = _errors;
    } else if (_filterLevel == DDLogFlagWarning) {
        currents = _warnings;
    } else {
        currents = _logs;
    }
    if (filter.length>0) {
        NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings){
            NSDictionary *dict = (NSDictionary *)evaluatedObject;
            NSString *content = [dict objectForKey:@"message"];
            return [[content lowercaseString] containsString:filter];
        }];
        _filters = [[currents filteredArrayUsingPredicate:filterPredicate] mutableCopy];
        _onFilter = YES;
        [_logTableView reloadData];
    }
    else {
        _onFilter = NO;
        [_logTableView reloadData];
    }
}

#pragma mark - NSSearchFieldDelegate
- (void)controlTextDidChange:(NSNotification *)obj {
    if (obj.object == self.searchField) {
        [self applyFilterWithString:[self.searchField.stringValue lowercaseString]];
    }
}

#pragma mark - NSTableViewDataSource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    if (_onFilter) {
        return [_filters count];
    } else {
        if (_filterLevel == DDLogFlagError) {
            return [_errors count];
        } else if (_filterLevel == DDLogFlagWarning) {
            return [_warnings count];
        } else if (_filterLevel == DDLogFlagInfo) {
            return [_infos count];
        } else {
            return [_logs count];
        }
    }
    
}

#pragma mark - NSTableViewDelegate
#define kCellIdentifier @"logCell"
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSTableCellView *cell = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    NSDictionary *dict = nil;
    if (_onFilter) {
        dict = [_filters objectAtIndex:row];
    } else {
        if (_filterLevel == DDLogFlagError) {
            dict = [_errors objectAtIndex:row];
        } else if (_filterLevel == DDLogFlagWarning) {
            dict = [_warnings objectAtIndex:row];
        } else if (_filterLevel == DDLogFlagInfo) {
            dict = [_infos objectAtIndex:row];
        } else {
            dict = [_logs objectAtIndex:row];
        }
    }
    
    NSString *string = @"unknown";
    DDLogFlag flag = [[dict objectForKey:@"flag"] intValue];
    switch (flag) {
        case DDLogFlagError:
            cell.textField.textColor = [NSColor redColor];
            break;
        case DDLogFlagDebug:
            cell.textField.textColor = [NSColor blackColor];
            break;
        case DDLogFlagInfo:
            cell.textField.textColor = [NSColor blackColor];
            break;
        case DDLogFlagWarning:
            cell.textField.textColor = [NSColor orangeColor];
            break;
        case DDLogFlagVerbose:
            cell.textField.textColor = [NSColor darkGrayColor];
            break;
        default:
            break;
    }
    if (tableColumn == tableView.tableColumns[0]) {
        // level
        DDLogFlag flag = [[dict objectForKey:@"flag"] intValue];
        switch (flag) {
            case DDLogFlagError:
                string = @"Error";
                break;
            case DDLogFlagDebug:
                string = @"Debug";
                break;
            case DDLogFlagInfo:
                string = @"Info";
                break;
            case DDLogFlagWarning:
                string = @"Warning";
                break;
            case DDLogFlagVerbose:
                string = @"Verbose";
                break;
            default:
                break;
        }
    } else if (tableColumn == tableView.tableColumns[1]) {
        string = [dict objectForKey:@"timestamp"];
    } else if (tableColumn == tableView.tableColumns[2]) {
        string = [dict objectForKey:@"message"];
    }
   
    cell.textField.stringValue = string;
    return cell;
}


#pragma mark - GCDAsyncUdpSocketDelegate
static NSString *timestamp;
- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
    if (![_localSocket isConnected]) {
        NSError *error;
        if (![_localSocket connectToAddress:address error:&error]) {
            NSLog(@"_localSocket connectToAddress Failed:%@", error);
        }
    }
}

#pragma mark - GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"建立连接成功！\n"];
//    [str addAttribute:NSForegroundColorAttributeName value:[NSColor greenColor] range:NSMakeRange(0, str.string.length) ];
//    [_textView.textStorage appendAttributedString:str];
    //    [logs addObject:@"建立连接成功！"];
    //    [_tableView reloadData];
    _deviceText.textColor = [NSColor colorWithCalibratedRed:7/255.0f green:200/255.0f blue:25/255.0f alpha:1];
    _deviceText.stringValue = @"Connected";
//    [sock readDataWithTimeout:-1 tag:0];
    
    
    [sock readDataToLength:4
                    withTimeout:-1
                            tag:TAG_MESSAGE_HEADER];
}
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    
    if(tag == TAG_MESSAGE_HEADER)
    {
        if (data.length != 4) {
            NSLog(@"video message header error!");
        }
        else
        {
            NSUInteger bodylength = [self dataToInt:data];
            
            [sock readDataToLength:bodylength
                       withTimeout:-1
                               tag:TAG_MESSAGE_BODY];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self _handleData:data];
        });
        
        [sock readDataToLength:4
                   withTimeout:-1
                           tag:TAG_MESSAGE_HEADER];
    }
}

- (void)_handleDict:(NSDictionary *)dict
{
    
    NSString *type = [dict objectForKey:@"type"];
    if ([type isEqualToString:@"log"]) {
        DDLogLevel flag = [[dict objectForKey:@"flag"] intValue];
        if (flag == DDLogFlagError) {
            [_errors addObject:dict];
            [_warnings addObject:dict];
            [_infos addObject:dict];
            [_logs addObject:dict];
        } else if (flag == DDLogFlagWarning) {
            [_warnings addObject:dict];
            [_infos addObject:dict];
            [_logs addObject:dict];
        }  else if (flag == DDLogFlagInfo) {
            [_infos addObject:dict];
            [_logs addObject:dict];
        } else {
            [_logs addObject:dict];
        }
        if (_onFilter) {
            if ([[dict objectForKey:@"message"] containsString:_searchField.stringValue]) {
                [_filters addObject:dict];
            }
        }
    } else if ([type isEqualToString:@"device"]) {
        NSString *machine = [dict objectForKey:@"machine"];
        NSString *systemVersion = [dict objectForKey:@"systemVersion"];
        _deviceText.stringValue = [NSString stringWithFormat:@"%@ %@", machine, systemVersion];
    } else {
        float cpuUsage = [[dict objectForKey:@"cpuUsage"] floatValue];
        float memUsage = [[dict objectForKey:@"memUsage"] floatValue] / 1024;
        float memDiff = [[dict objectForKey:@"memDiff"] floatValue];
        float freeMem = [[dict objectForKey:@"freeMem"] floatValue] / 1024;
        [_topText setStringValue:[NSString stringWithFormat:@"%3.1f%%, %3.2fMB (%+5.0fKB), %4.2fMB", cpuUsage, memUsage, memDiff, freeMem]];
    }
}

- (void)_handleData:(NSData *)data
{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    
    if (!error) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [self _handleDict:obj];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in obj) {
                [self _handleDict:dict];
            }
            NSUInteger rowCount = 0;
            if (_filterLevel == DDLogFlagError) {
                rowCount = [_errors count];
            } else if (_filterLevel == DDLogFlagWarning) {
                rowCount = [_warnings count];
            } else if (_filterLevel == DDLogFlagInfo) {
                rowCount = [_infos count];
            } else {
                rowCount = [_logs count];
            }
            [_logTableView reloadData];
            if (_autoScroll) {
                [_logTableView scrollRowToVisible:rowCount - 1];
            }
            [self logback];
        }
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"断开连接！\n"];
//    [str addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:NSMakeRange(0, str.string.length) ];
//    [_textView.textStorage appendAttributedString:str];
    //    [logs addObject:@"断开连接！"];
    //    [_tableView reloadData];
    _deviceText.textColor = [NSColor redColor];
}

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


@end
