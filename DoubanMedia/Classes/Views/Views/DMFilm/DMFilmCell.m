//
//  DMFilmCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmCell.h"
@interface DMFilmCell()
@end
@implementation DMFilmCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor redColor]];
    }
    return self;
}

-(void)setUpView
{
    //封面
    _filmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_filmImageView setBackgroundColor:[UIColor redColor]];
	//名称
    _filmName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_filmName setText:@"速度与激情7"];
    [_filmName setFont:DMFont(17.0f)];
    [_filmName setTextColor:[UIColor blackColor]];
    [_filmName setTextAlignment:NSTextAlignmentCenter];
    //日期
    _filmShowDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [_filmShowDate setText:@"2015-07"];
    [_filmShowDate setFont:DMFont(14.0f)];
    [_filmShowDate setTextColor:[UIColor grayColor]];
    [_filmShowDate setTextAlignment:NSTextAlignmentCenter];
    //评分view
    _starRate = [[UIView alloc] initWithFrame:CGRectZero];
    [_starRate setBackgroundColor:[UIColor blueColor]];
    [self setContains];

}

-(void)setContains
{
    [_filmImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 5, 5, 5) excludingEdge:ALEdgeBottom];

    [_filmImageView autoSetDimension:ALDimensionHeight toSize:self.bounds.size.height *3/5];
	//名称

    [_filmName autoAlignAxis:ALAxisVertical toSameAxisOfView:_filmImageView];
    [_filmName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_filmImageView withOffset:3.0f];
    

}
@end
