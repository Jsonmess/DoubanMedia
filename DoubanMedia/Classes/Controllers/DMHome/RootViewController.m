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
#define KitemCount 4  //Tabbar 选项卡数目
#define kTabbarHeight 44.0f //Tabbar 高度
@interface RootViewController  ()<TabbarDataSource,TabbarDelegate>
{
    NSMutableArray *subViewControllers;//子控制器组
    RootTabView *tabView;
}
@end

@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    subViewControllers = [NSMutableArray array];
    [self setUpView];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initSubViewControllers
{
    [subViewControllers removeAllObjects];
    //豆瓣FM
    UIViewController *doubanFmController = [[UIViewController alloc]init];
    Com_navigationController *navFMController = [[Com_navigationController alloc]
                                               initWithRootViewController:doubanFmController];
    [doubanFmController.view setBackgroundColor:[UIColor redColor]];
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
    [self setContainsWith:fm];
}

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
    [self setContainsWith:current_c];

    
}
-(void)setContainsWith:(UIViewController *)controller
{
      [controller.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                excludingEdge:ALEdgeBottom];
        [controller.view autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:tabView];
    [self.view setNeedsLayout];
}
#pragma mark -----Tabbar代理
-(NSInteger)numberOfTabItemsInTabbarView
{
    return KitemCount;
}

-(NSArray *)theSourceOfItemNormalIcons
{
    return @[@"home_my.png",@"morePage_musicRecognizer.png",
             @"home_film.png",@"morePage_setting.png"];
}
-(NSArray *)theSourceOfItemTitles
{
    return @[@"豆瓣FM",@"豆瓣音乐",@"豆瓣电影",@"应用设置"];
}
-(NSArray*)theSourceOfItemSelectedIcons
{
    return @[@"home_my.png",@"morePage_musicRecognizer.png",
             @"home_film.png",@"morePage_setting.png"];
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

