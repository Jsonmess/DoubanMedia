//
//  DMFilmInfoCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMFilmInfoCell : UITableViewCell
/** 电影海报url
 * 评分人数
 * 上映日期
 * 片长
 * 电影产地
 * 电影属性
 */
-(void)setContentWith:(NSURL*)posterUrl Score:(CGFloat)value RatingNumber:(NSInteger)number Pubdate:(NSString *)date
         filmDuration:(NSString *)duration filmLocate:(NSString*)locate filmProperty:(NSString *)property;
@end
