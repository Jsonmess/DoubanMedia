//
//  DBMusicPlayerController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMusicPlayerController.h"
#import "DMPlayerView.h"
@interface DMMusicPlayerController ()
{
    DMPlayerView *playView ;
}
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
    if (playView == nil)
    {
        playView = [[DMPlayerView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:playView];
        [playView.albumView setRoundImage:[UIImage imageNamed:@"Default.png"]];
        [playView.albumView  play];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
