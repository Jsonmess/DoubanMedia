//
//  DMFilmCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMFilmCell : UICollectionViewCell
@property (nonatomic) UIImageView *filmImageView;//电影封面
@property (nonatomic) UILabel *filmName;//电影名称
@property (nonatomic) UIView *starRate;//星级
@property (nonatomic) UILabel *filmShowDate;//上映日期/暂无评分
//设置展示的内容
/**
  * filmPoster :电影封面
  *	title：电影名称
  * score ：电影评分
  * showdate: 上映日期（针对未上映电影）
  */
-(void)setContentWithFilmInfo:(NSURL *)filmPoster filmName:(NSString *)title score:(CGFloat)score willOnView:(NSString *)showdate;
@end
