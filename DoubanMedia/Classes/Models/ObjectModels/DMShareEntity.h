//
//  DMShareEntity.h
//  ShareDemo
//
//  Created by jsonmess on 15/4/26.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMShareEntity : NSObject
/**
 *  分享预设文字
 */
@property (nonatomic, strong) NSString *theTitle;
/**
 *  详细内容
 */
@property (nonatomic, strong) NSString *detailText;
/**
 *  分享链接
 */
@property (nonatomic, strong) NSString *urlString;
/**
 *  分享图片
 */
@property (nonatomic,strong) NSData *shareImageData;
/**
 *  分享传入的缩略图类型
 */
@property (nonatomic) enum ThumbnailType thumbnailType;
@end
