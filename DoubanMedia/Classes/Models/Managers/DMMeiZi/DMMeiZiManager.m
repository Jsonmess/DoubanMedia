//
//  DMMeiZiManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiManager.h"
#import <AFNetworking/AFNetworking.h>
#import "DMMeiZiConstant.h"
#import "DMMeiZi.h"
#import <TFHpple.h>
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

    NSString *theUrl = [NSString stringWithFormat:@"%@%@&pager_offset=%@",BASE_URL,url,[@(page+1) stringValue]];
        [netManager GET:theUrl parameters:nil
            success:^(NSURLSessionDataTask *task, NSData *responseData)
     {
         TFHpple *htmlHpple = [TFHpple hppleWithHTMLData:responseData];
         NSArray *trelements_contents = [htmlHpple searchWithXPathQuery:@"//img"];
         if (trelements_contents.count <= 0)
         {
             [self.delegate getDataStatus:kGetDataStatusFaild];
               completion(nil, 0);
             return;
         }
         NSMutableArray *array = [NSMutableArray array];
         for (TFHppleElement *element in trelements_contents)
         {
             DMMeiZi *meizi = [[DMMeiZi alloc] init];
             meizi.title = element.attributes[@"title"];
             meizi.path = element.attributes[@"src"];
             [array addObject:meizi];
         }
        completion(array, page+1);
         [self.delegate getDataStatus:kGetDataStatusSuccess];
    } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         NSLog(@"%@",error.localizedDescription);
        completion(nil, 0);
         [self.delegate getDataStatus:kGetDataStatusError];
    }];
}

@end
