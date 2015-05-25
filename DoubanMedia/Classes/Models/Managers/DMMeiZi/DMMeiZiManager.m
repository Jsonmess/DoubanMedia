//
//  DMMeiZiManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiManager.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "DMMeiZiConstant.h"
#import "DMMeiZi.h"
@interface DMMeiZiManager()
{
    AFHTTPSessionManager *netManager;
}
@end
@implementation DMMeiZiManager


-(instancetype)init
{
    if (self = [super init])
    {
        netManager = [[AFHTTPSessionManager alloc]init];
                      netManager.requestSerializer.timeoutInterval = 20.0;
        netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return self;
}
- (void)getMeiziWithUrl:(NSString *)url page:(NSInteger)page
             completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion
{
    NSString *theUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,url];
    [netManager GET:theUrl parameters:nil//@{@"maxid": [@(page) stringValue]}
            success:^(NSURLSessionDataTask *task, NSData *responseData)
     {

//        if (responseJSON && [responseJSON[@"data"] isEqualToString:@"ok"])
//        {
//            NSMutableArray *meiziArray = [NSMutableArray arrayWithArray:[DMMeiZi objectArrayWithKeyValuesArray:responseJSON[@"imgs"]]];
//            NSInteger nextPage = [((DMMeiZi *)[meiziArray lastObject]).id integerValue];
//            [meiziArray removeLastObject];
//            completion(meiziArray, nextPage);
//            [self.delegate getDataStatus:kGetDataStatusSuccess];
//        } else {
//            completion(nil, 0);
//            [self.delegate getDataStatus:kGetDataStatusFaild];
//        }
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error.localizedDescription);
        completion(nil, 0);
         [self.delegate getDataStatus:kGetDataStatusError];
    }];
}
@end
