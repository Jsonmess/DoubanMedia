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
-(void)filmListView:(DMFilmListView*)listView didSelectedIndex:(NSIndexPath*)indexPath;
@end
@interface DMFilmListView : UIView

@property (nonatomic) MBProgressHUD *filmHud;//指示器
@property (nonatomic) id<DMFilmListViewDelegate>delegate;

@end
