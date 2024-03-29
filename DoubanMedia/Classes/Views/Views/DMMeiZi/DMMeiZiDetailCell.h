//
//  DMMeiZiDetailCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^loadImageSuccess)(UIImage * image);//用于返回图片资源
@interface DMMeiZiDetailCell : UICollectionViewCell
@property (nonatomic) UIImageView *theImageView;//展示妹纸图片

/**
 *  设置显示内容
 *
 *  @param theImage 图像
 */
-(void)setContentWithImage:(UIImage *)theImage;

/**
 *  设置显示内容
 *
 *  @param theImage 图像url
 */
-(void)setContentWithImageUrl:(NSString *)picUrl loadSuccess:(loadImageSuccess)sucess;
@end
