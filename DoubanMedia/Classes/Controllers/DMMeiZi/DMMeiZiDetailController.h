//
//  DMMeiZiDetailController.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh/MJRefresh.h>
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>
#import "NYTPhotosViewController.h"
#import <UIActivityIndicator-for-SDWebImage/UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface DMMeiZiDetailController : UIViewController<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSString *douBanMeiZiSource;
@property (nonatomic, strong) NSString *theTitle;
@end
