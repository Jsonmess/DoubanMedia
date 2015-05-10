//
//  DMMeiZiView.h
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMMeiZiView;
@protocol DMMeiZiViewDelegate <NSObject>

-(void)meiZiView:(DMMeiZiView*)theView shouldLoadMeiZiClasses:(NSDictionary *)source;
@end

@interface DMMeiZiView : UIView
@property(nonatomic) id<DMMeiZiViewDelegate>delegate;
//加载资源
-(void)reloadLocalResource;
@end
