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

@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * cookies;
@property (nonatomic, retain) NSNumber * banned;
@property (nonatomic, retain) NSNumber * liked;
@property (nonatomic, retain) NSNumber * played;
@property (nonatomic, retain) NSNumber * isNotLogin;

@end
