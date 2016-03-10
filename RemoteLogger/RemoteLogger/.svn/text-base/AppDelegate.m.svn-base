//
//  AppDelegate.m
//  RemoteLogger
//
//  Created by lihejun on 15/12/16.
//  Copyright © 2015年 Baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()
{
    ViewController *_viewController;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)applicationDidBecomeActive:(NSNotification *)aNotification {
    
    if (_viewController==nil) {
        _viewController = (ViewController *)[[NSApplication sharedApplication] mainWindow].contentViewController;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    [defaults synchronize];
}

- (IBAction)clearLogs:(id)sender {
    [_viewController clearLogs];
}

- (IBAction)toggleAutoScroll:(NSMenuItem *)sender {
    [_viewController toggleAutoScroll];
    if(_viewController.autoScroll) {
        [sender setTitle:@"AutoScroll[YES]"];
    } else {
        [sender setTitle:@"AutoScroll[NO]"];
    }
}
- (IBAction)import:(id)sender {
    [_viewController importFile];
}
- (IBAction)export:(id)sender {
    [_viewController exportToFile:NO];
}
@end
