//
//  DMDeviceManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/1.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, KDeviceType)
{
    kiPhone4s = 0,
    kiPhone5s,
    kiPhone6,
    kiPhone6Plus,
    kiPad,
};
@interface DMDeviceManager : NSObject

+(KDeviceType)getCurrentDeviceType;
@end
