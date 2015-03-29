//
//  FMChannel.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/29.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FMChannel : NSManagedObject

@property (nonatomic, retain) NSString * channelID;
@property (nonatomic, retain) NSString * channelName;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSNumber * section;
-(void)setChannelDictionary:(NSDictionary *)dic ChannelSection:(NSInteger)section;
@end
