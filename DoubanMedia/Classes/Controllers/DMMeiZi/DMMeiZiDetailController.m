//
//  DMMeiZiDetailController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/28.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiDetailController.h"
#import "DMMeiZiConstant.h"
#import "DMMeiZiManager.h"
#import "DMMeiZi.h"
#import "TabViewManager.h"
#import "DMMeiZiDetailCell.h"
#import "MBProgressHUD+DMProgressHUD.h"

@interface DMMeiZiDetailController() < NYTPhotosViewControllerDelegate,DMMeiZiManagerDelegate,
UICollectionViewDelegate,UICollectionViewDataSource
,NHBalancedFlowLayoutDelegate>
{
    DMMeiZiManager *sourceManager;
}
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSMutableArray *meiziArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation DMMeiZiDetailController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupHeaderAndFooter];
    //隐藏tabBar
    [[TabViewManager sharedTabViewManager].getTabView setHidden:YES];
    [MobClick beginLogPageView:@"豆瓣妹纸详情页面"];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"豆瓣妹纸详情页面"];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self commonInit];
    [self setupView];
}
-(void)commonInit
{
    _page = 0;
    _meiziArray = [[NSMutableArray alloc] init];
    sourceManager = [[DMMeiZiManager alloc] init];
    [sourceManager setDelegate:self];

}
- (void)setupView
{
    //设置导航栏
    _theTitle = [_theTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
    [self setTitle:_theTitle];
    //设置左边状态栏
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;

    NHBalancedFlowLayout *layout = [[NHBalancedFlowLayout alloc] init];
    layout.minimumLineSpacing = 1.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.sectionInset = UIEdgeInsetsMake(5.0f, 0, 5.0f, 0);
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView setBackgroundColor:DMColor(230,230,238,1.0f)];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];

    [self.collectionView registerClass:[DMMeiZiDetailCell class] forCellWithReuseIdentifier:@"MeiziCell"];
    [self.view addSubview:_collectionView];

}

- (void)setupHeaderAndFooter
{
    [self.collectionView addLegendHeaderWithRefreshingTarget:self
                                            refreshingAction:@selector(refreshMeizi)];
    [self.collectionView addLegendFooterWithRefreshingTarget:self
                                            refreshingAction:@selector(loadMoreMeizi)];
    self.collectionView.footer.automaticallyRefresh = NO;
    self.collectionView.footer.hidden = YES;

    [self.collectionView.header beginRefreshing];
}

- (void)refreshMeizi
{
    _page = 0;
    if (_douBanMeiZiSource == nil)
    {
        return;
    }
    [sourceManager getMeiziWithUrl:_douBanMeiZiSource page:_page
                        completion:^(NSArray *meiziArray, NSInteger nextPage)
     {
         if (meiziArray.count > 0)
         {
             [_meiziArray removeAllObjects];
             [_meiziArray addObjectsFromArray:meiziArray];
             _page = nextPage;
             [self.collectionView.footer resetNoMoreData];
             [self.collectionView reloadData];
         }else
         {
             [self.collectionView.footer noticeNoMoreData];
         }
         [self.collectionView.header endRefreshing];
     }];
}

- (void)loadMoreMeizi
{
    [sourceManager getMeiziWithUrl:_douBanMeiZiSource page:_page
                        completion:^(NSArray *meiziArray, NSInteger nextPage) {
                            if (meiziArray.count > 0) {
                                [_meiziArray addObjectsFromArray:meiziArray];
                                _page = nextPage;
                                [self.collectionView reloadData];
                            } else {
                                [self.collectionView.footer noticeNoMoreData];
                            }
                            [self.collectionView.footer endRefreshing];
                        }];
}

#pragma mark CollectionView DataSource && Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    collectionView.footer.hidden = (_meiziArray.count == 0);
    return _meiziArray.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMMeiZi *meizi = _meiziArray[indexPath.row];
    CGSize size = CGSizeMake([meizi width].integerValue, [meizi height].integerValue);
    return size;
}

- (DMMeiZiDetailCell *)collectionView:(UICollectionView *)collectionView
               cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMMeiZiDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell"
                                                                        forIndexPath:indexPath];

    DMMeiZi *meizi = _meiziArray[indexPath.row];

    [cell setContentWithImageUrl:meizi.path
                     loadSuccess:^(UIImage *image)
     {
         meizi.image = image;
     }];

    return cell;
}

#pragma mark 点击CollectionViewCell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DMMeiZiDetailCell *selectedCell = (DMMeiZiDetailCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (!selectedCell.theImageView.image)
    {
        return;
    }
    DMMeiZi *meizi = _meiziArray[indexPath.row];
    NYTPhotosViewController *photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:_meiziArray
                                                                                      initialPhoto:meizi];
    shouldHiddenStatusBar(YES);
    photoViewController.delegate = self;
    [self presentViewController:photoViewController animated:YES completion:nil];
}

#pragma mark PhotoViewController显示图片
- (void)photosViewController:(NYTPhotosViewController *)photosViewController
             didDisplayPhoto:(id<NYTPhoto>)photo atIndex:(NSUInteger)photoIndex
{
    DMMeiZi *meizi = (DMMeiZi *)photo;
    if (!meizi.image) {
        [[SDWebImageManager sharedManager]
         downloadImageWithURL:[NSURL URLWithString:meizi.path]
         options:8|9
         progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {}
         completed:^(UIImage *image, NSError *error,
                     SDImageCacheType cacheType,
                     BOOL finished, NSURL *imageURL)
         {
             meizi.image = image;
             [photosViewController updateImageForPhoto:meizi];
         }];
    }

}

- (UIView *)photosViewController:(NYTPhotosViewController *)photosViewController
           referenceViewForPhoto:(id<NYTPhoto>)photo
{
    DMMeiZiDetailCell *cell = (DMMeiZiDetailCell *)[self.collectionView
                                                    cellForItemAtIndexPath:[NSIndexPath
                                                           indexPathForRow:[_meiziArray indexOfObject:photo]
                                                                 inSection:0]];
    return cell;
}
-(void)photosViewControllerWillDismiss:(NYTPhotosViewController *)photosViewController
{
    shouldHiddenStatusBar(NO);
}
#pragma mark ---DMMeiZiManagerDelegate

-(void)getDataStatus:(kGetDataStatus)status
{

    switch (status)
    {
        case kGetDataStatusFaild:

            [MBProgressHUD showTextOnlyIndicatorWithView:self.view
                                                    Text:@"您的网络不给力噢" Font:DMFont(12.0f)
                                                  Margin:12.0f  offsetY:ScreenBounds.size.height*0.2f
                                                showTime:1.5f];
            break;

        case kGetDataStatusError:
            [MBProgressHUD showTextOnlyIndicatorWithView:self.view
                                                    Text:@"请求失败，请您检查网络" Font:DMFont(12.0f)
                                                  Margin:12.0f  offsetY:ScreenBounds.size.height*0.2f
                                                showTime:1.5f];

            break;
        default:

            break;
    }
}
#pragma mark --- otherActions

-(void)backToList
{
    [[TabViewManager sharedTabViewManager].getTabView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
