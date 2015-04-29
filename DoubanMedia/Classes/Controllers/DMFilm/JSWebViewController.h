//
//  JSWebViewController.h
//  JSWebViewController
//
//  Created by jsonmess on 15/4/21.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMShareEntity.h"
@interface JSWebViewController : UIViewController
@property(nonatomic) DMShareEntity *shareEntity;//用于电影分享
-(instancetype)initWithRequset:(NSURLRequest *)request;
@end
