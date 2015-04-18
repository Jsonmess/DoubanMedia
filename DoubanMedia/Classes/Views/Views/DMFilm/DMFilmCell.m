//
//  DMFilmCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmCell.h"
#import "JSStarRating.h"
#import "DMDeviceManager.h"
#import <UIImageView+WebCache.h>
@interface DMFilmCell()
{
    JSStarRating *starRating;
	UILabel *filmScore;//评分
}
@end
@implementation DMFilmCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    //封面
    _filmImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_filmImageView setContentMode:UIViewContentModeScaleAspectFill];
    [_filmImageView setImage:[UIImage imageNamed:@"defaultmovie@2x.png"]];
    [_filmImageView setClipsToBounds:YES];
	//名称
    _filmName = [[UILabel alloc] initWithFrame:CGRectZero];
    [_filmName setText:@"速度与激情7"];
    [_filmName setNumberOfLines:0];
    [_filmName setTextAlignment:NSTextAlignmentCenter];
    //日期
    _filmShowDate = [[UILabel alloc] initWithFrame:CGRectZero];
    [_filmShowDate setText:@" "];
    [_filmShowDate setFont:DMFont(13.0f)];
    [_filmShowDate setTextAlignment:NSTextAlignmentCenter];
    //评分view
    _starRate = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:_filmImageView];
    [self addSubview:_filmName];
    [self addSubview:_filmShowDate];
    [self addSubview:_starRate];
    //星级
    starRating = [[JSStarRating alloc] initWithFrame:CGRectZero];
    [_starRate addSubview:starRating];
    filmScore = [[UILabel alloc] initWithFrame:CGRectZero];
    [filmScore setText:@" "];
    [filmScore setTextColor:DMColor(249, 106, 80, 1.0f)];
    [filmScore setFont:DMFont(12.0f)];
    [filmScore setTextAlignment:NSTextAlignmentCenter];
    [_starRate addSubview:filmScore];
    [self setContains];
}

-(void)setContains
{
    [_filmImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(7, 5, 5, 5) excludingEdge:ALEdgeBottom];
    CGFloat theRatio,filmNameFont,filmNameHeight,filmStarRatio;
    switch ([DMDeviceManager getCurrentDeviceType]) {
        case kiPad:
            theRatio = 13/16.0f;
            filmNameFont = 18.0f;
            filmNameHeight = 30.0f;
            filmStarRatio = 0.3f;
            break;
        default:
            theRatio=7/11.0f;
            filmNameFont = 12.0f;
            filmNameHeight = 20.0f;
            filmStarRatio = 0.2f;
            break;
    }
    [_filmImageView autoSetDimension:ALDimensionHeight toSize:self.bounds.size.height *theRatio];
	//名称
    [_filmName autoAlignAxis:ALAxisVertical toSameAxisOfView:_filmImageView];
    [_filmName setFont:DMBoldFont(filmNameFont)];
    [_filmName autoSetDimension:ALDimensionHeight toSize:filmNameHeight];
    [_filmName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_filmImageView withOffset:3.0f];
    //日期
    [_filmShowDate autoAlignAxis:ALAxisVertical toSameAxisOfView:_filmImageView];
    [_filmShowDate autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 0, 5) excludingEdge:ALEdgeTop];
    [_filmShowDate autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_filmName withOffset:5.0f];
	//评分
    [_starRate autoAlignAxis:ALAxisVertical toSameAxisOfView:_filmImageView];
    [_starRate autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 5, 5, 5) excludingEdge:ALEdgeTop];
    [_starRate autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_filmName withOffset:5.0f];

    //显示分数
    [filmScore autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [filmScore autoSetDimension:ALDimensionWidth toSize:self.bounds.size.width *filmStarRatio];
 	//星级
    [starRating autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:filmScore withOffset:-2.0f];
    [starRating autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
    [starRating autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_starRate];
    [starRating shouldSetContainsWithWidth:self.bounds.size.width*(1-filmStarRatio)];
    [self setNeedsLayout];
}
#pragma mark ---设置内容

-(void)setContentWithFilmInfo:(NSURL *)filmPoster filmName:(NSString *)title score:(CGFloat)score willOnView:(NSString *)showdate
{
    [_filmImageView sd_setImageWithURL:filmPoster placeholderImage:[UIImage imageNamed:@"defaultmovie@2x.png"] options:SDWebImageLowPriority|SDWebImageRetryFailed];
    [_filmName setText:title];
    if (showdate == nil)
    {
         [_starRate setHidden:NO];
        [filmScore setText:[NSString stringWithFormat:@"%f",score]];
        [starRating showStarbyRatingValueWithRatingValue:score];
    }
    else
    {
        [_starRate setHidden:YES];
        [_filmShowDate setText:showdate];
    }

    [self layoutIfNeeded];
}
@end
