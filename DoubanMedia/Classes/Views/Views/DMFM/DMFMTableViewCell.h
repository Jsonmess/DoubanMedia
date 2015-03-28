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
-(void)setCellContent:(NSString *)title isCurrentPlay:(BOOL)isPlay isDouBanRed:(BOOL)isRed;
@end
