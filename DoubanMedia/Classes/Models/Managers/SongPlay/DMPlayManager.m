//
//  DMPlayManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/5.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMPlayManager.h"
#import "DMSongInfo.h"
#import <AFNetworking.h>
#import "DMMusicPlayManager.h"
@interface DMPlayManager()
{
    AFHTTPRequestOperationManager *manager;
    DMMusicPlayManager *playManager;
}
@end
@implementation DMPlayManager
//单例
+ (instancetype)sharedDMPlayManager
{
    static DMPlayManager *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[DMPlayManager alloc] init];
    });
    return shared;
}
-(instancetype)init
{
    if (self = [super init])
    {
        manager = [AFHTTPRequestOperationManager manager];
        playManager = [DMMusicPlayManager sharedMusicPlayManager];
    }
    return self;
}
//获取播放列表信息
//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
//sid : the song's id
-(void)loadPlaylistwithType:(NSString *)type
                  channelID:(NSString*)c_id
        CurrentPlayBackTime:(NSTimeInterval)currentPlaybackTime
              CurrentSongID:(NSString *)songID
{
    NSMutableArray *songList = [NSMutableArray array];
    NSString *playlistURL = [NSString stringWithFormat:
                             @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite",
                             type,songID,currentPlaybackTime,c_id];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

    [manager GET:playlistURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSDictionary *songDictionary = responseObject;
        for (NSDictionary *song in [songDictionary objectForKey:@"song"])
        {
            //subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
            if ([[song objectForKey:@"subtype"] isEqualToString:@"T"])
            {
                continue;
            }
            DMSongInfo *tempSong = [[DMSongInfo alloc] initWithDictionary:song];
            if (tempSong != nil)
            {
                [songList addObject:tempSong];
            }
        }
        //开始播放
        //
        BOOL playNow = NO;
        if ([type isEqualToString:@"r"])
        {
            playNow = YES;
        }
        
        [playManager addMusicItemFromArray:songList shouldPlayNow:playNow];
    }
         failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"获取播放列表失败"
                                                          delegate:self cancelButtonTitle:@"知道了"
                                                 otherButtonTitles: nil];
        [alertView show];
    }];

    });
}
@end
