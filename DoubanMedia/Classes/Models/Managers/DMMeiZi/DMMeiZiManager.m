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
        netManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
        netManager.requestSerializer.timeoutInterval = 20.0;
        netManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
        netManager.responseSerializer.acceptableContentTypes = [netManager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObject:@"text/html"]];
    }
    return self;
}
- (void)getMeiziWithUrl:(NSString *)url page:(NSInteger)page
             completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion
{
    [netManager GET:url parameters:@{@"maxid": [@(page) stringValue]}
            success:^(NSURLSessionDataTask *task, id responseJSON)
     {
        if (responseJSON && [responseJSON[@"data"] isEqualToString:@"ok"])
        {
            NSMutableArray *meiziArray = [NSMutableArray arrayWithArray:[DMMeiZi objectArrayWithKeyValuesArray:responseJSON[@"imgs"]]];
            NSInteger nextPage = [((DMMeiZi *)[meiziArray lastObject]).id integerValue];
            [meiziArray removeLastObject];
            completion(meiziArray, nextPage);
            [self.delegate getDataStatus:kGetDataStatusSuccess];
        } else {
            completion(nil, 0);
            [self.delegate getDataStatus:kGetDataStatusFaild];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
        completion(nil, 0); [self.delegate getDataStatus:kGetDataStatusError];
    }];
}
@end
