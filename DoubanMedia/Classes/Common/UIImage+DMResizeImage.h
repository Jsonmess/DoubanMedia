//
//  UIImage+DMResizeImage.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DMResizeImage)
+(id)ResizeThePicture:(NSString *)ImageName
    WithUIEdgeInserts:(UIEdgeInsets)insets
         resizingMode:(UIImageResizingMode)Mode;
@end
