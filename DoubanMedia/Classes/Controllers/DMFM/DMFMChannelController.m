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
@interface DMFMChannelController ()<UITableViewDataSource,UITableViewDelegate>
{
    DMChannelManager *networkManager;

}
@end
static NSString *reuseCell = @"FMChannelCell";

@implementation DMFMChannelController

- (void)viewDidLoad
{
    [self commonInit];
    [super viewDidLoad];
    [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //在此处获取频道列表，为加载数据做准备
    [self getChannelInfo];

}
-(void)commonInit
{
    networkManager = [[ DMChannelManager alloc] init];
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
}
-(void)setUpView
{
    [self setTitle:@"豆瓣FM"];
    CGRect frame = (CGRect){{0,0},{self.view.bounds.size.width,self.view.bounds.size.height -kTabbarHeight}};
    BaseTableView *fmTableView = [[BaseTableView alloc] initWithFrame:frame
                                                    style:UITableViewStylePlain];

    [fmTableView setDataSource:self];
    [fmTableView setDelegate:self];
    [fmTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 5.0f, 0)];
	[self.view addSubview: fmTableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 5;
}


- (DMFMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DMFMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (cell == nil)
    {
        cell = [[DMFMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseCell];
    }

    [cell setCellContent:@"频道兆赫" isCurrentPlay:YES isDouBanRed:YES];
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
    [view setHeadViewContent:@"测试" Image:[UIImage imageNamed:@"user_normal.jpg"]];

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
@end
