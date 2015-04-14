//
//  UIImage+loadRemoteImage.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/11.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^finishLoadImage)(UIImage *image);
typedef void(^errorLoadImage)(NSError *error);
@interface UIImage (loadRemoteImage)

+(void )getRemoteImageWithUrl:(NSString *)url Suceess:(finishLoadImage)success faild:(errorLoadImage)faild;

@end
