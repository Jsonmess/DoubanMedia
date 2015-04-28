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
//颜色
#define DMColor(r,g,b,a) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:a]
#define DMCOLOR_WITH_HEX(rgbValue,a) DMColor(\
(float)((rgbValue & 0xFF0000) >> 16),(float)((rgbValue & 0xFF00) >> 8),(float)(rgbValue & 0xFF),a)
//按钮状态
#define DMUIControlStateAll UIControlStateNormal & UIControlStateSelected & UIControlStateHighlighted
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
//网页用户登录地址---暂时屏蔽这功能
#define DoubanWebLogin @"http"//@"http://www.douban.com/accounts/login"
//分享
#define weiChatId @"wx9c24150848b0f85f"
#define tencentId @"1104495079"
//微信、QQ应用地址
#define WEIXINAPPSTROE_URL  @"http://itunes.apple.com/cn/app/wei-xin/id414478124?mt=8"
#define QQAPPSTORE_URL      @"http://itunes.apple.com/cn/app/qq-2012/id444934666?mt=8"
#endif