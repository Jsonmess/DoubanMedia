//
//  FMChannel.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "FMChannel.h"


@implementation FMChannel

@dynamic channelID;
@dynamic channelName;
@dynamic section;
-(void)setChannelDictionary:(NSDictionary *)dic ChannelSection:(NSInteger)section
{
    self.channelID = [[dic objectForKey:@"id"]stringValue];
    self.channelName = [dic objectForKey:@"name"];
    self.section = [NSNumber numberWithInteger:section];
}
@end
