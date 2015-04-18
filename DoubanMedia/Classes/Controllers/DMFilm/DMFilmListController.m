//
//  DMFilmListController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/14.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListController.h"
#import "DMDeviceManager.h"
@interface DMFilmListController()
{
	DMFilmListView *filmListView;
}
@property (nonatomic) UISegmentedControl *segemtControl;
@end
@implementation DMFilmListController
-(void)viewDidLoad
{
    [super viewDidLoad];

    [self setUpView];
}

-(void)setUpView
{
    // 设置导航栏
    if(!_segemtControl)
    {
        NSArray *array = @[@"正在热映",@"即将上映"];
        _segemtControl = [[UISegmentedControl alloc] initWithItems:array];
        [_segemtControl setSegmentedControlStyle:UISegmentedControlStyleBar];
        [_segemtControl setFrame:CGRectZero];
        [_segemtControl setSelectedSegmentIndex:0];
        CGFloat theWidth =self.navigationController.navigationBar.bounds.size.width;
        [_segemtControl setFrame:CGRectMake(theWidth*3/10, 8.0f, theWidth*2/5, 28.0f)];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    [self.navigationController.navigationBar addSubview:_segemtControl];

    filmListView = [[DMFilmListView alloc] initWithFrame:self.view.bounds];
    self.view = filmListView;
}

@end
