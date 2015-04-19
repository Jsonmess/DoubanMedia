//
//  DMFilmListManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/18.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListManager.h"
#import <AFNetworking.h>
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
    if (type == kFilmOnView)
    {
        filmPath = onViewFilm;
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

            NSDictionary * dic = responseObject[@"entries"];

            NSLog(@"电影信息\n%@",dic);
        }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
    	{

    	}];

}
@end
