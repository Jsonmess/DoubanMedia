//
//  MBProgressHUD+DMProgressHUD.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/14.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (DMProgressHUD)
//text 提示
+(void)showTextOnlyIndicatorWithView:(UIView*)view
                                Text:(NSString *)text
                                Font:(UIFont*)font
                              Margin:(CGFloat)margin
    						offsetY:(CGFloat)offsetY
                            showTime:(CGFloat)timeLength;
//text 提示
+(MBProgressHUD *)createProgressOnlyWithView:(UIView *)view
                          ShouldRemoveOnHide:(BOOL)isHide;
//显示文字和指示器
+(MBProgressHUD*)showTextAndProgressViewIndicatorWithView:(UIView*)view
                                           Text:(NSString *)text
                                           Font:(UIFont*)font
                                         Margin:(CGFloat)margin;
@end
