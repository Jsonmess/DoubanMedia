//
//  DMFilmListController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/14.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListController.h"
#import "DMDeviceManager.h"
#import "DMFilmListManager.h"
@interface DMFilmListController()
{
	DMFilmListView *filmListView;
    DMFilmListManager *theManager;
}
@property (nonatomic) UISegmentedControl *segemtControl;
@end
@implementation DMFilmListController
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    [self setUpView];
}

-(void)commonInit
{
    theManager = [[DMFilmListManager alloc] init];
}
-(void)getFilmInfoListWithType:(kFilmViewType)type
{
    [theManager getFilmList:type];
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
        [_segemtControl addTarget:self action:@selector(changeGetFilmInfoList) forControlEvents:UIControlEventValueChanged];
        CGFloat theWidth =self.navigationController.navigationBar.bounds.size.width;
        [_segemtControl setFrame:CGRectMake(theWidth*3/10, 8.0f, theWidth*2/5, 28.0f)];
        [self.navigationController.navigationBar addSubview:_segemtControl];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }

    filmListView = [[DMFilmListView alloc] initWithFrame:self.view.bounds];
    [theManager setDelegate:(id)filmListView];
    self.view = filmListView;

    [self getFilmInfoListWithType:kFilmOnView];//开始获取数据
}

#pragma mark ----actions
-(void)changeGetFilmInfoList
{
    switch (_segemtControl.selectedSegmentIndex)
    {
        case 0:
            [self getFilmInfoListWithType:kFilmOnView];
            break;
            case 1:
            [self getFilmInfoListWithType:kFilmWillView];
            break;
        default:
            break;
    }
}

@end
