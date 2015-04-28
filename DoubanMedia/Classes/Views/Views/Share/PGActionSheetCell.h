//
//  PGActionSheetCell.h
//  ShareToThirdDemo
//
//  Created by jsonmess on 15/2/6.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  CollectionViewCell 单个Html5分享控件
 */
@interface PGActionSheetCell : UICollectionViewCell
/**
 *  设置标题
 *
 *  @param title
 */
-(void)setShareIconTitle:(NSString *)title;
/**
 *  设置图标名
 *
 *  @param iconName
 */
-(void)setShareIconImageName:(NSString *)iconName;
@end
