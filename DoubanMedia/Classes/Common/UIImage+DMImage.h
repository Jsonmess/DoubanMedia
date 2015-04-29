//
//  UIImage+DMImage.h
//  ShareDemo
//
//  Created by jsonmess on 15/4/26.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DMImage)
//根据颜色生成图片
+ (UIImage *) imageFromColor:(UIColor *)color;
@end
