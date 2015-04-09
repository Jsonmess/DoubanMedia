//
//  DMSongInfo.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/8.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioFile.h>
@interface DMSongInfo : NSObject<DOUAudioFile>
@property int index;
@property NSString *title;
@property NSString *artist;
@property NSString *picture;
@property NSString *length;
@property NSString *like;
@property NSURL *audioFileURL;
@property NSString *sid;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
@end
