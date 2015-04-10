//
//  DMMusicPlayManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/8.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMusicPlayManager.h"
@interface DMMusicPlayManager()
{
    CGFloat hasPlayTime;
    DOUAudioStreamer *streamer;
    NSInteger playIndex;//标记播放索引
}
@property (nonatomic) NSMutableArray *playList;//用于存储SongInfo对象
@end
@implementation DMMusicPlayManager

//单例
+ (instancetype)sharedMusicPlayManager
{
    static DMMusicPlayManager *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[DMMusicPlayManager alloc] init];
    });
    return shared;
}


-(NSMutableArray *)getPlayList
{
    return _playList;
}
//初始化音乐队列
-(void)addMusicItemFromArray:(NSArray *)musicArray shouldPlayNow:(BOOL)playNow
{
    self.playList = [NSMutableArray arrayWithArray:musicArray];
    if (!playNow)
    {
        //立即播放
        [self resetStreamer];
    }
    else
    {
        //红心
        playIndex = 0;
    }
}
- (void)resetStreamer
{
    //清除streamer
    [self cleanStreamer];
    DMSongInfo *songInfo = self.playList[playIndex];
    streamer = [DOUAudioStreamer streamerWithAudioFile:songInfo];
    //添加状态
    [streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew
                  context:kStatusKVOKey];
    [streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew
                  context:kDurationKVOKey];
    [streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew
                  context:kBufferingRatioKVOKey];

    //将音乐对象传出
    [self.delegate getCurrentPlaySong:songInfo];
    [streamer play];

}
- (void)cleanStreamer
{
    if (streamer != nil)
    {
        [streamer pause];
        [streamer removeObserver:self forKeyPath:@"status"];
        [streamer removeObserver:self forKeyPath:@"duration"];
        [streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        streamer = nil;
    }
}
//更新播放器状态
- (void)_updateStatus
{
    switch ([streamer status])
    {
        case DOUAudioStreamerPlaying:
            break;

        case DOUAudioStreamerPaused:

            break;

        case DOUAudioStreamerIdle:
            break;

        case DOUAudioStreamerFinished:
            [self actionPlayNext:nil];
            break;

        case DOUAudioStreamerBuffering:
            break;

        case DOUAudioStreamerError:
            break;
    }
}
//播放暂停
- (void)actionPlayPause:(BOOL)sender
{
    if (sender)
    {
		[streamer play];
    }
    else
    {
        [streamer pause];
    }
}
//循序播放
- (void)actionPlayNext:(id)sender
{
    if (++playIndex >= [_playList count]) {
        playIndex = 0;
    }
    [self resetStreamer];
}
-(DOUAudioStreamer *)getCurrentAudioStreamer
{
    return streamer;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
//    else if (context == kDurationKVOKey) {
//        [self performSelector:@selector(_timerAction:)
//                     onThread:[NSThread mainThread]
//                   withObject:nil
//                waitUntilDone:NO];
//    }
//    else if (context == kBufferingRatioKVOKey) {
//        [self performSelector:@selector(_updateBufferingStatus)
//                     onThread:[NSThread mainThread]
//                   withObject:nil
//                waitUntilDone:NO];
//    }
//    else {
//        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//    }
}

@end
