//
//  DMSettingCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMSettingCell.h"
#import "DMDeviceManager.h"
@interface DMSettingCell()
{
    UILabel *titleLabel;//标题
    UILabel *subTitleLabel;//子标题
    UISwitch *theSwitch;//开关控制部件
    UIImageView *arrowsView;//指示
}
@end
@implementation DMSettingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    UIFont *font = DMFont(15.0f);
    UIFont *subFont = DMFont(12.0f);
    if ([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        font = DMFont(18.0f);
        subFont = DMFont(15.0f);
    }
    [titleLabel setFont:font];
    subTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [subTitleLabel setTextAlignment:NSTextAlignmentRight];
    [subTitleLabel setFont:subFont];
    theSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
    [theSwitch setOn:NO];
    //默认隐藏
    [theSwitch setHidden:YES];
    arrowsView = [[UIImageView alloc ] initWithFrame:CGRectZero];
    [arrowsView setImage:[UIImage imageNamed:@"Settingforward_pressed"]];
    [arrowsView setContentMode:UIViewContentModeScaleAspectFill];
    [self.contentView addSubview:titleLabel];
    [self.contentView addSubview:subTitleLabel];
    [self.contentView addSubview:theSwitch];
    [self.contentView addSubview:arrowsView];
    [self setContains];
}
//设置约束
-(void)setContains
{
    [titleLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft
                     ofView:self.contentView
                 withOffset:ScreenBounds.size.width *0.07f];
    [titleLabel autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width *0.4f];
	//箭头提示
    [arrowsView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    CGFloat arrowHeight=27.0f;
    if ([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        arrowHeight = 35.0f;
    }
    [arrowsView autoSetDimension:ALDimensionWidth toSize:arrowHeight];
    [arrowsView autoSetDimension:ALDimensionHeight toSize:arrowHeight];
    [arrowsView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:ScreenBounds.size.width *0.07f];
    //开关控件
    [theSwitch autoSetDimension:ALDimensionHeight toSize:30.0f];
    [theSwitch autoSetDimension:ALDimensionWidth toSize:65.0f];
    [theSwitch autoAlignAxis:ALAxisVertical toSameAxisOfView:arrowsView];
    [theSwitch autoAlignAxis:ALAxisHorizontal toSameAxisOfView:arrowsView];
    //子标题
    [subTitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft
						ofView:theSwitch withOffset:-ScreenBounds.size.width *0.03f];
    [subTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:titleLabel withOffset:5.0f];
    [subTitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:titleLabel];
    [subTitleLabel autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width *0.2f];

}

-(void)setContentsWithTitle:(NSString *)title
                   subTitle:(NSString *)subtitle
         isShouldShowSwitch:(BOOL)showSwitch
                 haveArrows:(BOOL)showArrows
{
    NSAssert(title != nil, @"cell 标题不可以为空");
    [titleLabel setText:title];
    if (subtitle == nil)
    {
		subtitle = @" ";//显示空label，不隐藏
    }
    [subTitleLabel setText:subtitle];

    [theSwitch setHidden: showSwitch ? NO : YES];
    [arrowsView setHidden: showArrows ? NO : YES];

    [self setNeedsLayout];
}

@end
