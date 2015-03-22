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
@interface RootViewController  ()<TabbarDataSource,TabbarDelegate>

@end

@implementation RootViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    RootTabView *tab =[[RootTabView alloc]initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 44)];
    [tab setTabDataSource:self];
    [tab setTabDelegate:self];
    [self.view addSubview:tab];
    [self.view setBackgroundColor:[UIColor redColor]];
    // Do any additional setup after loading the view, typically from a nib.
}
-(NSInteger)numberOfTabItemsInTabbarView
{
    return 4;
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

-(void)rootTabView:(RootTabView *)tabbarView didSelectedItem:(NSInteger)index
{
    NSLog(@"选中了index ----%d",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

