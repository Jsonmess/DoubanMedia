//
//  MainController.m
//
//  Created by Json on 14-5-30.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import "MainController.h"
#import "Tabbar_view.h"
#import "JSfmViewController.h"
#import "Com_navigationController.h"
#import "JSSetingViewController.h"
#import "JSMusicController.h"
#import "DoubanMini-swift.h"
#define KChildControllerFrame
@interface MainController ()<UINavigationControllerDelegate>

@property(strong,nonatomic) Tabbar_view *_dock;
@property(assign,nonatomic) NSInteger Button_Tag_old;
@property(assign,nonatomic) NSInteger Button_Tag;

@end

@implementation MainController



- (void)viewDidLoad
{
    [self initChildController];
    [self AddTabbar];
    [super viewDidLoad];

}
/**
 *  添加Dock
 */
-(void)AddTabbar
{
   
    self._dock=[Tabbar_view ShareTabbar_view];
   [self._dock setFrame:CGRectMake(0, self.view.frame.size.height-Ktabbar_height, self.view.frame.size.width, Ktabbar_height)];
    
#pragma mark---   注意代理最好在初始化设置该代理对象初始化后就设置
    //设置代理
    [self._dock setDelegate:self];
    
    
    //设置选项卡中按钮数目
    self._dock._buttons_count=kbutton_count;
    //设置选项卡背景颜色
    [self._dock setBackground_image:@"TabBar_bg.png"];
    [self.view addSubview:self._dock];
    //往选项卡中添加按钮 抽象出添加按钮的(标题、nomal图片、selected图片)便于重用
    [self._dock AddButtonWith:@"豆瓣FM" NomalImage:@"home_my.png" SelectedImage:@"home_my.png"];
    
    [self._dock AddButtonWith:@"豆瓣音乐" NomalImage:@"morePage_musicRecognizer.png" SelectedImage:@"morePage_musicRecognizer.png"];
    [self._dock AddButtonWith:@"豆瓣电影" NomalImage:@"home_film.png" SelectedImage:@"home_film.png" ];
    [self._dock AddButtonWith:@"应用设置" NomalImage:@"morePage_setting.png" SelectedImage:@"morePage_setting.png"];
}
/**
 *  初始化子控制器
 */
-(void)initChildController
{
    //豆瓣FM
     JSfmViewController*DBfm=[[JSfmViewController alloc]init];
    Com_navigationController *navf=[[Com_navigationController alloc]initWithRootViewController:DBfm];
    
    [self addChildViewController:navf];
    //豆瓣音乐
    JSMusicController *DBmusic=[[JSMusicController alloc]init];
    Com_navigationController *navm=[[Com_navigationController alloc]initWithRootViewController:DBmusic];
    //用于隐藏dock后的视图调整
    [navm setDelegate:self];
    [self addChildViewController:navm];
    
    //豆瓣电影
    JSMovieInfoController *DBmovie=[[JSMovieInfoController alloc]init];
    Com_navigationController *navmo=[[Com_navigationController alloc]initWithRootViewController:DBmovie];
    //用于隐藏dock后的视图调整
    [navmo setDelegate:self];
    [self addChildViewController:navmo];
    
    //应用设置
    JSSetingViewController *Setting=[[JSSetingViewController alloc]init];
    Com_navigationController *navse=[[Com_navigationController alloc]initWithRootViewController:Setting];
    //用于隐藏dock后的视图调整
    [navse setDelegate:self];
    [self addChildViewController:navse];
   }
#pragma mark---实现选项卡到主视图控制器的协议方法
-(void)SendButtonAction:(NSInteger)oldtag To:(NSInteger)newtag
{
    [self RunButionAction:oldtag To:newtag];

}
/**
 * 添加模块视图
 */
#pragma mark---根据按钮选择，实现其方法

-(void)RunButionAction:(NSInteger)oldtag To:(NSInteger)newtag
{
    if (newtag<0||newtag>kbutton_count)return;
    
    //1.取出将要添加到主视图控制器子视图
    UIViewController *current_c=self.childViewControllers[newtag];
    //1.2设置该子控制器的frame
    CGFloat weidth=self.view.frame.size.width;
 
    CGFloat height=self.view.frame.size.height-Ktabbar_height;
    [current_c.view setFrame:CGRectMake(0, 0, weidth, height)];

    //2.取出已经存在的子视图
    UIViewController *old_c=self.childViewControllers[oldtag];
    
    //3.将主视图控制器中子控制器移除
    [old_c.view removeFromSuperview];
    
    
    //4.添加新的子控制器主视图控制器
    [self.view addSubview:current_c.view];
    
}
//导航控制器代理----用于将导航控制器的视图调整为需要的frame
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    UIViewController *topController=navigationController.viewControllers[0];
    if (topController!=viewController) {
        CGRect frame=navigationController.view.frame;
        frame.size.height=[UIScreen mainScreen].applicationFrame.size.height+20.0f;
        
        navigationController .view.frame=frame;
        
    }else
    {
        CGRect frame=navigationController.view.frame;
        frame.size.height=[UIScreen mainScreen].applicationFrame.size.height-20;
        navigationController .view.frame=frame;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
