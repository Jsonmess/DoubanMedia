//
//  DMMusicPlayManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/8.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DMSongInfo.h"
#import <DOUAudioStreamer.h>
typedef void (^songPlayProgress)(NSTimeInterval len,NSTimeInterval currentTime);
@protocol MusicPlayDelegate<NSObject>

-(void)getCurrentPlaySong:(DMSongInfo *)songInfo;
@optional
//同步播放进度
-(void)updatePlayProgress:(songPlayProgress)progress;
@end
//泛型的指针
static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;
@interface DMMusicPlayManager : NSObject
@property(nonatomic)id<MusicPlayDelegate>delegate;
//播放暂停
- (void)actionPlayPause:(BOOL)sender;
//单例
+ (instancetype)sharedMusicPlayManager;
//从音乐数组中添加音乐对象
-(void)addMusicItemFromArray:(NSArray *)musicArray shouldPlayNow:(BOOL)playNow;
//获取播放流对象
-(DOUAudioStreamer *)getCurrentAudioStreamer;
@end
