//
//  DMMeiZiManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求状态
typedef NS_ENUM(NSInteger, kGetDataStatus)
{
    kGetDataStatusSuccess = 0,
    kGetDataStatusFaild,
    kGetDataStatusError
};
@protocol DMMeiZiManagerDelegate<NSObject>
-(void)getDataStatus:(kGetDataStatus)status;
@end

@interface DMMeiZiManager : NSObject
@property(nonatomic) id<DMMeiZiManagerDelegate>delegate;
- (void)getMeiziWithUrl:(NSString *)url page:(NSInteger)page
             completion:(void (^)(NSArray *meiziArray, NSInteger nextPage))completion;
@end
