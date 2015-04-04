//
//  DMPlayerView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMPlayerView.h"
#import <UIButton+RACCommandSupport.h>
@interface DMPlayerView()
{
    UISlider *volumeSlider;//控制音量
    UIImageView *backgroundImage;//背景图片
    UIImageView *volumeIcon;//音量标示

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

    _playChannel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_playChannel setFont:DMBoldFont(18.0f)];
    [_playChannel setTextColor:DMColor(210, 242, 158, 1.0f)];
    _albumView = [[AlbumRoundView alloc] initWithFrame:CGRectZero];
    _songName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_songName setTextColor:_playChannel.textColor];
    [_songName setFont:DMFont(15.0f)];
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn setFrame:CGRectZero];
    [_likeBtn.titleLabel setText:@"红心"];
    [_likeBtn.titleLabel setFont:DMFont(13.0f)];
    [_likeBtn.titleLabel setTextColor:[UIColor greenColor]];
	[[_likeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    	subscribeNext:^(id x)
   		 {
      	  	[self likeTheSong:_likeBtn];

   		 }];
    _dislikeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_dislikeBtn setFrame:CGRectZero];
    [_dislikeBtn.titleLabel setText:@"删除"];
    [_dislikeBtn.titleLabel setFont:DMFont(13.0f)];
    [_dislikeBtn.titleLabel setTextColor:[UIColor greenColor]];
    [[_dislikeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    	subscribeNext:^(id x)
     {
         [self disLikeTheSong:_dislikeBtn];

     }];
    _nextSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextSongBtn setFrame:CGRectZero];
    [_nextSongBtn.titleLabel setText:@"切歌"];
    [_nextSongBtn.titleLabel setFont:DMFont(13.0f)];
    [_nextSongBtn.titleLabel setTextColor:[UIColor greenColor]];
    [[_nextSongBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [self playNextSong:_nextSongBtn];
    }];
    _moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreBtn setFrame:CGRectZero];
    [_moreBtn.titleLabel setText:@"更多"];
    [_moreBtn.titleLabel setFont:DMFont(13.0f)];
    [_moreBtn.titleLabel setTextColor:[UIColor greenColor]];
    [[_moreBtn rac_signalForControlEvents:UIControlEventTouchUpInside]
    subscribeNext:^(id x) {
        [self showMore:_moreBtn];
    }];
    [self setcontains];
}
-(void)setcontains
{
    [backgroundImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [_playChannel autoAlignAxis:ALAxisVertical toSameAxisOfView:backgroundImage];
    //专辑
    [_albumView autoAlignAxis:ALAxisVertical toSameAxisOfView:backgroundImage];
    //根据设备设置其宽高



}
#pragma mark ---- actions
//红心
-(void)likeTheSong:(id)sender
{

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
