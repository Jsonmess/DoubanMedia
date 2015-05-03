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
    NSTimer *timer;//更新播放进度
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
    if (self.playList .count <= 0)
    {
        return;
    }
    if (playNow)
    {
        //红心
        playIndex = 0;
    }
    else
    {
        //立即播放
        [self resetStreamer];
    }
}
- (void)resetStreamer
{
    //清除streamer
    [self cleanStreamer];
    if (playIndex > self.playList.count)
    {
        playIndex = 0;
    }
    //添加定时器
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
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


    //应用前后台判断
    [self PlayMusic];

}
-(void)PlayMusic{

    UIBackgroundTaskIdentifier bgTask = 0;



    if([UIApplication sharedApplication].applicationState== UIApplicationStateBackground) {

        NSLog(@"xxxx后台播放");

        [streamer play];

        UIApplication*app = [UIApplication sharedApplication];

        UIBackgroundTaskIdentifier newTask = [app beginBackgroundTaskWithExpirationHandler:nil];

        if(bgTask!= UIBackgroundTaskInvalid) {

            [app endBackgroundTask: bgTask];
            
        }
        
        bgTask = newTask;
        
    }
    
    else {
        
        NSLog(@"xxx前台播放");
        
        [streamer play];
        
    }
    
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
    timer = nil;
}
//更新播放进度
-(void)updateProgress
{
    NSTimeInterval current = streamer.currentTime;
    [self.delegate updatePlayProgress:current];
}

//更新播放器状态
- (void)updateStatus
{

    if ([streamer status] == DOUAudioStreamerFinished ||
        [streamer status] == DOUAudioStreamerError)
    {
        [self actionPlayNext:nil];
        [timer invalidate];
    }
    [self.delegate getPlayStreamerStatue:[streamer status]];
}
//播放暂停
- (void)actionPlayPause:(BOOL)sender
{
    if (sender)
    {
        [self PlayMusic];
    }
    else
    {
        [streamer pause];
    }
}
//循序播放
- (void)actionPlayNext:(id)sender
{
    if (++playIndex >= [_playList count])
    {
        playIndex = 0;
    }
    //未获取到新的播放列表
    if (_playList.count <= 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"提示" message:@"当前音乐频道列表没有歌曲,\n请切换到其他频道"
                                  delegate:self cancelButtonTitle:@"好的"
                                  otherButtonTitles: nil];
        [alertView setContentMode:UIViewContentModeCenter];
        [alertView show];

        return;
    }
    [self resetStreamer];
}
-(DOUAudioStreamer *)getCurrentAudioStreamer
{
    return streamer;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
//    else if (context == kDurationKVOKey) {
//        [self performSelector:@selector(updateProgress)
//                     onThread:[NSThread mainThread]
//                   withObject:nil
//                waitUntilDone:NO];
//    }

}

@end
