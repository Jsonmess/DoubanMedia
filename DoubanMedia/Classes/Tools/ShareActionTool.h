//
//  ShareActionController.h
//  Camera360
//
//  Created by jsonmess on 15/2/2.
//  Copyright (c) 2015年 Pinguo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DMShareEntity;
@class PGHtmlActionSheet;

//分享图片的类型
enum ThumbnailType
{
    kThumbnailTypeJPG = 0,
    kThumbnailTypeJPEG,
    kThumbnailTypePNG
};
/**
 *  分享到第三方应用管理
 */
@interface ShareActionTool : NSObject
//初始化实例
-(instancetype)initWithSuperNavigationController:(UINavigationController *)naviController;
//传入分享内容
-(void)shareToThirdActionWithSuperView:(UIView *)view shareEntity:(DMShareEntity *)entity;

/**
 *  设置分享列表
 *
 *  @param titles
 */
- (void)setTitleOfShareAction:(NSArray *)titles;
@end
