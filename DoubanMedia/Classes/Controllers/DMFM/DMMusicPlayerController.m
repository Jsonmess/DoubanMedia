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
    BOOL playState;//记录播放状态：暂停/播放；
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
    playState = YES;//播放中
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
    playState = state;
    [musicPlayer actionPlayPause:state];
}
//播放中标记操作
-(void)actionWithType:(NSString*)type
{
    [playMananger loadPlaylistwithType:type channelID:self.playChannelId
                   CurrentPlayBackTime:[musicPlayer getCurrentAudioStreamer].currentTime
                         CurrentSongID:currentPlaySong.sid];
}
-(void)getCurrentPlaySong:(DMSongInfo *)songInfo
{
    currentPlaySong = songInfo ;
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
#pragma mark---远程控制
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:

				[musicPlayer actionPlayPause:playState];
                break;
            case UIEventSubtypeRemoteControlPlay:
                [musicPlayer actionPlayPause:playState];
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
    if(NSClassFromString(@"MPNowPlayingInfoCenter")){

        NSMutableDictionary
        *dict=[[NSMutableDictionary alloc]init];

        [dict setObject:songName forKey:MPMediaItemPropertyTitle];

        [dict setObject:artist forKey:MPMediaItemPropertyArtist];

        [dict setObject:[[MPMediaItemArtwork alloc] initWithImage:album] forKey:MPMediaItemPropertyArtwork];

        [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nil];
        
        [[MPNowPlayingInfoCenter defaultCenter]setNowPlayingInfo:dict];
        
    }
    
}
@end
