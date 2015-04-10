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
    kiPhone5 = 0,
    kiPhone6,
    kIphone6Plus
};
@interface DMDeviceManager : NSObject

+(KDeviceType)getCurrentDeviceType;
@end
