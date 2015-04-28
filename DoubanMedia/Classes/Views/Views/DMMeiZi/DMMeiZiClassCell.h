//
//  DMMeiZiClassCell.h
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMMeiZiClassCell : UICollectionViewCell
/**
 *  设置显示本地内容
 *
 *  @param theImage 图像
 *  @param theTitle 标题
 */
-(void)setContentWithImage:(UIImage *)theImage theText:(NSString *)theTitle;

/**
 *  设置显示内容
 *
 *  @param theImage 网络图像url
 *  @param theTitle 标题
 */
-(void)setContentWithImageUrl:(NSString *)picUrl theText:(NSString *)theTitle;
@end
