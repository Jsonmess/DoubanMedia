//
//  MBProgressHUD+DMProgressHUD.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/14.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "MBProgressHUD+DMProgressHUD.h"

@implementation MBProgressHUD (DMProgressHUD)
//直接显示文字
+(void)showTextOnlyIndicatorWithView:(UIView*)view
                                       Text:(NSString *)text
                                        Font:(UIFont*)font
                                     Margin:(CGFloat)margin
                                   showTime:(CGFloat)timeLength
{
	MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.labelFont = font;
    hud.margin = margin;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = DMColor(200, 200, 200, 0.9f);
    [hud hide:YES afterDelay:timeLength];
}
//只显示加载
+(MBProgressHUD *)createProgressOnlyWithView:(UIView *)view
                          ShouldRemoveOnHide:(BOOL)isHide
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.color = DMColor(200, 200, 200, 0.9f);
    hud.removeFromSuperViewOnHide = isHide;
    return hud;
}

//显示文字和指示器
+(MBProgressHUD*)showTextAndProgressViewIndicatorWithView:(UIView*)view
                                Text:(NSString *)text
                                Font:(UIFont*)font
                              Margin:(CGFloat)margin
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view
                                              animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = text;
    hud.labelFont = font;
    hud.margin = margin;
    hud.removeFromSuperViewOnHide = YES;
    hud.color = DMColor(200, 200, 200, 0.9f);
    return hud;
}
@end
