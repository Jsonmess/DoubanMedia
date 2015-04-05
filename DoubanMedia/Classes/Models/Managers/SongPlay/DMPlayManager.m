//
//  DMPlayManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/5.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMPlayManager.h"
#import <AFNetworking.h>
@interface DMPlayManager()
{
    AFHTTPRequestOperationManager *manager;
}
@end
@implementation DMPlayManager

-(instancetype)init
{
    if (self = [super init])
    {
        manager = [AFHTTPRequestOperationManager manager];
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
//-(NSMutableArray *)loadPlaylistwithType:(NSString *)type
//                  channelID:(NSString*)c_id
//        CurrentPlayBackTime:(NSTimeInterval)currentPlaybackTime
//              CurrentSongID:(NSString *)songID
//{
//    NSMutableArray *songList = [NSMutableArray array];
//    NSString *playlistURL = [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite",type,songID,currentPlaybackTime,c_id];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    [manager GET:playlistURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
//    {
//        NSDictionary *songDictionary = responseObject;
//        for (NSDictionary *song in [songDictionary objectForKey:@"song"])
//        {
//            //subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
//            if ([[song objectForKey:@"subtype"] isEqualToString:@"T"])
//            {
//                continue;
//            }
////            SongInfo *tempSong = [[SongInfo alloc] initWithDictionary:song];
////            [appDelegate.playList addObject:tempSong];
//        }
//        if ([type isEqualToString:@"r"])
//        {
////            appDelegate.currentSongIndex = -1;
//        }
//        else{
////            if ([appDelegate.playList count] != 0) {
////                appDelegate.currentSongIndex = 0;
////                appDelegate.currentSong = [appDelegate.playList objectAtIndex:appDelegate.currentSongIndex];
////                [appDelegate.player setContentURL:[NSURL URLWithString:appDelegate.currentSong.url]];
////                [appDelegate.player play];
//            }
//            //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
////    else{
////                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
////                [alertView show];
////                ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
////                myPrivateChannel.name = @"我的私人";
////                myPrivateChannel.ID = @"0";
////                appDelegate.currentChannel = myPrivateChannel;
////            }
////        }
////        [self.delegate reloadTableviewData];
////    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
////        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦" otherButtonTitles: nil];
////        [alertView show];
////        NSLog(@"LOADPLAYLIST_ERROR:%@",error);
////    }];
//    }
//        return [NSMutableArray array];
//}
@end
