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
#import "TabItem.h"
//初始化按钮文字颜色
#define KTitleColor [UIColor colorWithRed:143.0f/255.0f green:133.0f/255.0f blue:133.0f/255.0f alpha:1.0f]
@interface  RootTabView()
{
    NSMutableArray *tabItemsArray;//item对象数组

    NSArray *itemSourceNormalIcons;
    NSArray *itemSourceSelectedIcons;
    NSArray *itemSourceTitles;
    NSArray *itemSourceBgImages;
    UIImage *bgImage;//tabbar背景
    NSInteger tabItemsCount;//tabItems数量
    TabItem *selectedItem;//记录选中item
}
@property (nonatomic) UIImageView *mTabBGimage;
@end
@implementation RootTabView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self commonInit];

    }
    return self;
}
-(void)commonInit
{
    if (tabItemsArray == nil )
    {
        tabItemsArray = [NSMutableArray array];
    }

}

-(void)setTabDelegate:(id<TabbarDelegate>)TabDelegate
{
    _TabDelegate = TabDelegate;
    [self setContains];
}

-(void)setTabDataSource:(id<TabbarDataSource>)TabDataSource
{
    _TabDataSource = TabDataSource;
    [self getItemsDataSource];
    [self setUpView];
}
// 获取item资源
-(void)getItemsDataSource
{
    //数量
    if ([self.TabDataSource respondsToSelector:@selector(numberOfTabItemsInTabbarView)])
    {
        tabItemsCount = [self.TabDataSource  numberOfTabItemsInTabbarView];
    }
    else
    {
        NSAssert(tabItemsCount != 0, @"没有实现完整的TabDataSource代理");
    }
    //正常图标
    if ([self.TabDataSource respondsToSelector:@selector(theSourceOfItemNormalIcons)])
    {
        itemSourceNormalIcons = [self.TabDataSource theSourceOfItemNormalIcons];
    }
    else
    {
        NSAssert(itemSourceNormalIcons != nil, @"没有实现完整的TabDataSource代理");
    }
    //标题
    if ([self.TabDataSource respondsToSelector:@selector(theSourceOfItemTitles)])
    {
        itemSourceTitles = [self.TabDataSource theSourceOfItemTitles];
    }
    else
    {
        NSAssert(itemSourceTitles != nil, @"没有实现完整的TabDataSource代理");
    }
    //背景
    if ([self.TabDataSource respondsToSelector:@selector(theSourceOfItemBackGroundImages)])
    {
        itemSourceBgImages = [self.TabDataSource theSourceOfItemBackGroundImages];
    }
    //高亮图标
    if ([self.TabDataSource respondsToSelector:@selector(theSourceOfItemSelectedIcons)])
    {
        itemSourceSelectedIcons = [self.TabDataSource theSourceOfItemSelectedIcons];
    }
    //Tabbar背景
    if ([self.TabDataSource respondsToSelector:@selector(theSourceOfTabbarBackGroundImage)])
    {
        bgImage = [self.TabDataSource theSourceOfTabbarBackGroundImage];
    }
}
// 设置TabTool 界面
-(void)setUpView
{
    _mTabBGimage = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_mTabBGimage setImage:bgImage];
    [self addSubview:_mTabBGimage];
    //计算并添加item
    [tabItemsArray removeAllObjects];
    for (int i = 0; i <tabItemsCount; i++)
    {
        TabItem *tabItem = [[TabItem alloc]initWithFrame:CGRectZero];
        [self addSubview:tabItem];
        [tabItem setTag:i];
        [tabItem autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
        [tabItem autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
        [tabItem setTitleColor:KTitleColor forState:UIControlStateHighlighted];
        [tabItem setTitleColor:KTitleColor forState:UIControlStateNormal];
        [tabItem SetButtonview:itemSourceTitles[i]
                    NomalImage:itemSourceNormalIcons[i]
                 SelectedImage:itemSourceSelectedIcons[i]];
        [tabItem addTarget:self action:@selector(checkSelectedItem:)
          forControlEvents:UIControlEventTouchDown];
        [tabItemsArray addObject:tabItem];

    }
    //默认选择第一个
    TabItem *fitem = [tabItemsArray firstObject];
    selectedItem = fitem;
    [fitem setSelected:YES];

}
-(void)setContains
{
    [_mTabBGimage autoPinEdgesToSuperviewEdgesWithInsets:ALEdgeInsetsMake(0,0,0,0)];
    CGFloat indexWidth;
    if ([self.TabDelegate respondsToSelector:@selector(widthOfEachItem)])
    {
        indexWidth = [self.TabDelegate widthOfEachItem];
    }
    else
    {
        indexWidth =ScreenBounds.size.width/tabItemsCount;
    }

    [tabItemsArray autoDistributeViewsAlongAxis:ALAxisHorizontal
                                      alignedTo:ALAttributeHorizontal
                                  withFixedSize:indexWidth insetSpacing:NO];

    [self setNeedsLayout];
}

-(void)checkSelectedItem:(TabItem*)sender
{
    //1.将上次记录选中按钮selected属性设置为no
    selectedItem.selected=NO;
    //2.将当前buttonselected属性设置为yes
    sender.selected =YES;
    [sender setTitleColor:[UIColor colorWithRed:143.0f/255.0f
                                          green:133.0f/255.0f
                                           blue:133.0f/255.0f
                                          alpha:0.8f]
                 forState:UIControlStateSelected];

    [self.TabDelegate rootTabView:self lastSelectedItem:selectedItem.tag didSelectedItem:sender.tag];

    //3.记录当前按钮
    selectedItem=sender;
}

@end
