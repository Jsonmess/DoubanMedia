//
//  DMSongInfo.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/8.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMSongInfo.h"

@implementation DMSongInfo
//根据字典设置音乐对象
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.artist = [dictionary objectForKey:@"artist"];
        self.title = [dictionary objectForKey:@"title"];
        self.audioFileURL =[NSURL URLWithString: [dictionary objectForKey:@"url"]];
        self.picture = [dictionary objectForKey:@"picture"];
        self.length = [dictionary objectForKey:@"length"];
        self.like = [dictionary objectForKey:@"like"];
        self.sid = [dictionary objectForKey:@"sid"];
    }
    return self;
}

@end
