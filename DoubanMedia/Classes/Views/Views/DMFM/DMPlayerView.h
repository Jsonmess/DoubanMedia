//
//  DMPlayerView.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumRoundView.h"
@interface DMPlayerView : UIView
@property (nonatomic) UILabel *playChannel;//播放频道
@property (nonatomic) AlbumRoundView *albumView;
@property (nonatomic) UILabel *songName; //歌曲名称
@property (nonatomic) UIButton *likeBtn; //标记喜欢
@property (nonatomic) UIButton *dislikeBtn;//标记不再收听
@property (nonatomic) UIButton *nextSongBtn;//下一首
@property (nonatomic) UIButton *moreBtn;//更多
@end
