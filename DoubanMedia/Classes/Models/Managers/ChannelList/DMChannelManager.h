//
//  DMChannelManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/29.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DMChannelDelegate<NSObject>
-(void)shouldReloadData:(BOOL)isReadFromLocal;
@end
@interface DMChannelManager : NSObject
@property (nonatomic,weak) id<DMChannelDelegate>delegate;
//获取频道列表数据
-(void)getChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString;
@end
