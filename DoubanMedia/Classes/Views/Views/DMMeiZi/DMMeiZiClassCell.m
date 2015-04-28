//
//  DMMeiZiClassCell.m
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiClassCell.h"
#import <UIImageView+WebCache.h>
#import "DMDeviceManager.h"
@interface DMMeiZiClassCell()
{
    UIImageView *meiZiClassImageView;//图片
    UILabel *theClassText;//标签
}
@end
@implementation DMMeiZiClassCell

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
    [self setBackgroundColor:DMColor(220, 220, 220, 0.7f)];
    meiZiClassImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [meiZiClassImageView setContentMode:UIViewContentModeScaleAspectFill];
    [meiZiClassImageView setClipsToBounds:YES];
    [self addSubview:meiZiClassImageView];
    theClassText = [[UILabel alloc] initWithFrame:CGRectZero];
    [theClassText setBackgroundColor:DMColor(0, 0, 0, 0.4f)];
    UIFont *font;
    CGFloat height;
    switch ([DMDeviceManager getCurrentDeviceType])
    {
        case kiPad:
            font = DMFont(15.0f);
            height = 40.0f;
            break;

        default:
             font = DMFont(12.0f);
            height = 20.0f;
            break;
    }
    [theClassText setFont:font];
    [theClassText setTextAlignment:NSTextAlignmentLeft];
    [theClassText setTextColor:[UIColor whiteColor]];
    [self addSubview:theClassText];
	//contains
    [meiZiClassImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(2.5f, 2, 2.5, 2)];
    [theClassText autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(2.5f, 2, 2.5, 2) excludingEdge:ALEdgeTop];
    [theClassText autoSetDimension:ALDimensionHeight toSize:height];
    [self setNeedsLayout];
}
/**
 *  设置显示内容
 *
 *  @param theImage 图像
 *  @param theTitle 标题
 */
-(void)setContentWithImage:(UIImage *)theImage theText:(NSString *)theTitle
{
    NSAssert(theImage != nil, @"传入图像不可以为空");
    [meiZiClassImageView setImage:theImage];
    if (theTitle == nil)
    {
        theTitle = @"";
    }
    theTitle = [NSString stringWithFormat:@"   %@",theTitle];
    [theClassText setText:theTitle];
}
/**
 *  设置显示内容
 *
 *  @param theImage 图像url
 *  @param theTitle 标题
 */
-(void)setContentWithImageUrl:(NSString *)picUrl theText:(NSString *)theTitle
{
    NSAssert(picUrl != nil, @"传入图像地址不可以为空");
    [meiZiClassImageView sd_setImageWithURL:[NSURL URLWithString:picUrl]
                           placeholderImage:nil
                                    options:SDWebImageLowPriority|SDWebImageRetryFailed];
    if (theTitle == nil)
    {
        theTitle = @"";
    }
    theTitle = [NSString stringWithFormat:@"   %@",theTitle];
    [theClassText setText:theTitle];
}
@end
