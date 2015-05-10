//
//  PhotoTool.h
//  CameraDemo
//
//  Created by jsonmess on 14/12/6.
//  Copyright (c) 2014年 ios_share. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoTool : NSObject
+(PhotoTool *)SharePhotoTool;
//保存照片
-(void)SavePhotoToAlAssetsLibraryWithImageData:(NSData*)imagedata;
//保存视频
-(void)SaveRecordVideoToToAlAssetsLibraryWithOutPutURL:(NSURL*)url;
//截屏
- (UIImage *) captureCurrentScreen;
@end
