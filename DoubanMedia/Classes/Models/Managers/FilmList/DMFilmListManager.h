//
//  DMFilmListManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/18.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
//电影状态
typedef NS_ENUM(NSInteger, kFilmViewType)
{
    kFilmOnView = 0,
    kFilmWillView
};
@interface DMFilmListManager : NSObject
//获取电影列表
-(void)getFilmList:(kFilmViewType)type;
@end
