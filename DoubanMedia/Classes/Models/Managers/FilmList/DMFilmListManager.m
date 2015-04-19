//
//  DMFilmListManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/18.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListManager.h"
#import <AFNetworking.h>
#import "FilmInfo.h"
#define onViewFilm @"/v2/movie/nowplaying" //正在热映
#define willView @"/v2/movie/coming" //即将上映

@interface DMFilmListManager()
{
	AFHTTPRequestOperationManager *operationManager;
}
@end
@implementation DMFilmListManager

-(instancetype)init
{
    if (self = [super init])
    {
        operationManager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}
//获取电影列表
-(void)getFilmList:(kFilmViewType)type
{
    NSString *filmPath ;
    BOOL isOnShow = NO;
    if (type == kFilmOnView)
    {
        filmPath = onViewFilm;
        isOnShow = YES;
    }
    else
    {
        filmPath = willView;
    }
    NSString *filmListUrl = [NSString stringWithFormat:@"%@%@",DoubanApiBaseUrl,filmPath];
    NSDictionary *paramDic = @{
					@"alt":@"json",
                    @"apikey":@"0df993c66c0c636e29ecbb5344252a4a"
                    };
    [operationManager GET:filmListUrl parameters:paramDic
                  success:^(AFHTTPRequestOperation *operation, id responseObject)
        {

            NSArray * entries = responseObject[@"entries"];
			//1.查询数据库
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isNowShow=%@",
                                      [NSNumber numberWithBool:isOnShow]];
            NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext MR_defaultContext]];
            NSArray *localFilmList = [FilmInfo MR_findAllWithPredicate:predicate inContext:context];

            if (localFilmList.count > 0 )
            {
				//清空数据表数据
                [FilmInfo MR_deleteAllMatchingPredicate:predicate inContext:[NSManagedObjectContext MR_defaultContext]];
                [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
                {
                    NSLog(@"电影信息数据已清空");
                }];
            }
			//2.创建数据
            if (entries.count >0)
            {
                for (NSDictionary *dic  in entries)
                {
                    FilmInfo * filmInfo = [FilmInfo MR_createInContext:context];
                    [filmInfo setFilmInfoDictionary:dic filmStatus:isOnShow];

                }
                //3.写入数据库
                [context MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
                {
                    NSLog(@"电影数据写入成功");
					[self.delegate reloadFilmDataWithfilmType:type];
                }];
            }
            else
            {
                [self.delegate reloadFilmDataWithfilmType:type];
            }

        }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
    	{
				//请求失败----从本地数据库中读取
				[self.delegate reloadFilmDataWithfilmType:type];
            
    	}];

}
@end
