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
@interface DMPlayerView()
{
    UISlider *volumeSlider;//控制音量
    UIImageView *backgroundImage;//背景图片
    UIImageView *volumeIcon;//音量标示
    UIView *BtnParentView ;//用于承装按钮--用于布局

}
@end
@implementation DMPlayerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}
//设置视图View
-(void)setUpView
{
    backgroundImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    BtnParentView = [[UIView alloc] initWithFrame:CGRectZero];
    _playChannel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_playChannel setFont:DMBoldFont(18.0f)];
    [_playChannel setText:@"。。。当前频道。。。"];
    [_playChannel setTextColor:DMColor(210, 242, 158, 1.0f)];
    _albumView = [[AlbumRoundView alloc] initWithFrame:CGRectZero];

    _songName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_songName setTextColor:_playChannel.textColor];
    [_songName setText:@"锦鲤抄"];
    [_songName setFont:DMFont(15.0f)];
    //音量icon
    volumeIcon  = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"play_sound@2x.png"]];
    //音量滑块
    volumeSlider = [[UISlider alloc] init];
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
    [self addSubview:backgroundImage];
    [self addSubview:_playChannel];
    [self addSubview:_albumView];
    [self addSubview:_songName];
    [self addSubview:volumeIcon];
    [self addSubview:volumeSlider];
    [self addSubview:BtnParentView];
    [BtnParentView addSubview:_likeBtn];
    [BtnParentView addSubview:_dislikeBtn];
    [BtnParentView addSubview:_nextSongBtn];


    [self setcontains];
}
-(void)setcontains
{
    [backgroundImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_playChannel autoAlignAxis:ALAxisVertical toSameAxisOfView:backgroundImage];
    [_playChannel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:backgroundImage withOffset:ScreenBounds.size.height *0.15f];
    //专辑
    [_albumView autoAlignAxis:ALAxisVertical toSameAxisOfView:backgroundImage];
    [_albumView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_playChannel withOffset:ScreenBounds.size.height *0.07f];
    //根据设备设置其宽高
    CGFloat width,height;
    switch ([DMDeviceManager getCurrentDeviceType]) {
        case kiPhone5:
            width = 200.0f;
            break;
        case kiPhone6:
            width = 250.0f;
            break;
            //屏幕大于6plus以上
        case kIphone6Plus:
            width  = 350.0f;
            break;

        default:
            break;
    }
    height = width;

    [_albumView autoSetDimension:ALDimensionHeight toSize:height];
    [_albumView autoSetDimension:ALDimensionWidth toSize:width];
    //歌曲名称
    [_songName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_albumView
                withOffset:ScreenBounds.size.height *0.04f];
    [_songName autoAlignAxis:ALAxisVertical toSameAxisOfView:backgroundImage];


    //按钮父视图
    [BtnParentView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:backgroundImage
                    withOffset:-ScreenBounds.size.height *0.08f];
    [BtnParentView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:backgroundImage
                    withOffset:ScreenBounds.size.width *0.1f];
    [BtnParentView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:backgroundImage
                    withOffset:-ScreenBounds.size.width *0.1f];
    [BtnParentView autoSetDimension:ALDimensionHeight toSize:36.0f];
    //按键--红心
    CGSize redSize = _likeBtn.currentBackgroundImage.size;
    [_likeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_likeBtn autoSetDimension:ALDimensionWidth toSize:redSize.width*0.5f];
    [_likeBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];
    //标记删除
     CGSize deleteSize = _dislikeBtn.currentBackgroundImage.size;
    [_dislikeBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_dislikeBtn autoSetDimension:ALDimensionWidth toSize:deleteSize.width*0.5f];
    [_dislikeBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];
    //切换歌曲
     CGSize nextSize = _nextSongBtn.currentBackgroundImage.size;
    [_nextSongBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:BtnParentView];
    [_nextSongBtn autoSetDimension:ALDimensionWidth toSize:nextSize.width*0.5f];
    [_nextSongBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:BtnParentView];

    NSArray *buttons = @[_likeBtn,_dislikeBtn,_nextSongBtn];
    CGFloat indexWidth = (ScreenBounds.size.width *0.8f -40.0f*buttons.count)/(buttons.count -1);
    [buttons autoDistributeViewsAlongAxis:ALAxisHorizontal
                                      alignedTo:ALAttributeHorizontal
                                  withFixedSize:indexWidth insetSpacing:NO];
    //音量滑块
    [volumeSlider autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:BtnParentView
                   withOffset:-ScreenBounds.size.height *0.03f];
    [volumeSlider autoSetDimension:ALDimensionHeight toSize:10.0f];
    [volumeSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_likeBtn withOffset:10.0f];
    [volumeSlider autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_nextSongBtn withOffset:-10.0f];
    //音量icon
    CGSize size = volumeIcon.image.size;
    [volumeIcon autoAlignAxis:ALAxisHorizontal toSameAxisOfView:volumeSlider];
    [volumeIcon setContentMode:UIViewContentModeScaleAspectFit];
    [volumeIcon autoSetDimension:ALDimensionHeight toSize:size.height];
    [volumeIcon autoSetDimension:ALDimensionWidth toSize:size.width];
    [volumeIcon autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:volumeSlider withOffset:-5.0f];
    [self setNeedsLayout];
}

#pragma mark ---- actions
//红心
-(void)likeTheSong:(id)sender
{
    [_likeBtn setBackgroundImage:[UIImage imageNamed:@"ic_player_fav_selected.png"]
                        forState:UIControlStateNormal];
}
//标记删除
-(void)disLikeTheSong:(id)sender
{

}
//下一首
-(void)playNextSong:(id)sender
{
    
}
//更多
-(void)showMore:(id)sender
{
    
}
@end
