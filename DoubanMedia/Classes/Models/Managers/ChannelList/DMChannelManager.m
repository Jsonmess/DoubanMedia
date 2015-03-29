//
//  DMChannelManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/29.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMChannelManager.h"
#import "AppDelegate.h"
#import <AFNetworking.h>
#import "FMChannel.h"
@interface DMChannelManager()
{
   AFHTTPRequestOperationManager *OperationManager;
    AppDelegate *appDelegate;
}
@end
@implementation DMChannelManager
-(instancetype)init
{
    if (self = [super init])
    {
        OperationManager = [AFHTTPRequestOperationManager manager ];
        appDelegate =[UIApplication sharedApplication].delegate;

    }
    return self;
}
//设置播放列表
-(void)getChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString
{
    //根据channelIndex
    NSMutableDictionary * theChannels = [appDelegate.channels objectAtIndex:channelIndex];
    [OperationManager GET:urlWithString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //获取到对应index的频道列表
         //1.开始创建tableview需要的数据
        NSMutableArray *subChannels = [theChannels objectForKey:@"subChannels"];
         //当前线程上下文
         NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
         [context setPersistentStoreCoordinator: [NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
         //删除数据库中频道数据+缓存中的频道对象 （刷新时候）
        	for (FMChannel * channel in subChannels)
            {
                [channel MR_deleteInContext:context];
                [subChannels removeObject:channel];
            }
         //获取的频道字典
         NSDictionary *channelsDictionary = responseObject;
         NSDictionary *tempChannel = [channelsDictionary objectForKey:@"data"];


         if (channelIndex != 1)
         {
             for (NSDictionary *channels in [tempChannel objectForKey:@"channels"])
             {
                 FMChannel *channelInfo = [FMChannel MR_createInContext: context];
                 [channelInfo setChannelDictionary:channels ChannelSection:channelIndex];
                 [subChannels addObject:channelInfo];
             }
         }
         else
         {
             NSDictionary *channels = [tempChannel objectForKey:@"res"];
             if ([[channels allKeys]containsObject:@"rec_chls"])
             {
                 for (NSDictionary *tempRecCannels in [channels objectForKey:@"rec_chls"])
                 {
                     FMChannel *channelInfo = [FMChannel MR_createInContext: context];

                     [channelInfo setChannelDictionary:tempRecCannels ChannelSection:channelIndex];
                     [subChannels addObject:channelInfo];
                 }
             }
             else{
                 NSDictionary *channels = [tempChannel objectForKey:@"res"];
                  FMChannel *channelInfo = [FMChannel MR_createInContext: context];
                  [channelInfo setChannelDictionary:channels ChannelSection:channelIndex];
                  [subChannels addObject:channelInfo];
             }
         }
         [theChannels setObject:subChannels forKey:@"subChannels"];
         [self.delegate setTheChannel:theChannels];
    	//2.后台将数据写入数据库
         [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
         {
             if(success)
             {
                 NSLog(@"成功获取频道列表--->将频道对象存入数据库");
             }
             else
             {
 					NSLog(@"将频道对象存入数据库失败----reason:/n%@",error);
             }

         }];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        NSLog(@"获取频道列表失败,reason:\n%@",error);
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
        [context setPersistentStoreCoordinator: [NSPersistentStoreCoordinator MR_defaultStoreCoordinator]];
        //请求不到频道列表-----从数据库中读取
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section = %@",
                                  [NSNumber numberWithInteger:channelIndex]];
        NSArray *channels = [FMChannel MR_findAllWithPredicate:predicate];
		//加工下
		[theChannels setObject:channels forKey:@"subChannels"];
        [self.delegate setTheChannel:theChannels];
    }];
}
@end
