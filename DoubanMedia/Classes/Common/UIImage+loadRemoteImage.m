//
//  UIImage+loadRemoteImage.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/11.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "UIImage+loadRemoteImage.h"

@implementation UIImage (loadRemoteImage)

+(void )getRemoteImageWithUrl:(NSString *)url Suceess:(finishLoadImage)success
{
    NSURL *picUrl = [NSURL URLWithString:url];
    dispatch_queue_t queue =dispatch_queue_create("loadImage",NULL);
    dispatch_async(queue, ^{

        NSData *resultData = [NSData dataWithContentsOfURL:picUrl];


        dispatch_async(dispatch_get_main_queue(), ^{

            UIImage *image = [UIImage imageWithData:resultData];
            success(image);
        });
    });
}
@end
