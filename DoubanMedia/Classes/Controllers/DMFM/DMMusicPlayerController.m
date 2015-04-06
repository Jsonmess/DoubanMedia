//
//  DBMusicPlayerController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMusicPlayerController.h"
#import "TabViewManager.h"
@interface DMMusicPlayerController ()<DMPlayerViewDelegate>
@end

@implementation DMMusicPlayerController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏tabView
    [[[TabViewManager sharedTabViewManager] getTabView] setHidden:YES];
//    [self.view setBounds:CGRectMake(0, 0, 320, 568)];
//    [self.view setNeedsLayout];
    CGSize size = self.view.bounds.size;
    [self.view setFrame:ScreenBounds];
}
//设置目录----
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
    if (_playView == nil)
    {
        _playView = [[DMPlayerView alloc] initWithFrame:ScreenBounds];
        [self.view addSubview:_playView];
        [_playView.albumView setRoundImage:[UIImage imageNamed:@"Default.png"]];
        [_playView.albumView  play];
    }
}
#pragma mark --- actions
-(void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[TabViewManager sharedTabViewManager]getTabView] setHidden:NO];
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

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"点击了");
}
@end
