//
//  UIImage+loadRemoteImage.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/11.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "UIImage+loadRemoteImage.h"
#import <SDWebImageDownloader.h>
@implementation UIImage (loadRemoteImage)
+(void )getRemoteImageWithUrl:(NSString *)url Suceess:(finishLoadImage)success faild:(errorLoadImage)faild
{
    NSURL *picUrl = [NSURL URLWithString:url];
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:picUrl options:SDWebImageDownloaderLowPriority progress:nil
    completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished)
    {
        if (image != nil)
        {
			success(image);
        }
        else
        {
            faild(error);
        }

    }];
    
}
@end
