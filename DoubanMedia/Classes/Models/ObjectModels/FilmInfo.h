//
//  FilmInfo.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FilmInfo : NSManagedObject

@property (nonatomic, retain) NSString * filmTitle;
@property (nonatomic, retain) NSString * filmId;
@property (nonatomic, retain) NSString * filmCollection;
@property (nonatomic, retain) NSString * filmOrignal_title;
@property (nonatomic, retain) NSString * filmWish;
@property (nonatomic, retain) NSString * filmRating;
@property (nonatomic, retain) NSString * filmPubdate;
@property (nonatomic, retain) NSNumber * isNowShow;
@property (nonatomic, retain) NSString * filmLargeImage;
@property (nonatomic, retain) NSString * filmSmallImage;
@property (nonatomic, retain) NSString * location;
-(void)setFilmInfoDictionary:(NSDictionary *)dic filmStatus:(BOOL)isNowView;
@end
