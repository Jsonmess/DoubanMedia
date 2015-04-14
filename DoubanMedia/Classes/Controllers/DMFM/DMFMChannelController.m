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
#import  <UIImageView+WebCache.h>
#import <MJRefresh.h>
#import "MBProgressHUD+DMProgressHUD.h"
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
    MBProgressHUD *loadChannelInfo;
    NSMutableDictionary *userInfo;//临时记录用户信息
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
    //检查用户信息
    userInfo = [self checkUserInfo];
    //在此处获取频道列表，为加载数据做准备
    [self getChannelInfo];
    networkManager = [[ DMChannelManager alloc] init];
    [networkManager setDelegate:self];
    appDelegate = [UIApplication sharedApplication].delegate;
    [fmTableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(getChannelInfo)];
    [fmTableView.legendHeader beginRefreshing];
    loadChannelInfo = [MBProgressHUD createProgressOnlyWithView:self.view ShouldRemoveOnHide:NO];

}
-(void)getChannelInfo
{

    [loadChannelInfo show:YES];
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
   // [fmTableView reloadData];
}
-(NSMutableDictionary *)checkUserInfo
{
	 NSArray *accounts = [AccountInfo MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
    AccountInfo *user = [accounts firstObject];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:user.userId forKey:@"userID"];
    [dic setValue:user.name forKey:@"userName"];
    return dic;
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
		//不允许进入空播放---淡出提示
        [MBProgressHUD showTextOnlyIndicatorWithView:self.view
                             Text:@"您还没挑选您要听的频道噢" Font:DMFont(13.0f)
                           Margin:10.0f  showTime:1.8f];
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
    static NSString *reuseHeaderView = @"HeaderView";
     DMFMUserHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseHeaderView];
    if (view == nil)
    {
    				view = [[DMFMUserHeaderView alloc]
                                    initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    }

    [view setBackgroundColor:DMColor(230, 230, 230, 0.8f)];
    //设置head 数据
    NSString *title = appDelegate.channels[section][@"section"];
    BOOL isNeedGetInterface = NO;//header用户交互
		UIImage *imagefile = [UIImage imageNamed:@"user_normal.jpg"];
    if (userInfo.count > 0 && section == 0)
    {
        title = [userInfo valueForKey:@"userName"];
        //用户已经登录
        NSString *imageUrl = [NSString stringWithFormat:@"%@%@.jpg",
                              UserAccountIconUrl,[userInfo valueForKey:@"userID"]];
        [[view getUserIconView] sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                                  placeholderImage:imagefile
                                           options:SDWebImageHighPriority];
        [[view getUserNameLabel] setText:title];
    }
    else
    {
        if (section == 0)
        {
            isNeedGetInterface = YES;
            [view setHeadViewContent:title Image:imagefile];
        }
        else
        {
            [view setHeadViewContent:title Image:nil];
        }
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
    [loadChannelInfo hide:YES];
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
