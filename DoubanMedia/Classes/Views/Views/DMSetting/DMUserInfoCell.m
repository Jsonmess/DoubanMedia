//
//  DMUserInfoCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMUserInfoCell.h"
@interface DMUserInfoCell()
{
    UIButton *userIcon;//用户图标
    UILabel *userName;//用户名称
    UIImageView *listenIcon;//收听
    UILabel *listenLikeNum;//收听数量
    UIImageView *likeIcon;//喜欢
    UILabel *likeNum;//红心数
    UIImageView *disLikeIcon;//删除
    UILabel *disLikeNum;//删除数量

}
@end
@implementation DMUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {

    }
    return self;
}

-(void)setUpView
{
    userIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    [userIcon addTarget:self action:@selector(loginInOrLoginOut) forControlEvents:DMUIControlStateAll];

}
#pragma mark --actions
//登录+注销
-(void)loginInOrLoginOut
{

}
@end
