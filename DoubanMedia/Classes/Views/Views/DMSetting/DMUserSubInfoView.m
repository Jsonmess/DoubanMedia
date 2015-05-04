//
//  DMUserSubInfoView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/4.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMUserSubInfoView.h"
@interface DMUserSubInfoView()
{
    UIImageView *infoImageView;//用户详情标识
    UILabel *infoText;//详情
    UIView *contenView;//容器
}
@end
@implementation DMUserSubInfoView

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
    contenView = [[UIView alloc] init];
    infoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [infoImageView setImage:[UIImage imageNamed:@"error"]];
    [infoImageView setContentMode:UIViewContentModeScaleAspectFill];
    [infoImageView autoSetDimension:ALDimensionHeight toSize:32.0f];
	[infoImageView autoSetDimension:ALDimensionWidth toSize:32.0f];
    [contenView addSubview:infoImageView];
    [self addSubview:contenView];
    //详情
    infoText = [[UILabel alloc] initWithFrame:CGRectZero];
    [infoText setText:@"0"];
    [infoText setTextAlignment:NSTextAlignmentCenter];
    [contenView addSubview:infoText];
    //contains
    [contenView autoSetDimension:ALDimensionWidth toSize:55.0f];
    [contenView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self];
    [contenView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
    [contenView autoAlignAxisToSuperviewAxis:ALAxisVertical];

    [infoImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [infoImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:contenView];
    [infoText autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:infoImageView withOffset:5.0f];
    [infoText autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:contenView withOffset:2.0f];
    [infoText autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:contenView withOffset:2.0f];

}

//图标
-(UIImageView*)getImageView
{
    return infoImageView;
}
//标题
-(UILabel *)getInfoTextLabel
{
    return infoText;
}
@end
