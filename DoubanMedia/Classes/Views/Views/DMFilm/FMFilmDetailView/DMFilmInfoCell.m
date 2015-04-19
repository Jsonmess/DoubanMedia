//
//  DMFilmInfoCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//
//此cell用于展示电影的基本属性
#import "DMFilmInfoCell.h"
#import "JSStarRating.h"
@interface DMFilmInfoCell()
{
    UIButton *filmPosterImage;//电影海报
    JSStarRating *starRating;//星级
    UILabel *scoreLabel;//分数
    UILabel *ratingNumber;//评分人数
    UILabel *pubDateAndDuration;//上映日期+片长
    UILabel *pubLocation;//电影地区
    UILabel * filmProperty;//电影属性
    UIButton *shareToFriend;//分享给好友
    UIView *ratingView;
}
@end
@implementation DMFilmInfoCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    filmPosterImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [filmPosterImage setBackgroundColor:[UIColor blackColor]];

    ratingView = [[UIView alloc] initWithFrame:CGRectZero];
    [ratingView setBackgroundColor:[UIColor redColor]];
    starRating = [[JSStarRating alloc ] initWithFrame:CGRectZero];
    scoreLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    ratingNumber  = [[UILabel alloc] initWithFrame:CGRectZero];
    [ratingNumber setText:@"8738人评分"];
    pubDateAndDuration = [[UILabel alloc] initWithFrame:CGRectZero];
    [pubDateAndDuration setText:@"137分钟"];
    pubLocation  = [[UILabel alloc] initWithFrame:CGRectZero];
    [pubLocation setText:@"2015-04-12"];
    filmProperty  = [[UILabel alloc] initWithFrame:CGRectZero];
    [filmProperty setText:@"动作/犯罪/惊悚/恐怖"];
    shareToFriend = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareToFriend setBackgroundColor:[UIColor blueColor]];
    [shareToFriend setTitle:@"分享给好友" forState: UIControlStateNormal];
    [self.contentView addSubview:filmPosterImage];

    [ratingView addSubview:starRating];
    [ratingView addSubview:scoreLabel];
    [self.contentView addSubview:ratingView];

    [self.contentView addSubview:ratingNumber];
    [self.contentView addSubview:pubDateAndDuration];
    [self.contentView addSubview:pubLocation];
    [self.contentView addSubview:filmProperty];
    [self.contentView addSubview:shareToFriend];

    [self setContains];
}

-(void)setContains
{
    [filmPosterImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 0, 0, 0) excludingEdge:ALEdgeRight];
    [filmPosterImage autoSetDimension:ALDimensionWidth toSize:self.bounds.size.height*2/3];
  	//评分
    [ratingView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:filmPosterImage withOffset:10.0f];
    [ratingView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:10.0f];
    [ratingView autoSetDimension:ALDimensionWidth toSize:filmPosterImage.bounds.size.width*3/4];
    [ratingView autoSetDimension:ALDimensionHeight toSize:40.0f];
    //显示分数
    CGFloat filmStarRatio = 0.2f;
    [scoreLabel setFont:DMFont(10.0f)];
    [scoreLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [scoreLabel autoSetDimension:ALDimensionWidth toSize:self.bounds.size.width *filmStarRatio];
    //星级
    [starRating autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:scoreLabel withOffset:-2.0f];
    [starRating autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
    [starRating autoAlignAxis:ALAxisHorizontal toSameAxisOfView:ratingView];
    [starRating shouldSetContainsWithWidth:self.bounds.size.width*(1-filmStarRatio)];
	//评分人数
    [ratingNumber autoAlignAxis:ALAxisHorizontal toSameAxisOfView:ratingView];
    [ratingNumber autoSetDimension:ALDimensionWidth toSize:ratingView.bounds.size.width*2/3];
    [ratingNumber autoSetDimension:ALDimensionHeight toSize:20.0f];
    //上映日期
    [pubDateAndDuration autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [pubDateAndDuration autoSetDimension:ALDimensionHeight toSize:20.0f];
	[pubDateAndDuration autoSetDimension:ALDimensionWidth toSize:ratingNumber.bounds.size.width*2];
    [pubDateAndDuration autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:ratingView withOffset:10.0f];

    //电影产地

	[pubLocation autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pubDateAndDuration withOffset:2.0f];
    [pubLocation autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [pubLocation autoSetDimension:ALDimensionHeight toSize:20.0f];
    [pubLocation autoSetDimension:ALDimensionWidth toSize:ratingNumber.bounds.size.width];

    //电影属性
    [filmProperty autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pubLocation withOffset:2.0f];
    [filmProperty autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [filmProperty autoSetDimension:ALDimensionHeight toSize:20.0f];
    [filmProperty autoSetDimension:ALDimensionWidth toSize:ratingNumber.bounds.size.width];
    //分享给好友
    [shareToFriend autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [shareToFriend autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:filmProperty withOffset:15.0f];
	[shareToFriend autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self withOffset:-40.0f];
    [shareToFriend autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
