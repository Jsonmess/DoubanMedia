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
@interface DMFMChannelController ()<UITableViewDataSource,UITableViewDelegate,DMChannelDelegate,NSFetchedResultsControllerDelegate>
{
    DMChannelManager *networkManager;
        AppDelegate *appDelegate;
    BaseTableView *fmTableView;
    NSArray *dataSource;
    NSFetchedResultsController *fectchedController;
}
@end
static NSString *reuseCell = @"FMChannelCell";

@implementation DMFMChannelController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self commonInit];
    [self setUpView];
    //在此处获取频道列表，为加载数据做准备
    [self getChannelInfo];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)commonInit
{
    //在此处获取频道列表，为加载数据做准备
    [self getChannelInfo];
    networkManager = [[ DMChannelManager alloc] init];
    [networkManager setDelegate:self];
    appDelegate = [UIApplication sharedApplication].delegate;


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
    CGRect frame = (CGRect){{0,0},{self.view.bounds.size.width,self.view.bounds.size.height -kTabbarHeight}};
   fmTableView = [[BaseTableView alloc] initWithFrame:frame
                                                    style:UITableViewStylePlain];

    [fmTableView setDataSource:self];
    [fmTableView setDelegate:self];
    [fmTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 5.0f, 0)];
	[self.view addSubview: fmTableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [fectchedController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

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
    if (indexPath.section == 0 && indexPath.row == 1)
    {
        [cell setCellContent: channel.channelName isDouBanRed:YES];
    }
    else
    {
        [cell setCellContent:channel.channelName isDouBanRed:NO];
    }



    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(DMFMUserHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    DMFMUserHeaderView *view = [[DMFMUserHeaderView alloc]
                                initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    [view setBackgroundColor:DMColor(230, 230, 230, 0.8f)];
    //设置head 数据
    NSString *title = appDelegate.channels[section][@"section"];
    NSString *imagefile;
    if (section == 0)
    {
		imagefile = @"user_normal.jpg";
    }
    [view setHeadViewContent:title Image:[UIImage imageNamed:imagefile]];

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
    fectchedController = [FMChannel MR_fetchAllGroupedBy:@"section" withPredicate:nil sortedBy:@"section" ascending:YES];
    [fectchedController setDelegate:self];
    if (isReadFromLocal)
    {
        [fmTableView reloadData];
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [fmTableView reloadData];
}
@end
