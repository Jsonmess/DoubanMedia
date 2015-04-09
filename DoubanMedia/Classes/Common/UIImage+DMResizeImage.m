//
//  UIImage+DMResizeImage.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "UIImage+DMResizeImage.h"

@implementation UIImage (DMResizeImage)
+(id)ResizeThePicture:(NSString *)ImageName
    WithUIEdgeInserts:(UIEdgeInsets)insets
         resizingMode:(UIImageResizingMode)Mode
{
    UIImage *image =[UIImage imageNamed:ImageName];
    image=[image resizableImageWithCapInsets:insets resizingMode:Mode];
    return image;
}
@end
