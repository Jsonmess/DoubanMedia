//
//  RootViewController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/22.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//
#import "RootViewController.h"
#import "DMGlobal.h"
#import "RootTabView.h"
#import "PureLayout.h"
#import "Com_navigationController.h"
#import "DMFMChannelController.h"
#import "TabViewManager.h"
#define KitemCount 4  //Tabbar 选项卡数目
@interface RootViewController  ()<TabbarDataSource,TabbarDelegate>
{
    NSMutableArray *subViewControllers;//子控制器组
    RootTabView *tabView;
}
@end

@implementation RootViewController

- (void)viewDidLoad
{

    [super viewDidLoad];
    subViewControllers = [NSMutableArray array];
    [self setUpView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initSubViewControllers
{
    [subViewControllers removeAllObjects];
    //豆瓣FM
    DMFMChannelController *doubanFmController = [[DMFMChannelController alloc]init];
    Com_navigationController *navFMController = [[Com_navigationController alloc]
                                               initWithRootViewController:doubanFmController];
    [subViewControllers addObject:navFMController];
    //豆瓣音乐
     UIViewController *doubanMusicController = [[UIViewController alloc]init];
    Com_navigationController *navMusicController = [[Com_navigationController alloc]
                                               initWithRootViewController:doubanMusicController];
    [doubanMusicController.view setBackgroundColor:[UIColor greenColor]];
    [subViewControllers addObject:navMusicController];
    //豆瓣电影
     UIViewController *doubanFilmController = [[UIViewController alloc]init];
    Com_navigationController *navFilmController = [[Com_navigationController alloc]
                                                    initWithRootViewController:doubanFilmController];
    [doubanFilmController.view setBackgroundColor:[UIColor blueColor]];
    [subViewControllers addObject:navFilmController];
	//应用设置
     UIViewController *doubanSettingController = [[UIViewController alloc]init];
    Com_navigationController *navSettingController = [[Com_navigationController alloc]
                                                   initWithRootViewController:doubanSettingController];

    [doubanSettingController.view setBackgroundColor:[UIColor yellowColor]];
    [subViewControllers addObject:navSettingController];
}
//添加视图和Tabbar
-(void)setUpView
{
	//tabbar
    tabView = [[RootTabView alloc]initWithFrame:CGRectZero];
    //将tabView 保存到一个单例中，用于隐藏和显示
    [[TabViewManager sharedTabViewManager] setTabView:tabView];
    [tabView setTabDataSource:self];
    [tabView setTabDelegate:self];
    [self initSubViewControllers];
    [self.view addSubview:tabView];
    [tabView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                      excludingEdge:ALEdgeTop];
    [tabView autoSetDimension:ALDimensionHeight toSize:kTabbarHeight];
    //默认添加豆瓣fm
    UIViewController *fm = [subViewControllers firstObject];
    [self.view addSubview:fm.view];
     [self.view bringSubviewToFront:tabView];
    [self setContainsWith:fm];
}
//切换模块
-(void)RunButionAction:(NSInteger)oldtag To:(NSInteger)newtag
{
    if (newtag < 0|| newtag > KitemCount)return;

    //1.取出将要添加到主视图控制器子视图
    UIViewController *current_c=subViewControllers[newtag];

    //2.取出已经存在的子视图
    UIViewController *old_c=subViewControllers[oldtag];

    //3.将主视图控制器中子控制器移除
    [old_c.view removeFromSuperview];


    //4.添加新的子控制器主视图控制器
    [self.view addSubview:current_c.view];
    [self.view bringSubviewToFront:tabView];
    [self setContainsWith:current_c];

    
}
//设置约束
-(void)setContainsWith:(UIViewController *)controller
{
    [controller.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.view setNeedsLayout];
}
#pragma mark -----Tabbar代理
-(NSInteger)numberOfTabItemsInTabbarView
{
    return KitemCount;
}
-(NSArray *)theSourceOfItemNormalIcons
{
    return @[@"home_fm.png",@"home_film.png",
             @"home_mm.png",@"morePage_setting.png"];
}
-(NSArray *)theSourceOfItemTitles
{
    return @[@"豆瓣FM",@"豆瓣电影",@"豆瓣妹纸",@"应用设置"];
}
-(NSArray*)theSourceOfItemSelectedIcons
{
    return @[@"home_fm.png",@"home_film.png",@"home_mm.png",@"morePage_setting.png"];
}
-(UIImage *)theSourceOfTabbarBackGroundImage
{
    return [UIImage imageNamed:@"TabBar_bg.png"];
}

-(void)rootTabView:(RootTabView *)tabbarView lastSelectedItem:(NSInteger)lindex didSelectedItem:(NSInteger)nindex
{
    [self RunButionAction:lindex To:nindex];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

