//
//  UIImage+DMImage.m
//  ShareDemo
//
//  Created by jsonmess on 15/4/26.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "UIImage+DMImage.h"

@implementation UIImage (DMImage)
//根据颜色生成图片
+ (UIImage *) imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
