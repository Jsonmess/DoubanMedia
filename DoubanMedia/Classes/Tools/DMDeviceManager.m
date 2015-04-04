//
//  DMDeviceManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/1.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMDeviceManager.h"

@implementation DMDeviceManager

+(KDeviceType)getCurrentDeviceType
{
    CGFloat width = ScreenBounds.size.width;
    if (width <= 320)
    {
        return kiPhone5;

    }else if(width > 320 && width < 400 )
    {
        return kiPhone6;
    }
    else
    {
        return kIphone6Plus;
    }

}
@end
