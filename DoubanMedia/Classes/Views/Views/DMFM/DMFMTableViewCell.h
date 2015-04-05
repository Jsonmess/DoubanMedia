//
//  DMFMTableViewCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface DMFMTableViewCell : BaseTableViewCell
//设置cell内容
-(void)setCellContent:(NSString *)title isDouBanRed:(BOOL)isRed;
-(void)isNowPlayChannel:(BOOL)isPlay;
//获取标题
-(NSString *)getTitle;
@end
