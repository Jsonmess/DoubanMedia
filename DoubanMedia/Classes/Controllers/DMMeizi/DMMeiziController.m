//
//  DMMeiziController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/23.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiziController.h"

@interface DMMeiziController ()<UIScrollViewDelegate>
{
    NSArray *sourceArray;//分类
    NSMutableArray *sourceBtns;
    UIView *indicatorLine;//指示线
}
@property (nonatomic)UIScrollView *classifiedView;//分类
@property (nonatomic)UIView *mainView;//主视图
@end

@implementation DMMeiziController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    [self setUpView];

    // Do any additional setup after loading the view.
}
-(void)commonInit
{
    sourceArray = @[@"所有妹纸",@"小清新",@"文艺",@"性感",@"尺度",@"美臀"];
    sourceBtns = [NSMutableArray array];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;

        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
}
-(void)setUpView
{
    [self setTitle:@"豆瓣妹纸"];
    _classifiedView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [_classifiedView setUserInteractionEnabled:YES];
    [self.view addSubview:_classifiedView];
    if (sourceBtns.count > 0)
    {
        [sourceBtns removeAllObjects];
    }
    for (NSString *theType in sourceArray)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:theType forState:UIControlStateNormal];
        [button setTitle:theType forState:UIControlStateHighlighted];
        [_classifiedView addSubview:button];
        [button setBackgroundColor:[UIColor blueColor]];
        [sourceBtns addObject:button];
    }
    //主视图
    _mainView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:_mainView];
    [_mainView setBackgroundColor:[UIColor redColor]];
    [self setContains];
}

-(void)setContains
{
    [_classifiedView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [_classifiedView autoSetDimension:ALDimensionHeight toSize:44.0f];
    CGFloat spacing = 15.0f;
    [_classifiedView setContentOffset:CGPointMake((80.0f+spacing)*sourceBtns.count-spacing, 0) animated:YES];
    [sourceBtns autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:spacing insetSpacing:YES];
    [sourceBtns.firstObject autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_classifiedView];
    //主视图
    [_mainView autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.view];
    [_mainView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.view];
    [_mainView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view withOffset:kTabbarHeight];
    [_mainView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_classifiedView];
    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
