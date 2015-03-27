//
//  AccountInfo.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/26.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AccountInfo : NSManagedObject

@property (nonatomic, retain) NSString * banned;
@property (nonatomic, retain) NSString * cookies;
@property (nonatomic, retain) NSString * isNotLogin;
@property (nonatomic, retain) NSString * liked;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * played;
@property (nonatomic, retain) NSString * userId;

@end
