//
//  DMPlayerView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMPlayerView.h"
#import <UIButton+RACCommandSupport.h>
#import "DMDeviceManager.h"
#import "DMSysVolumeAjustManager.h"
@interface DMPlayerView()<AlbumRoundViewDelegate>
{
    UIView *BtnParentView ;//用于承装按钮--用于布局
    UIPanGestureRecognizer *panGestureRecognizer;
    DMSysVolumeAjustManager *volumeManager;//播放音量管理
    CGFloat volumeValue;//记录音量值
    UISlider *volumeSystemSilder;//系统控制音量

}
@property (nonatomic)UIImageView *backgroundImage;//背景图片
@property (nonatomic)UIImageView *volumeIcon;//音量标示
@end
@implementation DMPlayerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];
        [self setUpView];
    }
    return self;
}
-(void)commonInit
{
    volumeManager = [DMSysVolumeAjustManager sharedSysVolumeAjustManager];
}
//设置视图View
-(void)setUpView
{
    _backgroundImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [_backgroundImage setBackgroundColor:DMColor(250,250,248,1.0f)];
    BtnParentView = [[UIView alloc] initWithFrame:CGRectZero];
    _playChannel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_playChannel setFont:DMBoldFont(22.0f)];
    // [_playChannel setText:@"。。。当前频道。。。"];
    [_playChannel setTextColor:DMColor(34, 100, 44, 1.0f)];
    _albumView = [[AlbumRoundView alloc] initWithFrame:CGRectZero];
    [_albumView setDelegate:self];
    //播放进度
    _playProgress = [[UILabel alloc] initWithFrame:CGRectZero];
	[_playProgress setText:@"  "];
    [_playProgress setTextColor:DMColor(65, 205, 59, 1.0f)];
    [_playProgress setFont:DMFont(13.0f)];
    _songName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_songName setTextColor:_playChannel.textColor];
    //[_songName setText:@"锦鲤抄"];
    [_songName setFont:DMFont(17.0f)];
    //歌手名称
    _songArtist = [[UILabel alloc] initWithFrame:CGRectZero];
    [_songArtist setTextColor:_playChannel.textColor];
    [_songArtist setFont:DMFont(13.0f)];
//    [_songArtist setText:@"银临"];
    //音量icon
    _volumeIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_sound@2x.png"]];
    //音量滑块
    _volumeSlider = [[UISlider alloc] init];
    [_volumeSlider setMinimumTrackTintColor:DMColor(100, 100, 100, 1.0f)];
    [_volumeSlider setMaximumTrackTintColor:DMColor(200, 200, 200, 1.0f)];
    [_volumeSlider setMinimumValue:0.0f];
    [_volumeSlider setMaximumValue:1.0f];
    //DMPlayerManager 中获取系统音量大小
    [volumeManager addVolumeViewToCurrentView:self];
    CGFloat value = [volumeManager  getVolumeViewFromMPVolumeView].value;
    volumeValue = value;
    [_volumeSlider setValue:value];
    [_volumeSlider addTarget:self action:@selector(setPlayMediaVolume:)
           forControlEvents:UIControlEventValueChanged];
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setFrame:CGRectZero];
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_disable.png"]
                        forState:UIControlStateDisabled];
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_highlight.png"]
                        forState:UIControlStateNormal];
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_selected_highlight.png"]
                        forState:UIControlStateHighlighted];
    [[_likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    	subscribeNext:^(id x)
     {
         [self likeTheSong:_likeBtn];

     }];
    _dislikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dislikeBtn setFrame:CGRectZero];
    [_dislikeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_ban_disable.png"]
                           forState:UIControlStateDisabled];
    [_dislikeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_ban_highlight.png"]
                           forState:UIControlStateNormal];
    [_dislikeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_ban_disable.png"]
                           forState:UIControlStateHighlighted];
    [[_dislikeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    	subscribeNext:^(id x)
     {
         [self disLikeTheSong:_dislikeBtn];

     }];
    _nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextSongBtn setFrame:CGRectZero];
    [_nextSongBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_next_disable.png"]
                            forState:UIControlStateDisabled];
    [_nextSongBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_next_highlight.png"]
                            forState:UIControlStateNormal];
    [_nextSongBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_next_disable.png"]
                            forState:UIControlStateHighlighted];
    [[_nextSongBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [self playNextSong:_nextSongBtn];
     }];
    [self addSubview:_backgroundImage];
    [self addSubview:_playChannel];
    [self addSubview:_albumView];
    [self addSubview:_playProgress];
    [self addSubview:_songName];
    [self addSubview:_songArtist];
    [self addSubview:_volumeIcon];
    [self addSubview:_volumeSlider];
    [self addSubview:BtnParentView];
    [BtnParentView addSubview:_likeBtn];
    [BtnParentView addSubview:_dislikeBtn];
    [BtnParentView addSubview:_nextSongBtn];
	//添加拖动手势
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setVolume:)];
    [self addGestureRecognizer:panGestureRecognizer];
    [self setcontains];
}
-(void)setcontains
{
    [_backgroundImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_playChannel autoAlignAxis:ALAxisVertical toSameAxisOfView:_backgroundImage];
    [_playChannel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_backgroundImage
                   withOffset:ScreenBounds.size.height *0.15f];
    [_playChannel autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_backgroundImage withOffset:ScreenBounds.size.width *0.1f];
 	[_playChannel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_backgroundImage withOffset:-ScreenBounds.size.width *0.1f];
    [_playChannel setTextAlignment:NSTextAlignmentCenter];
    //专辑
    [_albumView autoAlignAxis:ALAxisVertical toSameAxisOfView:_backgroundImage];
    [_albumView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_playChannel
                 withOffset:ScreenBounds.size.height *0.05f];
    //根据设备设置其宽高
    CGFloat width,height,songArtistLocate;
    songArtistLocate = ScreenBounds.size.height *0.05f;
    switch ([DMDeviceManager getCurrentDeviceType])
    {
        case kiPhone5s:
            width = 200.0f;
            break;
        case kiPhone4s:
            width = 175.0f;
            break;
        case kiPhone6:
            width = 260.0f;
            songArtistLocate = ScreenBounds.size.height *0.07f;
            break;
            //屏幕大于6plus以上
        case kiPhone6Plus:
            width  = 320.0f;
            songArtistLocate = ScreenBounds.size.height *0.06f;
            break;
            case kiPad:
             width  = 360.0f;
            songArtistLocate = ScreenBounds.size.height *0.12f;
            break;

        default:
            break;
    }
    height = width;

    [_albumView autoSetDimension:ALDimensionHeight toSize:height];
    [_albumView autoSetDimension:ALDimensionWidth toSize:width];

    //按钮父视图
    [BtnParentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_backgroundImage
                    withOffset:-ScreenBounds.size.height *0.08f];
    [BtnParentView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_backgroundImage
                    withOffset:ScreenBounds.size.width *0.1f];
    [BtnParentView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_backgroundImage
                    withOffset:-ScreenBounds.size.width *0.1f];
    [BtnParentView autoSetDimension:ALDimensionHeight toSize:36.0f];
    //按键--红心
    [_likeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_likeBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];
    //标记删除
    [_dislikeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_dislikeBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];
    //切换歌曲
    [_nextSongBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_nextSongBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];

    NSArray *buttons = @[_likeBtn,_dislikeBtn,_nextSongBtn];
    [buttons autoSetViewsDimension:ALDimensionWidth toSize:52.0f];
    CGFloat indexWidth = (ScreenBounds.size.width *0.8f -52.0f*buttons.count)/(buttons.count-1);
    [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal
                                alignedTo:ALAttributeHorizontal
                            withFixedSize:indexWidth insetSpacing:NO];
    //音量滑块
    [_volumeSlider autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:BtnParentView
                   withOffset:-ScreenBounds.size.height *0.02f];
    [_volumeSlider autoSetDimension:ALDimensionHeight toSize:10.0f];
    [_volumeSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_likeBtn withOffset:10.0f];
    [_volumeSlider autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_nextSongBtn withOffset:-10.0f];
    //音量icon
    CGSize size = _volumeIcon.image.size;
    [_volumeIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_volumeSlider];
    [_volumeIcon setContentMode:UIViewContentModeScaleAspectFit];
    [_volumeIcon autoSetDimension:ALDimensionHeight toSize:size.height];
    [_volumeIcon autoSetDimension:ALDimensionWidth toSize:size.width];
    [_volumeIcon autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:_volumeSlider withOffset:-5.0f];

    //歌手
    [_songArtist autoAlignAxis:ALAxisVertical toSameAxisOfView:_backgroundImage];

    [_songArtist autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_volumeSlider
                  withOffset:-songArtistLocate];
    [_songArtist autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width *0.6f];
    [_songArtist setTextAlignment:NSTextAlignmentCenter];
    //歌曲名称
    [_songName autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_songArtist
                withOffset:-4.0f];
    [_songName autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self
                withOffset:ScreenBounds.size.width *0.1f];
    [_songName autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self
                withOffset:-ScreenBounds.size.width *0.1f];
    [_songName setTextAlignment:NSTextAlignmentCenter];
    [_songName setNumberOfLines:0];
    [_songName setPreferredMaxLayoutWidth:ScreenBounds.size.width *0.8f];
    [_songName autoAlignAxis:ALAxisVertical toSameAxisOfView:_backgroundImage];
    //播放进度
    [_playProgress autoAlignAxis:ALAxisVertical toSameAxisOfView:_backgroundImage];
    [_playProgress autoSetDimension:ALDimensionWidth
                             toSize:ScreenBounds.size.width *0.6f];
    [_playProgress autoSetDimension:ALDimensionHeight
                             toSize:20.0f];
    [_playProgress autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_songName withOffset:-5.0f];
    [_playProgress setTextAlignment:NSTextAlignmentCenter];
    [self setNeedsLayout];
}

#pragma mark ---- actions
//设置频道text
-(void)setChannelName:(NSString *)channelName
{
    [self.playChannel setText:channelName];
}
//设置歌曲名称
-(void)setSongTitle:(NSString *)title
{
    [self.songName setText:title];
}
//设置专辑图片
-(void)setAlbumImage:(UIImage *)image
{
    [self.albumView setRoundImage:image];
}
//设置音量
-(void)setPlayMediaVolume:(UISlider*)sender
{
    //PlayManager 进行操作
    if (volumeSystemSilder == nil)
    {
        volumeSystemSilder = [volumeManager getVolumeViewFromMPVolumeView];
    }
    [volumeSystemSilder setValue:sender.value animated:YES];
    
}
//红心
-(void)likeTheSong:(id)sender
{
    [self.playDelegate likeCurrentSong];
}
//标记删除
-(void)disLikeTheSong:(id)sender
{
    [self.playDelegate dislikeCurrentSong];
}
//下一首
-(void)playNextSong:(id)sender
{
    [self.playDelegate playNextSong];
}
//设置为红心
-(void)setlikeCurrentSongState
{
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_selected.png"]
                        forState:UIControlStateNormal];
}
-(void)setDislikeSong
{
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_disable.png"]
                        forState:UIControlStateNormal];
}
//手势调节音量
-(void)setVolume:(UIPanGestureRecognizer *)recognizer
{
    if (UIGestureRecognizerStateChanged == recognizer.state)
    {
        CGPoint deltaPoint = [recognizer translationInView:self];
        volumeValue += deltaPoint.x*0.07f/ScreenBounds.size.width;
    }
    if (volumeValue < 0)
    {
        volumeValue = 0;
    }
    if (volumeValue > 1)
    {
        volumeValue = 1;
    }
     [_volumeSlider setValue:volumeValue];
    UISlider *slider = [volumeManager getVolumeViewFromMPVolumeView];
    [slider setValue:volumeValue animated:YES];
}
-(void)syncVolumeValue:(CGFloat)value
{
    volumeValue = value;
}
#pragma mark ---- AlbumRoundViewDelegate
-(void)playStatuUpdate:(BOOL)playState
{
    [self.playDelegate playState:playState];
}
@end
