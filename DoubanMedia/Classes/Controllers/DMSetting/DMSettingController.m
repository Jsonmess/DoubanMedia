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
#import "DMZBarReaderController.h"
#import "DMCreateQRCodeController.h"
#import "JSAdviceController.h"
#import "DMAboutMeController.h"
#import "DMFileTool.h"
@interface DMSettingController ()<UITableViewDelegate,UITableViewDataSource,
                                DMUserInfoCellDelegate,UIActionSheetDelegate,
                                    DMLoginManagerDelegate,UIAlertViewDelegate>
{
    BaseTableView *baseTableView;
    DMLoginManager *loginManager;
    DMUserInfoCell *userCell;//单独的用户Cell
    NSArray *sources;//资源
    NSArray *headSources;//分组标题
    NSMutableArray *fileSizes;//图片+播放缓存数组
    NSInteger theIndex;//用于记录清理缓存标签
    /**文件路径**/
    NSString *tmpPath;
    NSString *cachesPath;
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
        //@[@"只在Wifi下联网",@"同步本地歌曲",@"离线管理"]----该部分功能暂时不做
        sources = @[@[@"二维码扫描",@"生成二维码"],@[@"清除FM缓存",@"清除图片缓存",@"恢复默认设置"],
                        @[@"意见反馈",@"关于作者"]];
        //@"基本设置"--暂时不做
        headSources = @[@"工具",@"数据清理",@"更多"];
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
    [self getFileSize];
    [MobClick beginLogPageView:@"应用设置页面"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"应用设置页面"];
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
//获取图片+音乐缓存大小
-(void)getFileSize
{
    fileSizes = [NSMutableArray arrayWithObjects:@"",@"",@" ", nil];
    tmpPath = NSTemporaryDirectory();
    cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    DMFileTool *fileTool = [[DMFileTool alloc] init];
    //tmp大小
    [fileTool caculateFileSizeWithFilePath:tmpPath WithFileBlock:^(NSString *fileSize)
    {
        if (fileSize != nil)
        {
            NSString *tmpSize = [NSString stringWithFormat:@"%@缓存",fileSize];
            [fileSizes replaceObjectAtIndex:0 withObject:tmpSize];
        }
    }];
    //cache大小
    [fileTool caculateFileSizeWithFilePath:cachesPath WithFileBlock:^(NSString *fileSize)
     {
         if (fileSize != nil)
         {
             NSString *cachesSize = [NSString stringWithFormat:@"%@缓存",fileSize];
             [fileSizes replaceObjectAtIndex:1 withObject:cachesSize];
         }
         [baseTableView reloadData];
     }];

}
#pragma mark --actions

-(void)loginSuccess:(NSNotification *)notification
{
    [userCell checkLoginInfo];
}

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
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
		//这里就没必要重新去创建字典，定义每一行 内容显示属性 ---这部分暂时不做
//        if (indexPath.section == 2 && indexPath.row == 0)
//        {
//            showSwitch = YES;
//            showArrow = NO;
//        }
        if (indexPath.section == 2)
        {
            showSwitch = NO;
            showArrow = NO;
            subTitle = fileSizes[indexPath.row];
            if ([subTitle isEqualToString:@""])
            {
                subTitle = @"无缓存";
            }
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
    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
                [self gotoScanQRCode];
                break;
            default:
                 [self createQRCode];
                break;
        }
    }
    else if(indexPath.section == 3)
    {
        switch (indexPath.row)
        {
            case 0:
                [self goToAdvice];
                break;
            default:
                [self aboutMe];
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
                [self cleanFMCache];
                break;
            case 1:
                [self cleanImageCache];
                break;
            default:
                [self resetAppSetting];
                break;
        }
    }

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

#pragma mark ---- actions for sub fuction
//扫一扫
-(void)gotoScanQRCode
{
    //添加提示器---用于等待
    MBProgressHUD *hud = [MBProgressHUD createProgressOnlyWithView:self.view ShouldRemoveOnHide:YES];
    [hud showAnimated:YES whileExecutingBlock:^{
         DMZBarReaderController *zbarController = [[DMZBarReaderController alloc] init];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:zbarController animated:YES];
        });
    } completionBlock:^{
        [hud setHidden:YES];
    }];
}
//生成二维码
-(void)createQRCode
{
    DMCreateQRCodeController *controller = [[DMCreateQRCodeController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
//清除FM缓存
-(void)cleanFMCache
{
    theIndex = 0;
    [MobClick event:@"id_event_cleanFM" label:@"清理FM缓存次数"];
    [self showAlertViewWithTile:@"确定要清理么" message:@"\n应用将会清理本地缓存的音乐数据"];
}
-(void)cleanImageCache
{
    theIndex = 1;
    [MobClick event:@"id_event_cleanImage" label:@"清理图片缓存次数"];
    [self showAlertViewWithTile:@"确定要清理么" message:@"\n应用将会清理本地缓存的图片数据"];
}
//恢复设置
-(void)resetAppSetting
{
    //暂时只做恢复加锁豆瓣妹纸
    theIndex = 2;
    [self showAlertViewWithTile:@"提示" message:@"应用将恢复初始设置"];
    [MobClick event:@"id_event_reset" label:@"重置应用次数"];
}
//意见反馈
-(void)goToAdvice
{
    JSAdviceController *advicedController = [[JSAdviceController alloc]
                                             initWithNibName:@"JSAdviceController" bundle:nil];
    [self.navigationController pushViewController:advicedController animated:YES];
}
//关于作者
-(void)aboutMe
{
    DMAboutMeController *aboutController = [[DMAboutMeController alloc] init];
    [self.navigationController pushViewController:aboutController animated:YES];
}
-(void)showAlertViewWithTile:(NSString *)title message:(NSString *)msg
{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self
                                              cancelButtonTitle:@"取消" otherButtonTitles:@"清理", nil];
    [alert show];
}

//alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    DMFileTool *tool = [[DMFileTool alloc] init];
    if (buttonIndex == 1)
    {
        __block MBProgressHUD *hud;
        switch (theIndex)
        {
            case 0:
            {
                hud = [MBProgressHUD createProgressOnlyWithView:self.view ShouldRemoveOnHide:YES];
                [tool deleteAllFilesWithPath:tmpPath cleanFinished:^{
                    [hud hide:YES];
                    //重新计算文件大小
                    [self getFileSize];
                    [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"FM缓存已清空" Font:DMFont(13.0f)
                                                          Margin:12.0f
                                                         offsetY:0
                                                        showTime:1.0f];
                }];
                break;
            }
            case 1:

            {
                hud = [MBProgressHUD createProgressOnlyWithView:self.view ShouldRemoveOnHide:YES];
                [tool deleteAllFilesWithPath:cachesPath cleanFinished:^{
                    [hud hide:YES];
                    //重新计算文件大小
                    [self getFileSize];
                    [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"图片缓存已清空" Font:DMFont(13.0f)
                                                          Margin:12.0f
                                                         offsetY:0
                                                        showTime:1.0f];
                }];
            }
                break;
                
            default:
                NSLog(@"已恢复设置");
                //暂时写死
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ZhaiNanUser"];
                [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"已恢复设置" Font:DMFont(13.0f)
                                                      Margin:12.0f
                                                     offsetY:0
                                                    showTime:1.f];
                break;
        }

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
