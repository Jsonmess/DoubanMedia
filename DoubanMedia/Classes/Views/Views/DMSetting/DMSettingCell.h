//
//  DMSettingCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/5/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
@interface DMSettingCell : BaseTableViewCell
/**
 *  设置cell 内容
 *
 *  @param title      标题
 *  @param subtitle   子标题
 *  @param showSwitch 是否显示开关控件
 *  @param showArrows 是否有扩展子视图
 */
-(void)setContentsWithTitle:(NSString *)title
                   subTitle:(NSString *)subtitle
         isShouldShowSwitch:(BOOL)showSwitch
                 haveArrows:(BOOL)showArrows;
@end
