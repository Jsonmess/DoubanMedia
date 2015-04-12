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
     CGFloat height = ScreenBounds.size.height;

    if (width <= 320)
    {
        if (height > 480 )
        {
            return kiPhone5s;
        }
        else
        {
            return kiPhone4s;
        }

    }else if (height > 750)
    {
        return kiPad;
    }
    else if(width > 320 && width < 400 )
    {
        return kiPhone6;
    }
    else
    {
        return kiPhone6Plus;
    }

}
@end
