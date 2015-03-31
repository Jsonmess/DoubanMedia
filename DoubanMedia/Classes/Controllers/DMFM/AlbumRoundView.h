//
//  ViewController.m
//  alumRound
//
//  Created by jsonmess on 15/3/31.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JingRoundViewDelegate <NSObject>

-(void) playStatuUpdate:(BOOL)playState;

@end

@interface AlbumRoundView : UIView

@property (assign, nonatomic) id<JingRoundViewDelegate> delegate;

//专辑图片
@property (strong, nonatomic) UIImage *roundImage;

//播放状态
@property (assign, nonatomic) BOOL isPlay;

//转速
@property (assign, nonatomic) float rotationDuration;


//开始播放
-(void) play;

//暂停
-(void) pause;

@end
