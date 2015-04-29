//
//  DMMeiZiDetailCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiDetailCell.h"
#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@implementation DMMeiZiDetailCell
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
    _theImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self setBackgroundColor:DMColor(25, 25, 25, 1.0f)];
    [self addSubview:_theImageView];
    [_theImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self setNeedsLayout];
}

/**
 *  设置显示内容
 *
 *  @param theImage 图像
 */
-(void)setContentWithImage:(UIImage *)theImage
{
    NSAssert(theImage != nil, @"传入图像不可以为空");
    [_theImageView setImage:theImage];
    [_theImageView autoSetDimensionsToSize:theImage.size];
    [self setNeedsLayout];
}
/**
 *  设置显示内容
 *
 *  @param theImage 图像url
 */
-(void)setContentWithImageUrl:(NSString *)picUrl loadSuccess:(loadImageSuccess)sucess
{
    NSAssert(picUrl != nil, @"传入图像地址不可以为空");
    __weak DMMeiZiDetailCell *weakSelf = self;
    [_theImageView setImageWithURL:[NSURL URLWithString:picUrl]
                         completed:^(UIImage *image, NSError *error,
                                     SDImageCacheType cacheType, NSURL *imageURL)
   		 {
             sucess(image);
        }	usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [weakSelf setNeedsLayout];

}
@end
