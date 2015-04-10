//
//  PGSysVolumeAjustManager.m
//  Pods
//
//  Created by jsonmess on 15/4/7.
//
//

#import "DMSysVolumeAjustManager.h"
#import <MediaPlayer/MediaPlayer.h>
@interface DMSysVolumeAjustManager()
{
    CGFloat lastSysVolumeValue;//记录调节之前上一次系统音量大小
    MPVolumeView *volumeView;//系统音量提示View
}
@end
@implementation DMSysVolumeAjustManager
//单例
+ (instancetype)sharedSysVolumeAjustManager
{
    static DMSysVolumeAjustManager *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[DMSysVolumeAjustManager alloc] init];
    });
    return shared;
}
//获取上一次音量值
-(CGFloat)getLastSysVolume
{
    return lastSysVolumeValue;
}
//将音量提示框添加到对应视图上----不添加则无法隐藏
-(void)addVolumeViewToCurrentView:(UIView *)superView
{
    volumeView = [[MPVolumeView alloc] init];
    [superView addSubview:volumeView];
    UISlider *volumeSlider;
    [volumeView setHidden:NO];
    volumeSlider = [self getVolumeViewFromMPVolumeView];
    //将其移除到屏幕之外
    [volumeView setFrame:CGRectMake(-1000, -100, 100, 100)];
    lastSysVolumeValue = volumeSlider.value;
}

//移除MPVolumeView

-(void)removeVolumeViewFromSuperView
{
    if (volumeView != nil)
    {
        [volumeView removeFromSuperview];
    }
}

//设置当前系统音量大小
-(void)setSysVolume:(CGFloat)value
{
    UISlider *volumeSlider = [self getVolumeViewFromMPVolumeView];
    [volumeSlider setValue:value animated:NO];
}

//找出音量控制slider
-(UISlider *)getVolumeViewFromMPVolumeView
{
    UISlider *slider;
    for (UIView *view in volumeView.subviews)
    {
        if ([view.class.description isEqualToString:@"MPVolumeSlider"])
        {
            slider=(UISlider *)view;
            break;
        }
    }
    return slider;
}
@end
