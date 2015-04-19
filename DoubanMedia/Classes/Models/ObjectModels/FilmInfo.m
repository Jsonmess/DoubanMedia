//
//  FilmInfo.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "FilmInfo.h"


@implementation FilmInfo

@dynamic filmTitle;
@dynamic filmId;
@dynamic filmCollection;
@dynamic filmOrignal_title;
@dynamic filmWish;
@dynamic filmRating;
@dynamic filmPubdate;
@dynamic isNowShow; //记录是否为正在上映
@dynamic filmLargeImage;
@dynamic filmSmallImage;
@dynamic location; //记录定位
-(void)setFilmInfoDictionary:(NSDictionary *)dic filmStatus:(BOOL)isNowView
{
     self.filmRating = dic[@"rating"];
     self.filmPubdate = dic[@"pubdate"];
    NSDictionary *images = dic[@"images"];
    self.filmLargeImage = images[@"large"];
    self.filmSmallImage = images[@"medium"];
     self.filmId = dic[@"id"];
     self.filmTitle = dic[@"title"];
     self.filmCollection = dic[@"collection"];
     self.filmOrignal_title = dic[@"orignal_title"];
     self.filmWish = dic[@"wish"];
    self.location = @"北京";//暂时不用此属性--定位后期使用
    self.isNowShow = [NSNumber numberWithBool:isNowView];
}
@end
