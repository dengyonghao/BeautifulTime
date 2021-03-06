//
//  AppDelegate.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "AppDelegate.h"
#import "BTGuideViewController.h"
#import "BTHomePageViewController.h"
#import "BTThemeManager.h"
#import "BTBaseNavigationController.h"
#import "BTBaseNavigationController.h"
#import "BTHomePageViewController.h"
#import "Journal.h"
#import "DDRemoteLogger.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "BTIMTabBarController.h"

static AppDelegate *singleton = nil;

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate*)getInstance {
    return singleton;
}

- (BTCoreDataHelper*)cdh {
    if (!_coreDataHelper) {
        _coreDataHelper = [BTCoreDataHelper new];
        [_coreDataHelper setupCoreData];
    }
    return _coreDataHelper;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 开启日志文件记录，主要用于调试，默认关闭
    if (false)
    {
        [DDTTYLogger sharedInstance].colorsEnabled = YES;
        [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
        //DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
        //fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        //fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        //[DDLog addLogger:fileLogger];
        DDRemoteLogger *remoteLogger = [[DDRemoteLogger alloc] init]; // Remote Logger
        [DDLog addLogger:remoteLogger];
    }
    
    //TODO: 用异步加快启动的速度，但登录失败的时候可能会引起其它问题
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(concurrentQueue, ^{
        dispatch_sync(concurrentQueue, ^{
            //login user
            if ([[NSUserDefaults standardUserDefaults] valueForKey:userID] && [[NSUserDefaults standardUserDefaults] valueForKey:userPassword]) {
                [[BTXMPPTool sharedInstance] login:nil];
            }
        });
        dispatch_sync(dispatch_get_main_queue(), ^{
            /* Show the image to the user here on the main queue*/
        });   
    });
    
    
    singleton = self;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:firstLaunch]) {
        [self enterGuidePage];
    }
    else {
        [self enterHomePage];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self cdh];
//    [self demo2 ];
//    [[self cdh] saveContext];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[self cdh] saveContext];
}

#pragma mark 初始化页面栈
- (void)initPages
{
    BTHomePageViewController *homeViewController = [[BTHomePageViewController alloc] init];
    BTBaseNavigationController *homeNavigationController = [[BTBaseNavigationController alloc] initWithRootViewController:homeViewController];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController.view.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = homeNavigationController;
    [self.window makeKeyAndVisible];
}

- (void)initPushSetting
{
    UIUserNotificationType pushTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationSettings *settings =[UIUserNotificationSettings settingsForTypes:pushTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:pushTypes];
    }
}

//进入新手引导页
- (void)enterGuidePage {
    self.window.rootViewController = nil;
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    BTGuideViewController *guideVC = [[BTGuideViewController alloc] init];
    guideVC.hidesBottomBarWhenPushed = YES;
    self.window.rootViewController = guideVC;
    [self.window makeKeyAndVisible];
}

//进入首页
- (void)enterHomePage {
    NSNumber *themeType = [[NSUserDefaults standardUserDefaults] objectForKey:@"BTThemeType"];
    if (themeType == nil) {
        themeType = [NSNumber numberWithInt:BTThemeType_BT_BLUE];
        [[BTThemeManager getInstance] setThemeStyle:(BTThemeType)themeType.longValue];
    }
    else {
        [[BTThemeManager getInstance] setThemeStyle:(BTThemeType)themeType.longValue];
    }
    [self initPages];
    [self initPushSetting];
}

-(UIViewController*)currentTopVc
{
    UINavigationController* VC = self.window.rootViewController.navigationController;
    UIViewController* topVC = VC.topViewController;
    return topVC;
}

@end
