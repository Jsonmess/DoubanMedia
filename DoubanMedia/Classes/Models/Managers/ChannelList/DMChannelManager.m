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
        [self initThePrivateChannel];

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
         if (subChannels ==nil)
         {
             subChannels = [NSMutableArray array];
         }
         //当前线程上下文

         NSManagedObjectContext *context = [NSManagedObjectContext
                                            MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
         //查询数据库，把原来的数据进行清理---用于冷启动程序+刷新频道列表情况
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section = %@",
                                   [NSNumber numberWithInteger:channelIndex]];
         NSArray *channelsArray =[FMChannel MR_findAllWithPredicate:predicate];
         if (channelsArray.count > 0)
         {
             [subChannels removeAllObjects];
             [FMChannel MR_deleteAllMatchingPredicate:predicate inContext:context];
             [context MR_saveToPersistentStoreAndWait];
//             [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
//              {
//
//                  if (success)
//                  {
//                      NSLog(@"清理频道数据成功");
//                  }else
//                  {
//                      NSLog(@"qinglishibai");
//                  }
//              }];
         }

         //获取的频道字典
         NSDictionary *channelsDictionary = responseObject;
         NSDictionary *tempChannel = [channelsDictionary objectForKey:@"data"];


         if (channelIndex != 1)
         {

             for (NSDictionary *channels in [tempChannel objectForKey:@"channels"])
             {
                 FMChannel *channelInfo = [FMChannel MR_createInContext:context ];
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
                 //                 context=[NSManagedObjectContext MR_context];
                 NSDictionary *channels = [tempChannel objectForKey:@"res"];
                 FMChannel *channelInfo = [FMChannel MR_createInContext: context];
                 [channelInfo setChannelDictionary:channels ChannelSection:channelIndex];
                 [subChannels addObject:channelInfo];
             }
         }

         [theChannels setObject:subChannels forKey:@"subChannels"];
         //2.后台将数据写入数据库
         [ context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
          {
              if(success)
              {
                  NSLog(@"成功获取频道列表--->将频道对象存入数据库");
                  [self.delegate shouldReloadData:NO];
              }
              else
              {
                  NSLog(@"将频道对象存入数据库失败----reason:/n%@",error);
              }

          }];
     }
        failure:^(AFHTTPRequestOperation *operation, NSError *error)

    {
         NSLog(@"获取频道列表失败,reason:\n%@",error);
         //请求不到频道列表-----从数据库中读取
         [self.delegate shouldReloadData:YES];
     }];
}
-(void)initThePrivateChannel
{
    //我的兆赫
    NSManagedObjectContext *firstContext= [NSManagedObjectContext
                                           MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
    FMChannel *myPrivateChannel = [FMChannel MR_createInContext:firstContext];
    myPrivateChannel.channelName = @"私人兆赫";
    myPrivateChannel.channelID = @"0";
    myPrivateChannel.section = [NSNumber numberWithInt:0];//查询标记
    FMChannel *myRedheartChannel = [FMChannel MR_createInContext:firstContext];
    myRedheartChannel.channelName = @"我的红心";
    myRedheartChannel.channelID = @"-3";
    myRedheartChannel.section = [NSNumber numberWithInt:0];//查询标记

    //清理数据

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"section = %@",
                              [NSNumber numberWithInteger:0]];
    NSArray *channelsArray =[FMChannel MR_findAllWithPredicate:predicate];
    if (channelsArray.count <= 0)
    {
//            [FMChannel MR_deleteAllMatchingPredicate:predicate
//                                       inContext:[NSManagedObjectContext MR_defaultContext]];
//
//        [firstContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
//         {
//
//             if (success)
//             {
//                 NSLog(@"清理本地频道数据成功");
//             }
//         }];

    [firstContext MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
     {
         if(success)
         {
             NSLog(@"成功本地频道列表--->将频道对象存入数据库");
             
         }
         else
         {
             NSLog(@"将本地频道对象存入数据库失败----reason:/n%@",error);
         }
         
     }];
    }
}
@end
