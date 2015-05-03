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
@protocol filmManagerDelegate <NSObject>

-(void)reloadFilmDataWithfilmType:(kFilmViewType)type;
@end

@interface DMFilmListManager : NSObject
@property (nonatomic) id<filmManagerDelegate>delegate;
//获取电影列表
-(void)getFilmList:(kFilmViewType)type;

//获取具体单部电影信息--未加入电影位置
-(void)getTheFilmInfoWithFilmId:(NSString *)filmId;
@end
