//
//  DMAboutMeController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/10.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMAboutMeController.h"
#import "TabViewManager.h"
@interface DMAboutMeController ()
{
    UIWebView *webView;//用于展示作者信息
}
@end

@implementation DMAboutMeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[TabViewManager sharedTabViewManager].getTabView setHidden:YES];
    [MobClick beginLogPageView:@"关于作者"];
}

-(void)setUpView
{
    self.title=@"作者信息";
    //设置返回按钮
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(BackToSetting) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    [webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, -kTabbarHeight, 0)];
    //加载本地text
    [self loadAuthorInfoTXT];
}
-(void)loadAuthorInfoTXT
{
    NSString *file_path =[[NSBundle mainBundle]pathForResource:@"AboutAuthor.txt" ofType:nil];
    NSString *content=[NSString stringWithContentsOfFile:file_path encoding:NSUTF8StringEncoding error:nil];

    [webView loadHTMLString:content baseURL:nil];
    
}
-(void)BackToSetting
{
    [[TabViewManager sharedTabViewManager].getTabView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [MobClick endLogPageView:@"关于作者"];
}
@end
