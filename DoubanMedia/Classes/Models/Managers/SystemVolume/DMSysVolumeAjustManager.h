//
//  DMSysVolumeAjustManager.h
//  Pods
//
//  Created by jsonmess on 15/4/7.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
 /*
  *用于获取和设置 系统媒体音量
  */
@interface DMSysVolumeAjustManager : NSObject

+ (instancetype)sharedSysVolumeAjustManager;
//将音量提示框添加到对应视图上----不添加则无法隐藏
-(void)addVolumeViewToCurrentView:(UIView *)superView;
//移除MPVolumeView
-(void)removeVolumeViewFromSuperView;
//设置系统音量
-(void)setSysVolume:(CGFloat)value;
//获取音量滑动控件
-(UISlider *)getVolumeViewFromMPVolumeView;
//获取上一次音量值
-(CGFloat)getLastSysVolume;
@end
