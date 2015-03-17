//
//  Json_button.m
//  sinaweibo
//
//  Created by Json on 14-5-31.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import "Json_button.h"
#define kDockItemSelectedBG @"TabBarItem_Selected.png"

// 文字的高度比例
#define kTitleRatio 0.3

@implementation Json_button

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        // 2.文字大小+默认字体颜色
        self.titleLabel.font = [UIFont systemFontOfSize:11.0f];

        //3.图片的内容模式
        self.imageView.contentMode = UIViewContentModeCenter;
        
        // 4.设置选中时的背景
        [self setBackgroundImage:[UIImage imageNamed:kDockItemSelectedBG] forState:UIControlStateSelected];
    }
    return self;
}
#pragma mark---重写高亮状态，空函数体，这样可以取消高亮状态
-(void)setHighlighted:(BOOL)highlighted{
    
}
-(void)SetButtonview:(NSString *)title NomalImage:(NSString *)nomal_image SelectedImage :(NSString *)selected_image
{
    [self setImage:[UIImage imageNamed:nomal_image] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:selected_image] forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateNormal];
    
}
#pragma mark 调整内部ImageView的frame
- (CGRect)imageRectForContentRect:(CGRect)contentRect//参数是图片的矩形大小
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * ( 1- kTitleRatio );
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

#pragma mark 调整内部UILabel的frame
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight - 3;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}
@end
