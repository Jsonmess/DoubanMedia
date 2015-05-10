//
//  PhotoTool.m
//  CameraDemo
//
//  Created by jsonmess on 14/12/6.
//  Copyright (c) 2014年 ios_share. All rights reserved.
//

#import "PhotoTool.h"
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
@implementation PhotoTool
#pragma mark-------创建单例
static PhotoTool *instance;
+(PhotoTool *)SharePhotoTool
{
    if (instance ==nil) {
        instance=[[PhotoTool alloc]init];
        
    }
    return instance;
}
+(id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance=[super allocWithZone:zone];
    });
    return instance;
}
/**
 *  保存相片到相册
 *
 *  @param imagedata 照片数据
 */
-(void)SavePhotoToAlAssetsLibraryWithImageData:(NSData*)imagedata
{
    //拿到stillimage的数据后存入系统相册
    ALAssetsLibrary *library=[[ALAssetsLibrary alloc]init];
    [library writeImageDataToSavedPhotosAlbum:imagedata metadata:@{@"author":@"jsonmess"} completionBlock:^(NSURL *assetURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                
                [[[UIAlertView alloc]initWithTitle:@"保存照片失败" message:@"请允许应用访问您的相册或者重试" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            }else
            {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"已保存到相册" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            }
        });
    }];

}
/**
 *  保存视频
 *
 *  @param url 视频临时输出文件地址
 */
-(void)SaveRecordVideoToToAlAssetsLibraryWithOutPutURL:(NSURL*)url
{
    //写入文件
    ALAssetsLibrary *library=[[ALAssetsLibrary alloc]init];
    [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [[[UIAlertView alloc]initWithTitle:@"抱歉" message:@"保存视频失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
                
            }else
            {
                [[[UIAlertView alloc]initWithTitle:@"提示" message:@"保存视频成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil]show];
            }
        });
    }];

}
@end
