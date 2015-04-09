//
//  DMPlayerView.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumRoundView.h"

@protocol DMPlayerViewDelegate <NSObject>

//标记红心
-(void)likeCurrentSong;
//标记不再播放
-(void)dislikeCurrentSong;
//切换下一曲
-(void)playNextSong;
//播放状态
-(void)playState:(BOOL)state;

@end

@interface DMPlayerView : UIView
@property (nonatomic) UILabel *playChannel;//播放频道
@property (nonatomic) AlbumRoundView *albumView;
@property (nonatomic) UILabel *songName; //歌曲名称
@property (nonatomic) UIButton *likeBtn; //标记喜欢
@property (nonatomic) UIButton *dislikeBtn;//标记不再收听
@property (nonatomic) UIButton *nextSongBtn;//下一首
@property (nonatomic) UISlider *volumeSlider;//控制音量
@property (nonatomic) id<DMPlayerViewDelegate> playDelegate;
-(void)setChannelName:(NSString *)channelName;
-(void)setSongTitle:(NSString *)title;
-(void)setAlbumImage:(UIImage *)image;
//标记红心操作
-(void)setlikeCurrentSongState;
-(void)setDislikeSong;
//同步外键改变系统音量
-(void)syncVolumeValue:(CGFloat)value;
@end
