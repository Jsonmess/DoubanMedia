//
//  DMLoginManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/25.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kLoginState)
{
    kLoginSuccess = 0,
    kLoginFaild,
    kLoginError
};
typedef NS_ENUM(NSInteger, kLogoutState)
{
     eLogoutSuccess = 0,
     eLogoutFaild,
};
@protocol DMLoginManagerDelegate<NSObject>
//传出验证码图片地址
-(void)setCaptchaImageUrl:(NSString *)url;
@optional
//登录状态
-(void)loginState:(kLoginState)state;
//注销状态
-(void)logoutState:(kLogoutState)state;
@end

@interface DMLoginManager : NSObject
@property(nonatomic)id<DMLoginManagerDelegate>loginDelegate;

//获取登录豆瓣验证码图片
-(void)getCaptchaImageFromDM;
//登录
-(void)LoginwithUsername:(NSString *)username
                Password:(NSString *)password
                 Captcha:(NSString *)captcha
         RememberOnorOff:(NSString *)rememberOnorOff;
//注销操作
-(void)logout;
@end
