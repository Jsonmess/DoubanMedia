//
//  PGHtmlActionSheet.h
//  ShareToThirdDemo
//
//  Created by jsonmess on 15/2/5.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//
/**
 *  每个Item的标题
 *
 *  @param actionSheet
 *  @param index
 *
 *  @return
 */
#import <UIKit/UIKit.h>
@class PGHtmlActionSheet;
/**
 *  上拉菜单数据源
 */
@protocol PGHtmlActionSheetDataSource<NSObject>

@required
/**
 *  分享控件个数
 *
 *  @return number
 */
-(NSInteger)numberOfShareAction;
/**
 *  指定要显示的分享控件标题
 *
 *  @return titles array
 */
-(NSArray *)titleOfShareAction;

/**
 *  设置分享控件显示图片文件名
 *
 *  @return image file name array
 */
-(NSArray *)imageFileNameOfShareAction;

@end
/**
 *   上拉菜单设置代理
 */
@protocol PGHtmlActionSheetDelegate<NSObject>

@optional
/*
 *	分享控件是否应该选中
 */
-(BOOL)pgActionSheet:(PGHtmlActionSheet*)actionSheet shouldSelectedItemAtIndex:(NSInteger)index;
/*
 *	分享控件选中后
 */
-(void)pgActionSheet:(PGHtmlActionSheet*)actionSheet didSelectedItemAtIndex:(NSInteger)index;
/*
 *	分享控件是否应该取消选中
 */
-(BOOL)pgActionSheet:(PGHtmlActionSheet*)actionSheet shouldDeSelectedItemAtIndex:(NSInteger)index;
/*
 *	分享控件取消选中后
 */
-(void)pgActionSheet:(PGHtmlActionSheet*)actionSheet didDeSelectedItemAtIndex:(NSInteger)index;

/*
 *分享控件是否选中高亮
 */
-(BOOL)pgActionSheet:(PGHtmlActionSheet *)actionSheet shouldHighlightItemAtIndex:(NSInteger)index;
/*
 *分享控件选中高亮后
 */
-(void)pgActionSheet:(PGHtmlActionSheet *)actionSheet didHightlightItemAtIndex:(NSInteger)index;
/*
 *分享控件取消选中高亮
 */
-(void)pgActionSheet:(PGHtmlActionSheet*)actionSheet didUnhighlightItemAtIndex:(NSInteger)index;

@end

/*
 *	Html5分享上滑菜单
 */
@interface PGHtmlActionSheet : UIView
@property(nonatomic)id<PGHtmlActionSheetDataSource>dataSource;
@property(nonatomic)id<PGHtmlActionSheetDelegate>delegate;
/*
 * 初始化滑动菜单
 */
-(instancetype)initPGActionSheetWithFrame:(CGRect)frame withOnePageCellNumber:(NSInteger)number;
/*
 *设置菜单当前设备屏幕一屏显示控件数
 */
-(void)setNumberOfShareActionOneScreen:(NSInteger)number;
/*
 *刷新数据
 */
-(void)reloadShareActionData;
/* 
 *	隐藏菜单
 */
- (void)hide;
/*
 *显示菜单
 */
- (void)show;
@end
