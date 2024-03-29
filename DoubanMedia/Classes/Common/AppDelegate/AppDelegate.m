//
//  AppDelegate.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "AppDelegate.h"
#import "FMChannel.h"
#import <AVFoundation/AVFoundation.h>
#import "DMDeviceManager.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()
{

    NSManagedObjectContext *firstContext;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initCrashLytic];
	//初始化数据库
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"DoubanMedia.sqlite"];
    //频道分类
    [self initTheChannels];
    //后台播放
    [self playBackGround];
    [self initUmeng];
    return YES;
}
//初始化crashLytics
-(void)initCrashLytic
{
    [Crashlytics startWithAPIKey:@"33ef5c416109bfc525d3a2738ce9f8ed8416f450"];
    [Fabric with:@[CrashlyticsKit]];
}
//初始化友盟统计
-(void)initUmeng
{
    NSString *umengKey = @"554f64fa67e58e3855003865";
    if ([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        umengKey = @"554f654167e58e37110046c5";
    }
    [MobClick startWithAppkey:umengKey reportPolicy:SENDWIFIONLY channelId:@""];
    //日志加密
    [MobClick setEncryptEnabled:YES];
    //后台
    [MobClick setBackgroundTaskEnabled:YES];
}

-(void)playBackGround
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session setCategory:AVAudioSessionCategoryPlayback error:nil])
    {
        [session setActive:YES error:nil];

    }
    //注册远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    //AudioSessionInitialize(NULL, NULL, interruptionListenner, (__bridge void*)self);
}
//初始化频道分类
-(void)initTheChannels
{
     _channels = [NSMutableArray array];
    //初始化数据源Array----0
    NSArray *fmarray = @[@"用户未登录",@"推荐频道",@"上升最快兆赫",@"热门兆赫"];
	//我的兆赫
    NSMutableArray *privateChannels = [NSMutableArray array];
    NSMutableDictionary *private = [NSMutableDictionary dictionary];
    [private setValue:fmarray[0] forKey:@"section"];
    [private setObject:privateChannels forKey:@"subChannels"];
    [_channels addObject:private];
    //推荐兆赫------1
    NSMutableArray *recommendChannels = [NSMutableArray array];
    NSMutableDictionary *recommend = [NSMutableDictionary dictionary];
    [recommend setValue:fmarray[1] forKey:@"section"];
    [recommend setObject:recommendChannels forKey:@"subChannels"];
    [_channels addObject:recommend];
    //上升最快兆赫-----2
    NSMutableArray *upTrendingChannels = [NSMutableArray array];
    NSMutableDictionary *upTrending = [NSMutableDictionary dictionary];
    [upTrending setValue:fmarray[2] forKey:@"section"];
    [upTrending setObject:upTrendingChannels forKey:@"subChannels"];
    [_channels addObject:upTrending];
    //热门兆赫------3
    NSMutableArray *hotChannels = [NSMutableArray array];
    NSMutableDictionary *hot = [NSMutableDictionary dictionary];
    [hot setValue:fmarray[3] forKey:@"section"];
    [hot setObject:hotChannels forKey:@"subChannels"];
    [_channels addObject:hot];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
//    //后台播放
//     AVAudioSession *session = [AVAudioSession sharedInstance];
//     [session setActive:YES error:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //注销远程控制
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];
    //移除远程通知
    if(_musicPlayerController != nil)
    {
   	 [[NSNotificationCenter defaultCenter] removeObserver:_musicPlayerController];
    }
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}
//远程控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *playDic = [NSMutableDictionary dictionary];
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
               [playDic setValue:@"pause" forKey:@"playStatus"];

                break;
            case UIEventSubtypeRemoteControlPlay:
		[playDic setValue:@"play" forKey:@"playStatus"];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
		[playDic setValue:@"next" forKey:@"playStatus"];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [playDic setValue:@"previous" forKey:@"playStatus"];
                break;
            default:
                break;
        }
    }
       [center postNotificationName:@"remoteControl" object:nil userInfo:playDic];
}
////播放被中断处理
//void interruptionListenner(void* inClientData, UInt32 inInterruptionState)
//{
//    AppDelegate* bgDelegate = (__bridge AppDelegate*)inClientData;
//     NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
//     NSMutableDictionary *playDic = [NSMutableDictionary dictionary];
//    if (bgDelegate)
//    {
//        NSLog(@"interruptionListenner %u", (unsigned int)inInterruptionState);
//        if (kAudioSessionBeginInterruption == inInterruptionState)
//        {
//			[playDic setValue:@"pause" forKey:@"playStatus"];
//        }
//        else
//        {
//            NSLog(@"Begin end interruption");
//			[playDic setValue:@"play" forKey:@"playStatus"];
//            NSLog(@"End end interruption");
//        }
//    [center postNotificationName:@"remoteControl" object:nil userInfo:playDic];
//    }
//}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.jsonmess.DoubanMedia" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DoubanMedia" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DoubanMedia.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
