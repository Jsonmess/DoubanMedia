//
//  JSStarRating.h
//  starRatingDemo
//
//  Created by jsonmess on 15/4/17.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSStarRating : UIImageView
//计算显示的分数
-(void)showStarbyRatingValueWithRatingValue:(CGFloat)value;
//重新计算布局
-(void)shouldSetContainsWithWidth:(CGFloat)width;
@end
