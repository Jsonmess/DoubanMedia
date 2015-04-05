//
//  DBMusicPlayerController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMusicPlayerController.h"
@interface DMMusicPlayerController ()<DMPlayerViewDelegate>
@end

@implementation DMMusicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
//设置目录----
-(void)setUpView
{
    if (_playView == nil)
    {
        _playView = [[DMPlayerView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_playView];
        [_playView.albumView setRoundImage:[UIImage imageNamed:@"Default.png"]];
        [_playView.albumView  play];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---DMPlayDelegate
//标记红心
-(void)likeCurrentSong
{
	
}
//标记删除
-(void)dislikeCurrentSong
{

}
//下一曲
-(void)playNextSong
{

}
@end
