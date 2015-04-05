//
//  DMPlayManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/5.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMPlayManager : NSObject
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
-(NSMutableArray *)loadPlaylistwithType:(NSString *)type
                              channelID:(NSString*)c_id
                    CurrentPlayBackTime:(NSTimeInterval)currentPlaybackTime
                          CurrentSongID:(NSString *)songID;
@end
