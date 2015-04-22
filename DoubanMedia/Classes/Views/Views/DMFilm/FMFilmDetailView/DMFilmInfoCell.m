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
#import "DMDeviceManager.h"
#import <UIButton+AFNetworking.h>
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
    [filmPosterImage setBackgroundImage:[UIImage imageNamed:@"defaultmovie@2x.png"]
                               forState:UIControlStateNormal];
    ratingView = [[UIView alloc] initWithFrame:CGRectZero];
    [ratingView setBackgroundColor:[UIColor redColor]];
    starRating = [[JSStarRating alloc ] initWithFrame:CGRectZero];
    scoreLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    [scoreLabel setTextColor:[UIColor blueColor]];
    [scoreLabel setText:@"10"];
    [scoreLabel setFont:DMFont(11.0f)];
    ratingNumber  = [[UILabel alloc] initWithFrame:CGRectZero];
    [ratingNumber setText:@"8738人评分"];
    [ratingNumber setFont:DMFont(12.0f)];
    pubDateAndDuration = [[UILabel alloc] initWithFrame:CGRectZero];
    [pubDateAndDuration setFont:DMFont(13.0f)];
    [pubDateAndDuration setText:@"2015-04-12/137分钟"];
    pubLocation  = [[UILabel alloc] initWithFrame:CGRectZero];
    [pubLocation setText:@"美国、日本"];
    [pubLocation setFont:DMFont(13.0f)];
    filmProperty  = [[UILabel alloc] initWithFrame:CGRectZero];
    [filmProperty setText:@"动作/犯罪/惊悚/恐怖"];
    [filmProperty setFont:DMFont(13.0f)];
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
//根据屏幕调整--图片宽度
-(void)setContains
{
    [filmPosterImage autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 0, 0, 0) excludingEdge:ALEdgeRight];
    CGFloat width = 120;
    if ([DMDeviceManager getCurrentDeviceType] == kiPhone6Plus)
    {
        width = 140.0f;
    }
    [filmPosterImage autoSetDimension:ALDimensionWidth toSize:width];
  	//评分
    [ratingView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:filmPosterImage withOffset:10.0f];
    [ratingView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self withOffset:15.0f];
    [ratingView autoSetDimension:ALDimensionWidth toSize:100.0f];
    [ratingView autoSetDimension:ALDimensionHeight toSize:20.0f];
    //显示分数
    CGFloat filmStarRatio = 0.2f;
    [scoreLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeLeft];
    [scoreLabel autoSetDimension:ALDimensionWidth toSize:100 *filmStarRatio];
    //星级
    [starRating autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:scoreLabel withOffset:-2.0f];
    [starRating autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeRight];
    [starRating autoAlignAxis:ALAxisHorizontal toSameAxisOfView:ratingView];
    [starRating shouldSetContainsWithWidth:100*(1-filmStarRatio)];
	//评分人数
    [ratingNumber autoAlignAxis:ALAxisHorizontal toSameAxisOfView:ratingView];
    [ratingNumber autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:ratingView withOffset:8.0f];
    [ratingNumber autoSetDimension:ALDimensionWidth toSize:70.0f];
    [ratingNumber autoSetDimension:ALDimensionHeight toSize:20.0f];
    //上映日期
    [pubDateAndDuration autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [pubDateAndDuration autoSetDimension:ALDimensionHeight toSize:20.0f];
	[pubDateAndDuration autoSetDimension:ALDimensionWidth toSize:130.0f];
    [pubDateAndDuration autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:ratingView withOffset:8.0f];

    //电影产地

	[pubLocation autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pubDateAndDuration withOffset:4.0f];
    [pubLocation autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:pubDateAndDuration];
    [pubLocation autoSetDimension:ALDimensionHeight toSize:20.0f];
   [pubLocation autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:pubDateAndDuration];

    //电影属性
    [filmProperty autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pubLocation withOffset:4.0f];
    [filmProperty autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:pubLocation];
    [filmProperty autoSetDimension:ALDimensionHeight toSize:20.0f];
    [filmProperty autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:pubLocation];
    //分享给好友
    [shareToFriend autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:ratingView];
    [shareToFriend autoSetDimension:ALDimensionHeight toSize:36.0f];
	[shareToFriend autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:ratingNumber];
    [shareToFriend autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-2.0f];
}

#pragma mark ----setContents
/** 电影海报url
  * 评分人数
  * 上映日期
  * 片长
  * 电影产地
  * 电影属性
  */
-(void)setContentWith:(NSURL*)posterUrl Score:(CGFloat)value RatingNumber:(NSInteger)number Pubdate:(NSString *)date
         filmDuration:(NSString *)duration filmLocate:(NSString*)locate filmProperty:(NSString *)property
{
   [filmPosterImage setImageForState:UIControlStateNormal|UIControlStateHighlighted withURL:posterUrl
                    placeholderImage:[UIImage imageNamed:@"defaultmovie@2x.png"]];
    [starRating showStarbyRatingValueWithRatingValue:value];
    [scoreLabel setText:[NSString stringWithFormat:@"%.1f",value]];
    [ratingNumber setText:[NSString stringWithFormat:@"%zi人评分",number]];
    [pubDateAndDuration setText:[NSString stringWithFormat:@"%@/%@分钟",date,duration]];
    [filmProperty setText:property];

}

@end
