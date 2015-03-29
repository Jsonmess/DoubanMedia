//
//  DMFMUserHeaderView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFMUserHeaderView.h"
@interface DMFMUserHeaderView()
{
    UIImageView *userIcon;//用户icon
    UILabel *userName;


}
@end;
@implementation DMFMUserHeaderView

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
    userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    userName = [[UILabel alloc] initWithFrame:CGRectZero];
    [userIcon setContentMode:UIViewContentModeScaleAspectFit];
    [self addSubview:userName];
    [self addSubview:userIcon];
    [userName setFont:DMFont(16.0f)];
    [userName setTextColor:DMColor(74, 217, 57, 0.8f)];
    [userIcon autoSetDimension:ALDimensionHeight toSize:20.0f];
    [userIcon autoSetDimension:ALDimensionWidth toSize:20.0f];
    [userIcon.layer setCornerRadius:10.0f];
    [userIcon setClipsToBounds:YES];
    [userIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [userIcon autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self withOffset:20.0f];

    [userName autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:userIcon withOffset:10.0f];
    [userName autoAlignAxisToSuperviewAxis:ALAxisHorizontal];

    [self setNeedsLayout];
}

-(void)setHeadViewContent:(NSString *)title Image:(UIImage *)image
{
    [userName setText:title];
    //是用户header
    if (image != nil)
    {
        [userIcon setHidden:NO];
        [userName setFont:DMFont(12.0f)];
        [userIcon setImage:image];

    }
    else
    {
		[userName setFont:DMFont(16.0f)];
        [userIcon setHidden:YES];
    }
    [self setNeedsLayout];
}
@end
