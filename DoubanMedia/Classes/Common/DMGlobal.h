//
//  DMGlobal.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#ifndef DoubanMedia_DMGlobal_h
#define DoubanMedia_DMGlobal_h
#define ScreenBounds  [UIScreen mainScreen].bounds
#define DMFont(fontSize) [UIFont systemFontOfSize:(fontSize)]
#define DMColor(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define kTabbarHeight 48.0f //Tabbar 高度
#define DMBoldFont(fontSize) [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize)]
//状态栏
#define shouldHiddenStatusBar(hidden) [[UIApplication sharedApplication] setStatusBarHidden:(hidden)]
#define setStatusBarStyle(style) [[UIApplication sharedApplication] setStatusBarStyle:(style)]
//用户头像BaseUrl
#define UserAccountIconUrl @"http://img3.douban.com/icon/up"
#define DoubanApiBaseUrl @"http://api.douban.com"
//豆瓣电影BaseUrl
#define DoubanFilmBaseUrl @"http://movie.douban.com"
//网页用户登录地址
#define DoubanWebLogin @"http://www.douban.com/accounts/login"
#endif