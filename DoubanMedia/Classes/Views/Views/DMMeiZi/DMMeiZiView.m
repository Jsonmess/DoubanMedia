//
//  DMMeiZiView.m
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiView.h"
#import "DMDeviceManager.h"
#import "DMMeiZiClassCell.h"
@interface DMMeiZiView()<UICollectionViewDelegate,UICollectionViewDataSource
										,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *localMeiZiClasses;//本地分类
    NSMutableArray *localMeiZiImages;//本地分类图片
}
@end
@implementation DMMeiZiView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
        [self reloadLocalResource];
    }
    return self;
}

-(void)reloadLocalResource
{
    NSArray *localClasses = @[@"所有妹纸",@"小清新",@"文艺",@"美腿",@"美臀",@"有沟",@"其他"];
    NSArray *localImages = @[@"allgirl.jpg",@"freshness1.jpg",@"wenyi.jpg",@"changtui.jpg"
                             ,@"meitun.jpg",@"yougou.jpg",@"others.jpg"];
    localMeiZiClasses = [NSMutableArray arrayWithArray:localClasses];
    localMeiZiImages = [NSMutableArray arrayWithArray:localImages];
    BOOL isZhaiNan = [[NSUserDefaults standardUserDefaults] boolForKey:@"ZhaiNanUser"];
    if (isZhaiNan)
    {
        [localMeiZiClasses addObject:@"宅男福利"];
		[localMeiZiImages addObject:@"fuli.jpg"];
    }
    [_collectionView reloadData];
}
-(void)setUpView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero
                                         collectionViewLayout:flowLayout];
    [_collectionView setAlwaysBounceVertical:YES];
    [_collectionView setBackgroundColor:DMColor(230,230,238,1.0f)];
    [_collectionView setDataSource:self];
    [_collectionView setDelegate:self];
    CGFloat spacing ;
    switch ([DMDeviceManager getCurrentDeviceType])
    {
        case kiPad:
            spacing = 15.0f;
            break;
        default:
            spacing = 5.0f;
            break;
    }
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [flowLayout setSectionInset:UIEdgeInsetsMake(10.0f, spacing, 10.0f, spacing)];
    CGFloat spaceWidth = 2.5f;
    CGFloat cellWidth = (ScreenBounds.size.width-spaceWidth*2-spacing*2.0f)/3;
    CGFloat cellHeight = cellWidth *7/5;
    [flowLayout setItemSize:CGSizeMake(cellWidth, cellHeight)];
    [flowLayout setMinimumLineSpacing:3.0f];
    [flowLayout setMinimumInteritemSpacing:spaceWidth];
    [_collectionView registerClass:[DMMeiZiClassCell class] forCellWithReuseIdentifier:@"meiZiCell"];
    [self addSubview:_collectionView];
    //contains
    [_collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, kTabbarHeight, 0)];
    [self setNeedsLayout];

}
#pragma mark-----UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return localMeiZiImages.count;
}
-(DMMeiZiClassCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMMeiZiClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"meiZiCell"
                                                                       forIndexPath:indexPath];

    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"localMeiZiImages" ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourcePath];
    NSString *path = [resourceBundle pathForResource:localMeiZiImages[indexPath.row] ofType:nil];

    UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //暂时写死从本地加载资源--保留网络图片接口
    [cell setContentWithImage:theImage theText:localMeiZiClasses[indexPath.row]];
    return cell;
}
@end
