//
//  RootTabView.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootTabView;
@protocol TabbarDelegate <NSObject>
@required
-(void)rootTabView:(RootTabView*)tabbarView lastSelectedItem:(NSInteger)lindex didSelectedItem:(NSInteger)nindex;
@optional
//item的高度
-(CGFloat)widthOfEachItem;
@end

@protocol TabbarDataSource <NSObject>

@required
//Tab标签数量
-(NSInteger)numberOfTabItemsInTabbarView;
//普通icon
-(NSArray *)theSourceOfItemNormalIcons;
//标题
-(NSArray *) theSourceOfItemTitles;
@optional
//高亮选中icon
-(NSArray *)theSourceOfItemSelectedIcons;
//背景
-(NSArray *)theSourceOfItemBackGroundImages;

//Tabbar背景
-(UIImage *)theSourceOfTabbarBackGroundImage;

@end

@interface RootTabView : UIView

@property (nonatomic,strong) id <TabbarDelegate>TabDelegate;
@property (nonatomic,strong) id <TabbarDataSource>TabDataSource;

@end
