//
//  ViewController.h
//  RemoteLogger
//
//  Created by lihejun on 15/12/16.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (nonatomic, assign) BOOL autoScroll;
@property (weak) IBOutlet NSTextField *topText;
@property (weak) IBOutlet NSPopUpButton *levelSelector;
@property (weak) IBOutlet NSTableView *logTableView;
@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSTextField *deviceText;

- (void)clearLogs;
- (void)toggleAutoScroll;
- (NSString *)exportToFile:(BOOL)silence;
- (void)importFile;

@end

