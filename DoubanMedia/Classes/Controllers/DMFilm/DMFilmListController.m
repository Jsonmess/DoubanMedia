//
//  DMFilmListController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/14.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListController.h"
@interface DMFilmListController()
{
	DMFilmListView *filmListView;
}
@end
@implementation DMFilmListController
-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpView];
}

-(void)setUpView
{
    [self setTitle:@"豆瓣电影"];
    filmListView = [[DMFilmListView alloc] initWithFrame:self.view.bounds];
    self.view = filmListView;
}

@end
