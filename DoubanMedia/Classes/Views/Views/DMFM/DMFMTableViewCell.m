//
//  DMFMTableViewCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFMTableViewCell.h"
#import <PureLayout.h>
#import "DMGlobal.h"
@interface DMFMTableViewCell()
{
    UILabel *channelTitle;//频道标题
    UILabel *mhz; //标识
    UIImageView * currentPlay;
}
@end
@implementation DMFMTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpView];

    }
    return self;
}
//设置cell
-(void)setUpView
{

    channelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [channelTitle setFont:DMFont(16.0f)];
    [channelTitle setText:@"  "];
    [channelTitle setTextColor:DMColor(180, 182, 182, 1.0f)];
    mhz = [[UILabel alloc] initWithFrame:CGRectZero];
    [mhz setFont:DMFont(12.0f)];
    [mhz setText:@"Mhz"];
    [mhz setTextColor:DMColor(180, 182, 182, 1.0f)];
    currentPlay = [[UIImageView alloc] initWithFrame:CGRectZero];
    [currentPlay setImage:[UIImage imageNamed:@"musicincon.png"]];
    [self.contentView addSubview:channelTitle];
    [self.contentView addSubview:mhz];
    [self.contentView addSubview:currentPlay];
    //setContains
    [channelTitle autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    [channelTitle autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:30.0f];
    [mhz autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:channelTitle withOffset:12.0f];
    [mhz autoAlignAxis:ALAxisHorizontal toSameAxisOfView:channelTitle withOffset:7.0f];

    [currentPlay autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView withOffset:-20.0f];
    [currentPlay autoSetDimension:ALDimensionHeight toSize:22.0f];
    [currentPlay autoSetDimension:ALDimensionWidth toSize:22.0f];
    [currentPlay setContentMode:UIViewContentModeScaleAspectFit];
    [currentPlay autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
    [currentPlay setHidden:YES];

    [self setNeedsLayout];
}
//设置cell内容
-(void)setCellContent:(NSString *)title isDouBanRed:(BOOL)isRed
{
    [channelTitle setText:title];
    //是否是豆瓣红心
    if (isRed)
    {
		[channelTitle setTextColor:DMColor(251, 22, 55, 1.0f)];
        mhz.textColor = channelTitle.textColor;
        [currentPlay setImage:[UIImage imageNamed:@"redMusicIncon.png"]];
    }
    else
    {
        [channelTitle setTextColor:DMColor(180, 182, 182, 1.0f)];
        [mhz setTextColor:channelTitle.textColor];
        [currentPlay setImage:[UIImage imageNamed:@"musicincon.png"]];
    }
    
    [self setNeedsLayout];
}
-(void)isNowPlayChannel:(BOOL)isPlay
{
    if (isPlay)
    {
        [currentPlay setHidden:NO];
    }
}
@end
