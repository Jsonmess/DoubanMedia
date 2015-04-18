//
//  JSStarRating.m
//  starRatingDemo
//
//  Created by jsonmess on 15/4/17.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "JSStarRating.h"
#define star_gray @"ic_star_gray@2x.png"
#define  star_halfred @"ic_star_half@2x.png"
#define  star_red  @"ic_star_red@2x.png"
@interface JSStarRating()
{
    //星级
    UIImageView *show_star0;
    UIImageView *show_star1;
    UIImageView *show_star2;
    UIImageView *show_star3;
    UIImageView *show_star4;

    NSArray *stars;

}
@end
@implementation JSStarRating
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    [self setBackgroundColor:[UIColor grayColor]];
    show_star0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:star_gray]];
    show_star1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:star_gray]];
    show_star2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:star_gray]];
    show_star3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:star_gray]];
    show_star4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:star_gray]];
    stars = @[show_star0,show_star1,show_star2,show_star3,show_star4];

    [self addSubview:show_star0];
    [self addSubview:show_star1];
    [self addSubview:show_star2];
    [self addSubview:show_star3];
    [self addSubview:show_star4];


}
-(void)shouldSetContainsWithWidth:(CGFloat)width
{
    CGFloat starWidth = show_star0.image.size.width;
    CGFloat spacing = (width-10.0f-5*starWidth)/4;
    [stars autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:spacing*0.5 insetSpacing:YES];
    [show_star1 autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

}
#pragma actions
//清理评分数据
-(void)clearRateScore
{
    [show_star0 setImage:[UIImage imageNamed:star_gray]];
    [show_star1 setImage:[UIImage imageNamed:star_gray]];
    [show_star2 setImage:[UIImage imageNamed:star_gray]];
    [show_star3 setImage:[UIImage imageNamed:star_gray]];
    [show_star4 setImage:[UIImage imageNamed:star_gray]];
}
//计算显示的分数
-(void)showStarbyRatingValueWithRatingValue:(CGFloat)value
{
    if (value <= 0)
    {
        // 清除之前的分值
        [self clearRateScore];
        return;
    }
    if (value >10.0f)
    {
        value = 10.0f;
    }
    //取整数部分
    NSInteger intNum =(NSInteger)value*0.5;
    //取小数部
    CGFloat floatNum = value*0.5-(CGFloat)intNum;
    //大于0
    floatNum-=0.5;
    if ( floatNum > 0.2)
    {
        [self calculateStarNumberByValue:intNum+1 hasHalf:NO];

    }else if (floatNum < -0.2)
    {
        [self calculateStarNumberByValue:intNum hasHalf:NO];
    }else
    {
        [self calculateStarNumberByValue:intNum hasHalf:YES];
    }


}

//转换分数--->显示星级
-(void)calculateStarNumberByValue:(NSInteger)number hasHalf:(BOOL)hasHalf
{
    [self clearRateScore];
    //设置新的值
    UIImageView *tempImage;
    for (int i = 0; i < number; i++)
    {
        tempImage = self.subviews[i];
        [tempImage setImage:[UIImage imageNamed:star_red]];
    }
    if (hasHalf)
    {
        tempImage = self.subviews[number];
        [tempImage setImage:[UIImage imageNamed:star_halfred]];
    }
}

@end
