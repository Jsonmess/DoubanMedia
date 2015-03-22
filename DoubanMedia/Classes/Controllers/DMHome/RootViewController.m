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
#define KitemCount 4  //Tabbar 选项卡数目
@interface RootViewController  ()<TabbarDataSource,TabbarDelegate>
{
    NSMutableArray *subViewControllers;//子控制器组
}
@end

@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    subViewControllers = [NSMutableArray array];

    RootTabView *tab =[[RootTabView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)];
    [tab setTabDataSource:self];
    [tab setTabDelegate:self];
    [self.view addSubview:tab];
    [self.view setBackgroundColor:[UIColor redColor]];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)initSubViewController
{
    //豆瓣FM
    UIViewController *doubanFmController = [[UIViewController alloc]init];
    //豆瓣音乐
     UIViewController *doubanMusicController = [[UIViewController alloc]init];
    //豆瓣电影
     UIViewController *doubanFilmController = [[UIViewController alloc]init];
	//应用设置
     UIViewController *doubanSettingController = [[UIViewController alloc]init];
}
-(void)RunButionAction:(NSInteger)oldtag To:(NSInteger)newtag
{
    if (newtag < 0|| newtag > KitemCount)return;

    //1.取出将要添加到主视图控制器子视图
    UIViewController *current_c=self.childViewControllers[newtag];
    //1.2设置该子控制器的frame
//    CGFloat weidth=self.view.frame.size.width;
//
//    CGFloat height=self.view.frame.size.height-Ktabbar_height;
//    [current_c.view setFrame:CGRectMake(0, 0, weidth, height)];

    //2.取出已经存在的子视图
    UIViewController *old_c=self.childViewControllers[oldtag];

    //3.将主视图控制器中子控制器移除
    [old_c.view removeFromSuperview];


    //4.添加新的子控制器主视图控制器
    [self.view addSubview:current_c.view];
    
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
    NSLog(@"之前选中了---%d  选中了index ----%d",lindex,nindex);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

