//
//  Tabbar_to_MainControl.h
//  sinaweibo
//
//  Created by Json on 14-6-1.
//  Copyright (c) 2014年 Json. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Tabbar_to_MainControl <NSObject>
-(void)SendButtonAction:(NSInteger)oldtag To:(NSInteger)newtag;
@end
