//
//  TabViewManager.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "TabViewManager.h"
@interface TabViewManager()
{
    RootTabView *_tabView;
}
@end
@implementation TabViewManager
+ (instancetype)sharedTabViewManager
{
    static TabViewManager *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[TabViewManager alloc] init];
    });
    return shared;
}
-(void)setTabView:(RootTabView *)tabView
{
    _tabView = tabView;
}
-(RootTabView*)getTabView
{
    if (_tabView == nil)
    {
        NSAssert(_tabView != nil, @"RootTabView 此时为空");
    }
    return  _tabView;
}
@end
