//
//  PGActionSheetCell.m
//  ShareToThirdDemo
//
//  Created by jsonmess on 15/2/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "PGActionSheetCell.h"
@interface PGActionSheetCell()
{
    
    UIImageView *_iconImageView;
    UILabel *_titleLabel;
}

@end
@implementation PGActionSheetCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setUpView];
    }
    return self;
}
-(void)setUpView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_iconImageView setUserInteractionEnabled:YES];
    }
    [_iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.contentView addSubview:_iconImageView];
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setFont:DMFont(10.0f)];
        [_titleLabel setTextColor:DMCOLOR_WITH_HEX(0x999999, 1.0)];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setUserInteractionEnabled:YES];
    }
    [self.contentView addSubview:_titleLabel];
    
    [_iconImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5, 5, 0, 5)
                                             excludingEdge:ALEdgeBottom];
    [_iconImageView autoSetDimension:ALDimensionHeight toSize:45.0f];
    [_iconImageView autoSetDimension:ALDimensionWidth toSize:45.0f];
    [_titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                          excludingEdge:ALEdgeTop];
    [_titleLabel setContentMode:UIViewContentModeCenter];
    [_titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom
                      ofView:_iconImageView withOffset:4.0f];
    
}
-(void)setShareIconTitle:(NSString *)title
{
    if (title)
    {
        [_titleLabel setText:title];
        [self layoutIfNeeded];
    }
    else
    {
        NSAssert(title != nil, @"标题传入为空");
    }
    
    [self layoutIfNeeded];
}
-(void)setShareIconImageName:(NSString *)iconName
{
    UIImage *image = [UIImage imageNamed:iconName];
    if (image)
    {
        [_iconImageView setImage:image];
        [self layoutIfNeeded];
    }
    else
    {
        NSAssert(image != nil, @"图像传入为空");
    }
    
}
@end
