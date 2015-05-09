//
//  DMUserInfoCell.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMUserInfoCell.h"
#import "DMUserSubInfoView.h"
#import "DMDeviceManager.h"
#import "AccountInfo.h"
#import <UIImageView+WebCache.h>
@interface DMUserInfoCell()
{
    UIImageView *userIcon;//用户图标
    UILabel *userName;//用户名称
    DMUserSubInfoView *listenView;//收听
   	DMUserSubInfoView *likeView;//红心
    DMUserSubInfoView *disLikeView;//删除

    BOOL userIsLogin;//是否已经登录
}
@end
@implementation DMUserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self setUpView];
        [self checkLoginInfo];
    }
    return self;
}

-(void)setUpView
{
    //用户图标
    userIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [userIcon setUserInteractionEnabled:YES];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(loginInOrLoginOut)];
    [userIcon addGestureRecognizer:gesture];
    [userIcon setImage:[UIImage imageNamed:@"user_normal"]];
    [userIcon setClipsToBounds:YES];
    [userIcon setContentMode:UIViewContentModeScaleAspectFill];
	//用户名称
    userName = [[UILabel alloc] initWithFrame:CGRectZero];
    [userName setText:@"点击登录"];
    [userName setTextAlignment:NSTextAlignmentCenter];
    [userName setFont:DMBoldFont(15.0f)];
    [userName setTextColor: DMColor(130, 132, 132, 1.0f)];
    [self.contentView addSubview:userIcon];
    [self.contentView addSubview:userName];

    //用户详情
    listenView = [[DMUserSubInfoView alloc] initWithFrame:CGRectZero];
    likeView = [[DMUserSubInfoView alloc] initWithFrame:CGRectZero];
    disLikeView = [[DMUserSubInfoView alloc] initWithFrame:CGRectZero];
    [listenView.getImageView setImage:[UIImage imageNamed:@"Nav_play"]];
    [likeView.getImageView setImage:[UIImage imageNamed:@"ic_player_fav_selected"]];
    [disLikeView.getImageView setImage:[UIImage imageNamed:@"ic_player_ban_highlight"]];
    [self.contentView addSubview:listenView];
    [self.contentView addSubview:likeView];
    [self.contentView addSubview:disLikeView];

    [self setContains];
}

//约束
-(void)setContains
{
    //用户图标
    [userIcon autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [userIcon autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f];
    CGFloat userIconWidth = ScreenBounds.size.width*0.26f;
    [userIcon autoSetDimension:ALDimensionWidth toSize:userIconWidth];
    [userIcon autoSetDimension:ALDimensionHeight toSize:userIconWidth];
    [userIcon.layer setCornerRadius:userIconWidth*0.5f];
	//用户名称
    [userName autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.contentView];
    [userName autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.contentView];
    [userName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userIcon withOffset:10.0f];
    //用户详情
    NSArray * subInfoView = @[listenView,likeView,disLikeView];
    CGFloat spacingValue = ScreenBounds.size.width *1/6;
    [subInfoView autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal
                                withFixedSize:spacingValue insetSpacing:YES];
       [listenView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f];
}
#pragma mark --actions
//设置内容
-(void)checkLoginInfo
{
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextWithParent:[NSManagedObjectContext
                                                                                    MR_defaultContext]];
    NSArray *users = [AccountInfo MR_findAllInContext:context];
    if (users.count > 0)
    {
         userIsLogin = YES;
         AccountInfo *userInfo = users.firstObject;
        //设置
        NSString *userImageUrl = [NSString stringWithFormat:@"%@%@.jpg",
                                  UserAccountIconUrl,userInfo.userId];
        [userIcon sd_setImageWithURL:[NSURL URLWithString:userImageUrl]
                    placeholderImage:[UIImage imageNamed:@"user_normal"]
                             options:SDWebImageLowPriority|SDWebImageRetryFailed];
        [userName setText:userInfo.name];
        [listenView.getInfoTextLabel setText:userInfo.played];
        [likeView.getInfoTextLabel setText:userInfo.liked];
        [disLikeView.getInfoTextLabel setText:userInfo.banned];
        [self setNeedsLayout];
    }
    else
    {
        userIsLogin = NO;
        [userIcon setImage:[UIImage imageNamed:@"user_normal"]];
        [userName setText:@"点击登录"];
        [listenView.getInfoTextLabel setText:@"0"];
        [likeView.getInfoTextLabel setText:@"0"];
        [disLikeView.getInfoTextLabel setText:@"0"];
    }
}
//登录+注销
-(void)loginInOrLoginOut
{
    [self.delegate setRegisterStatus:userIsLogin];
}
@end
