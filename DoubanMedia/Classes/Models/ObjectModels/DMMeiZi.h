//
//  DMMeiZi.h
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NYTPhoto.h"
@interface DMMeiZi : NSObject <NYTPhoto>
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSString *gtopic_id;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *user;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *selected;

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *placeholderImage;
@property (nonatomic) NSAttributedString *attributedCaptionTitle;
@property (nonatomic) NSAttributedString *attributedCaptionSummary;
@property (nonatomic) NSAttributedString *attributedCaptionCredit;
@property (nonatomic, strong) NSString *path;
@end
