//
//  DMLoginManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/25.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMLoginManager.h"
#import <AFNetworking.h>
#import "AccountInfo.h"
@interface DMLoginManager()
{
    AFHTTPRequestOperationManager *OperationManager;
    NSString *captchaID ;//验证码序列
    AccountInfo *userInfo;//用户信息

}
@end
@implementation DMLoginManager
-(instancetype)init
{
    if (self = [super init])
    {
        OperationManager = [AFHTTPRequestOperationManager manager ];
        
    }
    return self;
}
//获取登录验证码
-(void)getCaptchaImageFromDM
{
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *captchaIDURL = @"http://douban.fm/j/new_captcha";
    [OperationManager GET:captchaIDURL parameters:nil success:^(AFHTTPRequestOperation *operation,
                                                                id responseObject)
     {
        NSMutableString *tempCaptchaID = [[NSMutableString alloc]
                                          initWithData:responseObject encoding:NSUTF8StringEncoding];
        [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch
                                            range:NSMakeRange(0, [tempCaptchaID length])];
        captchaID = tempCaptchaID;
        NSString *chatchaURL = [NSString stringWithFormat:@"http://douban.fm/misc/captcha?size=m&id=%@",
                                tempCaptchaID];
        //加载验证码图片
        [self.loginDelegate setCaptchaImageUrl:chatchaURL];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    }];
}

//登录
-(void)LoginwithUsername:(NSString *)username
                Password:(NSString *)password
                 Captcha:(NSString *)captcha
         RememberOnorOff:(NSString *)rememberOnorOff
{
    NSDictionary *loginParameters = @{@"remember": rememberOnorOff,
                                      @"source": @"radio",
                                      @"captcha_solution": captcha,
                                      @"alias": username,
                                      @"form_password":password,
                                      @"captcha_id":captchaID};
    NSString *loginURL = @"http://douban.fm/j/login";
    OperationManager.responseSerializer = [AFJSONResponseSerializer serializer];
    [OperationManager POST:loginURL parameters:loginParameters success:^(AFHTTPRequestOperation *operation,
                                                                         id responseObject)
    {
        NSDictionary *tempLoginInfoDictionary = responseObject;
        //r=0 登陆成功
        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0)
        {
            [self.loginDelegate loginState:eLoginSuccess];
            //保存用户数据到数据库
            [self saveUserInfoToDataBase:tempLoginInfoDictionary];
        }
        else{
			//登录失败
            [self getCaptchaImageFromDM];
            [self.loginDelegate loginState:eLoginFaild];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //网络故障或者未知错误
        [self.loginDelegate loginState:eLoginError];
        [self getCaptchaImageFromDM];
    }];
}
//注销操作
-(void)logout
{
    //查询数据库
 NSArray *users = [AccountInfo MR_findAll];
    if (users.count <= 0 )
    {
        NSLog(@"您还未登陆");
        //跳转到登陆界面
    }
    else
    {
        //执行注销并删除数据
        userInfo = [users firstObject];

    NSDictionary *logoutParameters = @{@"source": @"radio",
                                       @"ck": userInfo.cookies,
                                       @"no_login": @"y"};
    NSString *logoutURL = @"http://douban.fm/partner/logout";
 OperationManager.requestSerializer = [AFJSONRequestSerializer serializer];
    OperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [OperationManager GET:logoutURL parameters:logoutParameters
                  success:^(AFHTTPRequestOperation *operation,id responseObject)
        {
       			 NSLog(@"成功注销 ");
            [self.loginDelegate logoutState:eLogoutSuccess];
            [userInfo MR_deleteEntity];
            [userInfo.managedObjectContext MR_saveToPersistentStoreAndWait];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [self.loginDelegate logoutState:eLogoutFaild];
        NSLog(@"LOGOUT_ERROR:%@",error);
    }];

    }
}

//保存信息到数据库
-(void)saveUserInfoToDataBase:(NSDictionary *)dictionary
{
    userInfo = [AccountInfo MR_createEntity];
    NSString *loginStateCode = [[dictionary valueForKey:@"r"] stringValue];
    userInfo.isNotLogin =loginStateCode;
    NSDictionary *temp =[dictionary valueForKey:@"user_info"];
    userInfo.cookies =[temp valueForKey:@"ck"];
    userInfo.userId =[temp valueForKey:@"id"];
    userInfo.name = [temp valueForKey:@"name"];
    NSDictionary *playRecordDic = [temp valueForKey:@"play_record"];
    userInfo.banned =[NSString stringWithFormat:@"%@",[playRecordDic valueForKey:@"banned"]];
    userInfo.liked = [NSString stringWithFormat:@"%@",[playRecordDic valueForKey:@"liked"]];
    userInfo.played = [NSString stringWithFormat:@"%@",[playRecordDic valueForKey:@"played"]];
    [userInfo.managedObjectContext MR_saveToPersistentStoreWithCompletion:nil];

}
@end
