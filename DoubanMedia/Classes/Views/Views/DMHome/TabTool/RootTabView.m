//
//  RootTabView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "RootTabView.h"
#import "PureLayout.h"
#import "DMGlobal.h"

#define  TabButtonCount 4


@interface  RootTabView()

@property (nonatomic) UIImageView *mTabBGimage;
@end
@implementation RootTabView

 - (instancetype)initWithFrame:(CGRect)frame
 {
	self = [super initWithFrame:frame];
	 if (self)
	 {
		 [self setUpView];
	 }
	 return self;
 }
/*
 *  设置TabTool 界面
 */
-(void)setUpView
{
	_mTabBGimage = [[UIImageView alloc] initWithFrame:CGRectZero];
	[self addSubview:_mTabBGimage];
	for (int i = 0; i < 4; ++i)
	{
		UIButton * mTabButton = [[UIButton alloc] initWithFrame:CGRectZero];
		[mTabButton setTag:i];
		[self addSubview: mTabButton];
	}

}
-(void)setContains
{
	[_mTabBGimage autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0,0,0,0)];
	//此处写死--自动布局---需要添加控件时候此处添加合适的布局

	//左一
	UIButton * button0 = [self viewWithTag:0];
	[button0 autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width/TabButtonCount];
	[button0 autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0,0,0,0) excludingEdge:ALEdgeRight];
	//右一
	UIButton *button3 = [self viewWithTag:3];
	[button0 autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width/TabButtonCount];
	[button0 autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0,0,0,0) excludingEdge:ALEdgeLeft];
	//左二
	UIButton *button1 =[self viewWithTag:1];
	[button1 autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width/TabButtonCount];
	[button1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:button0];
	[button1 autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
	//右二
	UIButton *button2 =[self viewWithTag:2];
	[button1 autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width/TabButtonCount];
	[button1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:button0];
	[button1 autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];

}



@end
