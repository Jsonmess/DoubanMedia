//
//  DMSettingController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMSettingController.h"
#import "BaseTableView.h"
#import "BaseTableViewCell.h"
#import "DMUserInfoCell.h"
#import "DMDeviceManager.h"
#import "DMLoginManager.h"
#import "MBProgressHUD+DMProgressHUD.h"
#import "DMLoginViewController.h"
#import "DMSettingCell.h"
@interface DMSettingController ()<UITableViewDelegate,UITableViewDataSource,
						DMUserInfoCellDelegate,UIActionSheetDelegate,DMLoginManagerDelegate>
{
    BaseTableView *baseTableView;
    DMLoginManager *loginManager;
    DMUserInfoCell *userCell;//单独的用户Cell
    NSArray *sources;//资源
    NSArray *headSources;//分组标题
}
@end

@implementation DMSettingController

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        loginManager = [[DMLoginManager alloc] init];
        loginManager.loginDelegate = self;
        userCell = [[DMUserInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:nil];
                [userCell setDelegate:self];

        sources = @[@[@"二维码扫描",@"生成二维码"],@[@"只在Wifi下联网",@"同步本地歌曲",@"离线管理"],
                    @[@"清除FM缓存",@"清除图片缓存"],@[@"意见反馈",@"关于作者"]];
        headSources = @[@"工具",@"基本设置",@"数据清理",@"更多"];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    shouldHiddenStatusBar(NO);
}
-(void)setUpView
{
    [self setTitle:@"应用设置"];
    CGFloat btSpacing = 10.0f;
    CGFloat btWidth = self.view.bounds.size.width -btSpacing*2;
    baseTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(btSpacing, 0, btWidth,
                                                                   self.view.bounds.size.height-kTabbarHeight)
                                                  style:UITableViewStyleGrouped];
    [self.view addSubview:baseTableView];
    [self.view setBackgroundColor:baseTableView.backgroundColor];
    [baseTableView setContentInset:UIEdgeInsetsMake(5.0f, 0, 0, 0)];
    [baseTableView setShowsVerticalScrollIndicator:NO];
    [baseTableView setDelegate:self];
    [baseTableView setDataSource:self];
    //添加监听--用于FM模块登录账户的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess:)
                                                 name:@"LoginSucess"
                                               object:nil];

}

#pragma mark --actions

-(void)loginSuccess:(NSNotification *)notification
{
    [userCell checkLoginInfo];
}

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        NSArray *array = sources[section-1];
   		 return array.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    //设置基本内容
    BOOL showSwitch = false;
    BOOL showArrow = YES;
    NSString *subTitle = @"";

    if (indexPath.section == 0)
    {
        cell = userCell;
    }else
    {
        static NSString *reUseStr = @"settingCell";
        DMSettingCell *settingCell;
        settingCell = (DMSettingCell *)[tableView dequeueReusableCellWithIdentifier:reUseStr];
        if (settingCell == nil)
        {
            settingCell = [[DMSettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseStr];
        }
		//这里就没必要重新去创建字典，定义每一行 内容显示属性
        if (indexPath.section == 2 && indexPath.row == 0)
        {
            showSwitch = YES;
            showArrow = NO;
        }
        if (indexPath.section == 3)
        {
            showSwitch = NO;
            showArrow = NO;
            subTitle = @"20m";
        }
        [settingCell setContentsWithTitle:sources[indexPath.section-1][indexPath.row]
                                                                      subTitle:subTitle
                                                                      isShouldShowSwitch:showSwitch
                                                                      haveArrows:showArrow];
        cell = settingCell;
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    if (section > 0)
    {
        [label setText: [NSString stringWithFormat:@"      %@", headSources[section-1]]];
    }
    [label setFont:DMFont(12.0f)];
    [label setTextColor:DMColor(120, 122, 122, 1.0f)];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat theHeight = 0.0f;
	if([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        if (indexPath.section == 0)
        {
            theHeight = 290.0f;
        }
        else
            theHeight = 70.0f;
    }
    else
    {
        if (indexPath.section == 0)
        {
            theHeight = 180.0f;
        }
        else
            theHeight = 50.0f;

    }
    return theHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    else
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //设置底部视图
    if (section == 3)
    {
         return 10.f;
    }
    else
        return 20.0f;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

#pragma mark ----UserInfoCellDelegate
//登录状态
-(void)setRegisterStatus:(BOOL)isLogin
{
    if (!isLogin)
    {
		//直接跳转到登录
        DMLoginViewController *controller = [[DMLoginViewController alloc] init];
        [self  presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        //提示是否注销
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"您确定要注销么？\n注销会清除您的离线歌曲等信息。"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:@"注销登录"
                                                  otherButtonTitles: nil];
        [sheet showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //开始注销
        [loginManager logout];
    }
}

-(void)logoutState:(kLogoutState)state
{
    NSString *text = @" ";
    switch (state)
    {
        case eLogoutFaild:
		text = @"注销失败，请重试";
            break;
        case eLogoutSuccess:
            text = @"您已注销";
            //更新显示状态
            break;
        default:
            break;
    }

	[MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:text Font:DMFont(13.0f)
                                          Margin:12.0f
                                         offsetY:self.view.bounds.size.height*0.06f
                                        showTime:1.5f];
    [userCell checkLoginInfo];
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
