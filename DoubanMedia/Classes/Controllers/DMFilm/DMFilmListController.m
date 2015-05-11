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
#import "JSWebViewController.h"
#import "MBProgressHUD+DMProgressHUD.h"
@interface DMFilmListController()<DMFilmListViewDelegate>
{
	DMFilmListView *filmListView;
    DMFilmListManager *theManager;
    MBProgressHUD *hud;
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
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"豆瓣电影列表页面"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"豆瓣电影列表页面"];
}
-(void)commonInit
{
    theManager = [[DMFilmListManager alloc] init];
}
-(void)getFilmInfoListWithType:(kFilmViewType)type
{
    //开始loading提示
    [hud removeFromSuperview];
 	hud= [MBProgressHUD showTextAndProgressViewIndicatorWithView:self.view Text:@"电影信息加载中..." Font:DMBoldFont(14.0f) Margin:10.0f];
    [filmListView setFilmHud:hud];
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
        [_segemtControl setTag:100];
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

    filmListView = [[DMFilmListView alloc] initWithFrame:self.view.bounds controller:self];
    [filmListView setDelegate:self];
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

#pragma mark ---filmListDelegate
-(void)filmListView:(DMFilmListView *)listView didSelectedfilmId:(NSString *)filmId
     												withFilmPoster:(UIImage *)image
          												filmTitle:(NSString *)filmName
{
    //这里直接接入浏览器
    [theManager getTheFilmInfoWithFilmId:filmId];
    NSString *urlStr = [NSString stringWithFormat:@"%@/subject/%@/mobile",DoubanFilmBaseUrl,filmId];
    NSURL *url = [NSURL URLWithString:urlStr];
    JSWebViewController *filmDetailController = [[JSWebViewController alloc]
                                                 initWithRequset:[NSURLRequest requestWithURL:url]];
    filmDetailController.shareEntity.urlString = urlStr;
    filmDetailController.shareEntity.shareImageData = UIImageJPEGRepresentation(image, 1.0f);
    filmDetailController.shareEntity.theTitle =[NSString stringWithFormat:@"推荐这部《%@》",filmName];
    [self presentViewController:filmDetailController animated:YES completion:nil];
}
@end
