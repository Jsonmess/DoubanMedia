//
//  Tabbar_view.h
//  sinaweibo
//
//  Created by Json on 14-5-31.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tabbar_to_MainControl.h"
@interface Tabbar_view : UIView

@property(assign,nonatomic)  NSInteger _buttons_count;
@property (strong,nonatomic)id<Tabbar_to_MainControl>delegate;
-(void)setBackground_image:(NSString*)background_image;
- (void)AddButtonWith:(NSString *)title NomalImage:(NSString *)nomal_image SelectedImage:(NSString *)selected_image;
+(id)ShareTabbar_view;
@end
