//
//  DMFMChannelController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/23.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFMChannelController.h"
#import "BaseTableView.h"
#import "DMFMTableViewCell.h"
#import "DMFMUserHeaderView.h"
#import "DMChannelManager.h"
#import "AccountInfo.h"
#import "AppDelegate.h"
#import "FMChannel.h"
#import "DMMusicPlayerController.h"
#import "DMLoginViewController.h"
#import "UIImage+loadRemoteImage.h"
#import <MJRefresh.h>
@interface DMFMChannelController ()<UITableViewDataSource,UITableViewDelegate,
DMChannelDelegate,NSFetchedResultsControllerDelegate,DMUserHeaderDelegate>
{
    DMChannelManager *networkManager;
    AppDelegate *appDelegate;
    BaseTableView *fmTableView;
    NSArray *dataSource;
    NSFetchedResultsController *fectchedController;
    DMFMTableViewCell *lastSelected;//记录上一次播放的音乐频道
    NSIndexPath *lastSelectedIndex;//记录上一次播放的音乐频道Index
    DMMusicPlayerController *playController;//播放控制器
}
@end
static NSString *reuseCell = @"FMChannelCell";

@implementation DMFMChannelController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    [self commonInit];
}
-(void)viewWillAppear:(BOOL)animated
{
    [fmTableView reloadData];
    [super viewWillAppear:animated];
}
-(void)commonInit
{
    //在此处获取频道列表，为加载数据做准备
    [self getChannelInfo];
    networkManager = [[ DMChannelManager alloc] init];
    [networkManager setDelegate:self];
    appDelegate = [UIApplication sharedApplication].delegate;
    [fmTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getChannelInfo)];
    [fmTableView.legendHeader beginRefreshing];

}
-(void)getChannelInfo
{
    //推荐兆赫

    //查询数据，用户是否登录
    NSArray *users = [AccountInfo MR_findAll];
    if (users.count <= 0)
    {
        [networkManager getChannel:1 withURLWithString:@"http://douban.fm/j/explore/get_recommend_chl"];
    }
    else
    {
        AccountInfo *user = [users firstObject];

        if (user.cookies == nil)
        {
            [networkManager getChannel:1 withURLWithString:@"http://douban.fm/j/explore/get_recommend_chl"];
        }
        else{
            [networkManager getChannel:1 withURLWithString:
             [NSString stringWithFormat:@"http://douban.fm/j/explore/get_login_chls?uk=%@",user.userId]];
        }
    }
    //上升最快的兆赫
    [networkManager getChannel:2 withURLWithString:@"http://douban.fm/j/explore/up_trending_channels"];
    //热门兆赫
    [networkManager getChannel:3 withURLWithString:@"http://douban.fm/j/explore/hot_channels"];
    [fmTableView reloadData];
}
-(void)setUpView
{
    [self setTitle:@"豆瓣FM"];
    //添加右边item
    UIButton *rightbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [rightbtn setBackgroundImage:[UIImage imageNamed:@"Nav_play.png"] forState:UIControlStateNormal];
    [rightbtn setBackgroundImage:[UIImage imageNamed: @"Nav_play.png"] forState:UIControlStateHighlighted];
    [rightbtn addTarget:self action:@selector(goToNowPlaying) forControlEvents:UIControlEventTouchUpInside];
    [rightbtn setFrame:CGRectMake(0, 0, 32.0f, 32.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:rightbtn];
    self.navigationItem.rightBarButtonItem=backitem;
    [self.view setBackgroundColor:DMColor(250,250,248,1.0f)];
    CGRect frame = (CGRect){{0,0},{self.view.bounds.size.width,self.view.bounds.size.height -kTabbarHeight}};
    fmTableView = [[BaseTableView alloc] initWithFrame:frame
                                                 style:UITableViewStylePlain];

    [fmTableView setDataSource:self];
    [fmTableView setDelegate:self];
    [fmTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 5.0f, 0)];
    [self.view addSubview: fmTableView];

}
#pragma mark --actions
-(void)goToNowPlaying
{
    if (playController == nil)
    {
		//不允许进入空播放
    }
    else
    {
        [self.navigationController pushViewController:playController animated:YES];
    }
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [fectchedController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.

    return [[[fectchedController sections] objectAtIndex:section] numberOfObjects];
}


- (DMFMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DMFMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (cell == nil)
    {
        cell = [[DMFMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseCell];
    }
    FMChannel *channel = [fectchedController objectAtIndexPath:indexPath];
    BOOL isShowRedHot = NO;
    if ([channel.channelName isEqualToString:@"我的红心"])
    {
        isShowRedHot = YES;
    }
    [cell setCellContent:channel.channelName isDouBanRed:isShowRedHot];
    //根据上次选中的index 进行判断
    if (lastSelectedIndex == indexPath)
    {
        [cell isNowPlayChannel:YES];
    }
    else
    {
        [cell isNowPlayChannel:NO];
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取播放列表并进入播放界面
    DMFMTableViewCell *cell =(DMFMTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ( lastSelected != nil)
    {
        //1.取消上一次的播放选中
        [lastSelected isNowPlayChannel:NO];
    }
    //2.last = index；
    lastSelected = cell;
    lastSelectedIndex = indexPath;
    [cell isNowPlayChannel:YES];
    DMMusicPlayerController * musicPlayer = [[DMMusicPlayerController alloc] init];
    FMChannel *channel = [fectchedController objectAtIndexPath:indexPath];
    [musicPlayer setPlayChannelTitle:channel.channelName];
    [musicPlayer setPlayChannelId:channel.channelID];
    playController = musicPlayer;
    [self.navigationController pushViewController:musicPlayer animated:YES];
    //设置当前播放频道为选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(DMFMUserHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DMFMUserHeaderView *view = [[DMFMUserHeaderView alloc]
                                initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [view setBackgroundColor:DMColor(230, 230, 230, 0.8f)];
    //设置head 数据
   __block NSString *title = appDelegate.channels[section][@"section"];
    BOOL isNeedGetInterface = NO;//header用户交互
    //查询数据库
    NSArray *accounts = [AccountInfo MR_findAllInContext:[NSManagedObjectContext MR_context]];

    if (accounts.count > 0 && section == 0)
    {
        AccountInfo *userInfo = [accounts firstObject];
        title = userInfo.name;
        //用户已经登录
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@.jpg",
                              UserAccountIconUrl,userInfo.userId];
        [UIImage getRemoteImageWithUrl:imageUrl Suceess:^(UIImage *image)
        {

               UIImage * theImage = image;
            [view setHeadViewContent:title Image:theImage];
        } faild:^(NSError *error)
        {
			UIImage *theImage = [UIImage imageNamed:@"user_normal.jpg"];
            [view setHeadViewContent:title Image:theImage];
        }];
    }
    else
    {	   UIImage *imagefile = nil;
        if (section == 0)
        {
            imagefile = [UIImage imageNamed:@"user_normal.jpg"];
            isNeedGetInterface = YES;
        }

        [view setHeadViewContent:title Image:imagefile];
    }
    [view setDelegate:self];
    [view setUserInteractionEnabled:isNeedGetInterface];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1.0f;
}
#pragma mark --delegate
-(void)shouldReloadData:(BOOL)isReadFromLocal
{
    //重新查询数据库
    fectchedController = [FMChannel MR_fetchAllGroupedBy:@"section" withPredicate:nil
                                                sortedBy:@"section" ascending:YES];
    [fectchedController setDelegate:self];
    if (isReadFromLocal)
    {
        [fmTableView reloadData];
    }
    //停止刷新
    [fmTableView.legendHeader endRefreshing];

}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [fmTableView reloadData];
}
//headerViewDelegate ---用户登录
-(void)actionForLogin
{
    DMLoginViewController *login = [[DMLoginViewController alloc] init];
    [login setModalPresentationStyle:UIModalPresentationFullScreen];
    [self presentViewController:login animated:YES completion:nil];
}
@end
