//
//  TabViewManager.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RootTabView.h"
@interface TabViewManager : NSObject

+ (instancetype)sharedTabViewManager;
-(RootTabView*)getTabView;
-(void)setTabView:(RootTabView *)tabView;
@end
