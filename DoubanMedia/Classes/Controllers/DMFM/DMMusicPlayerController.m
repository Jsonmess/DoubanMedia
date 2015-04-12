//
//  DBMusicPlayerController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMusicPlayerController.h"
#import "TabViewManager.h"
#import "DMSysVolumeAjustManager.h"
#import "DMPlayManager.h"
#import "DMMusicPlayManager.h"
#import <UIImageView+AFNetworking.h>
#import "UIImage+loadRemoteImage.h"
#import "DMLoginViewController.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DMMusicPlayerController ()<DMPlayerViewDelegate,MusicPlayDelegate>
{
    DMPlayManager *playMananger;
    DMMusicPlayManager *musicPlayer;
    DMSongInfo *currentPlaySong;//记录正在播放的音乐对象
    BOOL isRedNow;
    NSString *totalTime;//格式化的总时间
    NSMutableDictionary *remoteInfoDic;//用于更新通知中心信息
}
@property (nonatomic) DMPlayerView *mplayView ;
@end

@implementation DMMusicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    [self setUpView];
    [self getSongList];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	//隐藏tabView
	[[[TabViewManager sharedTabViewManager] getTabView] setHidden:YES];
    //添加对音量调节的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeVolume:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
    //注册远程控制
    [[UIApplication sharedApplication]beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter ] removeObserver:self
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
    //注销远程控制
    [[UIApplication sharedApplication]endReceivingRemoteControlEvents];

    [self resignFirstResponder];

}//设置目录
-(void)setUpView
{
    [self setTitle:@"当前播放"];
	//设置左边状态栏
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"BackToList.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"BackToList.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;
    [self.view setBackgroundColor:DMColor(242, 242, 242, 1.0f)];
    if (_mplayView == nil)
    {
        _mplayView = [[DMPlayerView alloc] initWithFrame:ScreenBounds];
        [_mplayView setPlayDelegate:self];
        [self.view addSubview:_mplayView];
        [_mplayView.albumView setRoundImage:[UIImage imageNamed:@"DBFM.png"]];
        [_mplayView.albumView  play];
    }
    //设置频道名称
    [_mplayView setChannelName:[NSString stringWithFormat:@"·· %@ Mhz ··",self.playChannelTitle]];
}
-(void)commonInit
{
   playMananger = [DMPlayManager sharedDMPlayManager];
    musicPlayer = [DMMusicPlayManager sharedMusicPlayManager];
    [musicPlayer setDelegate:self];
    isRedNow = YES;
}
//获取当前频道的音乐列表
-(void)getSongList
{
    [playMananger loadPlaylistwithType:@"n" channelID:self.playChannelId
                   CurrentPlayBackTime:0.0 CurrentSongID:nil];
}
#pragma mark --- actions
-(void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[TabViewManager sharedTabViewManager] getTabView] setHidden:NO];

}

- (void)changeVolume:(id)sender
{
    CGFloat value = [[DMSysVolumeAjustManager sharedSysVolumeAjustManager]
                     getVolumeViewFromMPVolumeView].value;
    [_mplayView.volumeSlider setValue: value];
    [_mplayView syncVolumeValue:value];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---DMPlayDelegate
//标记红心
-(void)likeCurrentSong
{
	 NSString *redhotImage;
    if (isRedNow)
    {
        //标记不喜欢
        [self actionWithType:@"u"];
        redhotImage = @"ic_player_fav_highlight.png";
        isRedNow = NO;
    }
    else
    {
        //标记喜欢
        [self actionWithType:@"r"];
        redhotImage = @"ic_player_fav_selected.png";
        isRedNow = YES;
    }
    [_mplayView.likeBtn setBackgroundImage:[UIImage imageNamed:redhotImage]
                                  forState:UIControlStateNormal];
}
//标记删除
-(void)dislikeCurrentSong
{
    [self actionWithType:@"b"];
}
//下一曲
-(void)playNextSong
{
    [self actionWithType:@"s"];
}
//播放状态
-(void)playState:(BOOL)state
{
    [musicPlayer actionPlayPause:state];
}
//播放中标记操作
-(void)actionWithType:(NSString*)type
{
    [playMananger loadPlaylistwithType:type channelID:self.playChannelId
                   CurrentPlayBackTime:[musicPlayer getCurrentAudioStreamer].currentTime
                         CurrentSongID:currentPlaySong.sid];
}


#pragma mark ----MusicPlayDelegate
-(void)getCurrentPlaySong:(DMSongInfo *)songInfo
{
    currentPlaySong = songInfo ;
    //格式歌曲时间
    [self formatTotalTimeWithCurrentSongInfo:songInfo];
    //更新音乐封面+标题+歌手-----红心状态
    [UIImage getRemoteImageWithUrl:songInfo.picture Suceess:^(UIImage *image) {
        _mplayView.albumView.roundImage = image;
        //更新锁屏信息
        [self lockScreenPlaySongInfoWithSongName:songInfo.title
                                          Artist:songInfo.artist
                                           Album:image];
    }];
    //设置标题
    [_mplayView.songName setText:songInfo.title];
    //设置歌手
    [_mplayView.songArtist setText:songInfo.artist];
    //更新红心状态
    NSString *redhotImage = @"ic_player_fav_highlight.png";
    isRedNow = songInfo.like.integerValue > 0;
    if (isRedNow)
    {
		redhotImage = @"ic_player_fav_selected.png";
    }
    [_mplayView.likeBtn setBackgroundImage:[UIImage imageNamed:redhotImage]
                                  forState:UIControlStateNormal];
    [_mplayView setNeedsLayout];
}
//播放器状态
-(void)getPlayStreamerStatue:(DOUAudioStreamerStatus)status
{
NSString *statusString = @"";
    switch (status)
    {
        case DOUAudioStreamerBuffering:
            //缓冲中
			statusString = @"缓冲中...";
            break;
        case DOUAudioStreamerError:
            //播放错误
			statusString = @"媒体获取失败";
            break;
        case DOUAudioStreamerPlaying:
            //播放错误
            statusString = @"开始播放";
            break;
        default:
            break;
    }
    [_mplayView.playProgress setText:statusString];
}
//播放器进度
-(void)updatePlayProgress:(NSTimeInterval)currentTime
{
//    NSLog(@"当前歌曲时间：%f-----%f",currentTime,len);
   int currentTimeMinutes = (unsigned)currentTime/60;
   int currentTimeSeconds = (unsigned)currentTime%60;
    NSString * currentTimeString;
    if (currentTimeSeconds < 10) {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTimeSeconds];
    }
    else{
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTimeSeconds];
    }
    NSString * timerLabelString = [NSMutableString stringWithFormat:@"%@/%@",currentTimeString,totalTime];
    [_mplayView.playProgress setText:timerLabelString];
//    //更新远程控制
//    [remoteInfoDic setObject:[NSNumber numberWithDouble:(double)currentTime]
//                      forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    [remoteInfoDic setObject:[NSNumber numberWithDouble:[currentPlaySong.length doubleValue]]
//                      forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:remoteInfoDic];
//    });
}
#pragma mark --others
//格式化总时间
-(void)formatTotalTimeWithCurrentSongInfo:(DMSongInfo*)songInfo
{
	   //初始化timeLabel的总时间
   int TotalTimeSeconds = [songInfo.length intValue]%60;
   int TotalTimeMinutes = [songInfo.length intValue]/60;
    NSString *totalTimeString;
    if (TotalTimeSeconds < 10) {
        totalTimeString = [NSMutableString stringWithFormat:@"%d:0%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    else{
        totalTimeString = [NSMutableString stringWithFormat:@"%d:%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    totalTime = totalTimeString;
}
#pragma mark---远程控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:

				[musicPlayer actionPlayPause:NO];
                [_mplayView.albumView pause];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [musicPlayer actionPlayPause:YES];
                [_mplayView.albumView play];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self actionWithType:@"s"];
                break;
            default:
                break;
        }
    }
}
//锁屏数据
-(void)lockScreenPlaySongInfoWithSongName:(NSString *)songName
                                   Artist:(NSString *)artist
                                    Album:(UIImage *)album
		{
			if(NSClassFromString(@"MPNowPlayingInfoCenter"))
			{

				NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];

				[dict setObject:songName forKey:MPMediaItemPropertyTitle];

				[dict setObject:artist forKey:MPMediaItemPropertyArtist];
				[dict setObject:[[MPMediaItemArtwork alloc] initWithImage:album] forKey:MPMediaItemPropertyArtwork];
				[dict setObject:[NSNumber numberWithDouble:[currentPlaySong.length floatValue]]
						 forKey:MPMediaItemPropertyPlaybackDuration];
					[[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
			}

	}
@end
