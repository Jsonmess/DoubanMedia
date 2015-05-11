//
//  DMFilmListView.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD+DMProgressHUD.h"
@class  DMFilmListView;
@protocol DMFilmListViewDelegate <NSObject>
-(void)filmListView:(DMFilmListView*)listView
  didSelectedfilmId:(NSString *)filmId
     withFilmPoster:(UIImage *)image
          filmTitle:(NSString*)filmName;
@end
@interface DMFilmListView : UIView

@property (nonatomic) MBProgressHUD *filmHud;//指示器
@property (nonatomic,weak) id<DMFilmListViewDelegate>delegate;
//初始化
-(instancetype)initWithFrame:(CGRect)frame controller:(id)controller;
@end
