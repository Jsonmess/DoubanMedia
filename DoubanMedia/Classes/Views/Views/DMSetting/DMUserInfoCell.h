//
//  DMUserInfoCell.h
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol DMUserInfoCellDelegate <NSObject>

//登录状态
-(void)setRegisterStatus:(BOOL)isLogin;

@end

@interface DMUserInfoCell : BaseTableViewCell

@property(nonatomic,weak) id<DMUserInfoCellDelegate>delegate;
#pragma mark --actions
//设置内容
-(void)checkLoginInfo;

@end
