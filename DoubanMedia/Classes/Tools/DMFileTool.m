//
//  DMFileTool.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/10.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFileTool.h"
@interface DMFileTool()
{
    NSFileManager *fileManager;
}
@end
@implementation DMFileTool
-(instancetype)init
{
    self = [super init];
    if (self)
    {
        fileManager=[NSFileManager defaultManager];
    }
    return self;
}
/**
 * 计算文件大小
 *
 *  @param filePath 文件路径
 *
 */
-(void )caculateFileSizeWithFilePath:(NSString *)filePath WithFileBlock:(fileSizeBlock)block
{
    if ([fileManager fileExistsAtPath:filePath])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSEnumerator *enumerator=[[fileManager subpathsAtPath:filePath] objectEnumerator];
            NSString *fileName;
            unsigned long long fileSize=0;
            while (fileName=[enumerator nextObject]) {
                NSString *fileNameAbs=[filePath stringByAppendingPathComponent:fileName];
                fileSize+=[self fileSizeAtPath:fileNameAbs];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fileSize <= 0.4*1024*1024)
                {
                    block(nil);
                }else
                {
                    NSString * fileSizeStr=[NSString stringWithFormat:@"%.2fM",fileSize/1024.0/1024.0];
                    block(fileSizeStr);
                }
            });
        });
    }
}
//计算单个文件大小
-(unsigned long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager *manager=[NSFileManager defaultManager];
    if([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//删除某个文件夹下的所有文件
-(void)deleteAllFilesWithPath:(NSString *)path cleanFinished:(cleanFileBlock)cleanBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSFileManager *manager=[NSFileManager defaultManager];
        NSEnumerator *enumerator=[[fileManager subpathsAtPath:path] objectEnumerator];
        NSString *fileName;
        while (fileName=[enumerator nextObject])
        {
            NSString *fileNameAbs=[path stringByAppendingPathComponent:fileName];
            [manager removeItemAtPath:fileNameAbs error:nil];
        }
        //主线程更新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            cleanBlock();
        });
    });
}
@end
