//
//  DBMusicPlayerController.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMPlayerView.h"
@interface DMMusicPlayerController : UIViewController
@property (nonatomic) NSString *playChannelTitle;//标题
@property (nonatomic) NSString *playChannelId;//频道id
- (void)lockScreenPlaySongInfoWithSongName:(NSString *)songName Artist:(NSString *)artist Album:(UIImage *)album;
@end
