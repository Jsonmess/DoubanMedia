//
//  DMFMUserHeaderView.h
//  DoubanMedia
//
//  Created by jsonmess on 15/3/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FMUserHeaderDelegate<NSObject>
//点击登录
-(void)actionForLogin;
@end
@interface DMFMUserHeaderView : UIView
@property (nonatomic) id <FMUserHeaderDelegate>delegate;
-(void)setHeadViewContent:(NSString *)title Image:(UIImage *)image;
@end
