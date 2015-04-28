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
#import "DMMeiZiDetailCell.h"

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
- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _douBanMeiZiSource = MEIZI_ALL;
        _page = 0;
        _meiziArray = [[NSMutableArray alloc] init];
        sourceManager = [[DMMeiZiManager alloc] init];
        [sourceManager setDelegate:self];
        [self setupView];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupHeaderAndFooter];
    [self refreshMeizi];
}

- (void)setupView
{
    UICollectionViewFlowLayout *tempLayout = [[UICollectionViewFlowLayout alloc] init];
    NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)tempLayout;
    layout.minimumLineSpacing = 1.0;
    layout.minimumInteritemSpacing = 1.0;
    layout.sectionInset = UIEdgeInsetsZero;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.collectionView registerClass:[DMMeiZiDetailCell class] forCellWithReuseIdentifier:@"MeiziCell"];
    [self.view addSubview:_collectionView];

}

- (void)setupHeaderAndFooter
{
//    [self.collectionView addLegendHeaderWithRefreshingTarget:self
//                                            refreshingAction:@selector(refreshMeizi)];
//    [self.collectionView addLegendFooterWithRefreshingTarget:self
//                                            refreshingAction:@selector(loadMoreMeizi)];
//    self.collectionView.footer.automaticallyRefresh = NO;
//    self.collectionView.footer.hidden = YES;
//    self.collectionView.header.textColor = [UIColor whiteColor];
//    self.collectionView.footer.textColor = [UIColor whiteColor];
//    [self.collectionView.header beginRefreshing];
}

- (void)refreshMeizi
{
    _page = 0;
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

- (DMMeiZiDetailCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMMeiZiDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MeiziCell" forIndexPath:indexPath];

    DMMeiZi *meizi = _meiziArray[indexPath.row];

    [cell setContentWithImageUrl:meizi.path];

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
    NYTPhotosViewController *photoViewController = [[NYTPhotosViewController alloc] initWithPhotos:_meiziArray initialPhoto:meizi];
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
#pragma mark ---DMMeiZiManagerDelegate

-(void)getDataStatus:(kGetDataStatus)status
{
    switch (status)
    {
        case kGetDataStatusFaild:
            
            break;

        case kGetDataStatusError:

            break;
        default:

        break;
    }
}
@end
