//
//  DMLoginManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/25.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DMLoginManagerDelegate<NSObject>
//传出验证码图片地址
-(void)setCaptchaImageUrl:(NSString *)url;
//登录状态
-(void)loginState:(BOOL)state;
@end
@interface DMLoginManager : NSObject
@property(nonatomic)id<DMLoginManagerDelegate>loginDelegate;

//获取登录豆瓣验证码图片
-(void)getCaptchaImageFromDM;
@end
