//
//  AppDelegate.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "DMMusicPlayerController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *channels;//频道分类
@property (nonatomic) DMMusicPlayerController *musicPlayerController;//音乐播放

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

