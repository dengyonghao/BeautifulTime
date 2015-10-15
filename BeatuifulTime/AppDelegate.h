//
//  AppDelegate.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//AppDelegate 实例
+ (AppDelegate *) getInstance;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//进入新手引导页
- (void)enterGuidePage;
//进入首页
- (void)enterHomePage;
@end

