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
-(void)SavePhotoToAlAssetsLibraryWithImageData:(NSData*)imagedata;
-(void)SaveRecordVideoToToAlAssetsLibraryWithOutPutURL:(NSURL*)url;
@end
