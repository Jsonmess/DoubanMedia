//
//  Com_navigationController.m
//  sinaweibo
//
//  Created by Json on 14-8-23.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import "Com_navigationController.h"

@interface Com_navigationController ()

@end

@implementation Com_navigationController

- (void)viewDidLoad
{
    //修正版本引起的导航栏显示不正常问题

    //设置导航栏按钮属性字典
    NSDictionary *dic=@{
                        UITextAttributeTextColor:[UIColor darkGrayColor],
                        UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]
                        };
    //1.设置全局导航栏(appearance能将所有导航栏状态对象返回)--控制了所有导航栏的属性
    UINavigationBar *bar=[UINavigationBar appearance];

   
    
    [bar setTitleTextAttributes:@{
                                  UITextAttributeTextColor:[UIColor blackColor],
                                  UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetZero]
                                  }];
    //2.设置uibarbuttonitem
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    
    [item setTitleTextAttributes:dic forState:UIControlStateNormal];
    [item setTitleTextAttributes:dic forState:UIControlStateHighlighted];
    //3.设置状态栏属性，改为默认
    //设置为黑色
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleBlackOpaque ;
    
    [super viewDidLoad];
    
}


@end
