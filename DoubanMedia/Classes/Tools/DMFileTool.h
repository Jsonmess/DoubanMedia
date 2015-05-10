//
//  DMFileTool.h
//  DoubanMedia
//
//  Created by jsonmess on 15/5/10.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^fileSizeBlock)(NSString * fileSize);
typedef void (^cleanFileBlock)();
@interface DMFileTool : NSObject
//计算沙盒中某个文件夹下文件大小
-(void )caculateFileSizeWithFilePath:(NSString *)filePath WithFileBlock:(fileSizeBlock)block;

//计算单个文件的大小
-(unsigned long long)fileSizeAtPath:(NSString *)filePath;
//删除某个文件夹下的所有文件
-(void)deleteAllFilesWithPath:(NSString *)path cleanFinished:(cleanFileBlock)cleanBlock;
@end
