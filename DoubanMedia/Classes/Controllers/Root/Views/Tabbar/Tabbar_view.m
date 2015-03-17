//
//  Tabbar_view.m
//  sinaweibo
//
//  Created by Json on 14-5-31.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import "Tabbar_view.h"
#import "Json_button.h"
//初始化按钮文字颜色
#define KTitleColor [UIColor colorWithRed:143.0f/255.0f green:133.0f/255.0f blue:133.0f/255.0f alpha:1.0f]
@interface Tabbar_view()
@property (strong,nonatomic)Json_button *selected_button;
@property (assign,nonatomic)NSInteger *num;

@end
@implementation Tabbar_view

#pragma mark----创建单例
static Tabbar_view *_instance;
+(id)ShareTabbar_view
{
    if (_instance ==nil) {
        _instance=[[self alloc]init];//这个会默认调用allocWithZone
        
    }
    return _instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    //防止多个线程运行时候，创建多个对象
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance=[super allocWithZone:zone];
    });
    return _instance;
}


-(id)initWithFrame:(CGRect)frame
{   self=[super initWithFrame:frame];
    if (self) {
         
    }
    return  self;
}
-(void)setBackground_image:(NSString*)background_image
{
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:background_image]]];
    
}
-(void)AddButtonWith:(NSString *)title NomalImage:(NSString *)nomal_image SelectedImage:(NSString *)selected_image
{
 
    
    CGFloat weidth= self.bounds.size.width/self._buttons_count;
    NSInteger index= self.subviews.count;
#pragma mark----------------设置单个按钮的高度
    Json_button *button=[[Json_button alloc]initWithFrame:CGRectMake((index * weidth), 0, weidth, self.bounds.size.height)];
    [button setTitleColor:KTitleColor forState:UIControlStateNormal];
    [button SetButtonview:title NomalImage:nomal_image SelectedImage:selected_image];
    [button setTag:index];
    [button addTarget:self action:@selector(Button_way:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:button];
    
    
    //默认让首页为选中状态
    if (self.subviews.count==1) {
        self.selected_button=button;
        self.selected_button.selected=YES;
        [self Button_way:button];
       
    }
}
-(void)Button_way:(Json_button *)button
{

    //1.将上次记录选中按钮selected属性设置为no
    self.selected_button.selected=NO;
    //2.将当前buttonselected属性设置为yes
    button.selected =YES;
    [button setTitleColor:[UIColor colorWithRed:143.0f/255.0f green:133.0f/255.0f blue:133.0f/255.0f alpha:0.8f] forState:UIControlStateSelected];
    
    //根据协议往主控制器传值
    [self.delegate SendButtonAction:self.selected_button.tag To:button.tag];
    
    //3.记录当前按钮
    self.selected_button=button;
}
@end
