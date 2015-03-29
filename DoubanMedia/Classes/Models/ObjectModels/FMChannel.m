//
//  FMChannel.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/29.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "FMChannel.h"


@implementation FMChannel

@dynamic channelID;
@dynamic channelName;
@dynamic isSelected;//记录是否被选中
@dynamic section;//频道分类
-(void)setChannelDictionary:(NSDictionary *)dic ChannelSection:(NSInteger)section
{

    self.channelID =[dic objectForKey:@"id"];
    self.channelName = [dic objectForKey:@"name"];
    self.section = [NSNumber numberWithInteger:section];

}
@end
