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
#import "DMMeiZiConstant.h"
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
    }
    return self;
}

-(void)reloadLocalResource
{
    NSArray *localClasses = @[@"所有妹纸",@"小清新",@"文艺",@"美腿",@"其他图片"];
    NSArray *localImages = @[@"allgirl.jpg",@"freshness1.jpg",@"wenyi.jpg",@"changtui.jpg"
                             ,@"others.jpg"];
    localMeiZiClasses = [NSMutableArray arrayWithArray:localClasses];
    localMeiZiImages = [NSMutableArray arrayWithArray:localImages];
    BOOL isZhaiNan = [[NSUserDefaults standardUserDefaults] boolForKey:@"ZhaiNanUser"];
    if (isZhaiNan)
    {
        [localMeiZiClasses addObject:@"美臀(已解锁)"];
        [localMeiZiImages addObject:@"meitun.jpg"];
        [localMeiZiClasses addObject:@"有沟(已解锁)"];
        [localMeiZiImages addObject:@"yougou.jpg"];
        [localMeiZiClasses addObject:@"福利(已解锁)"];
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
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMMeiZiClassCell * cell =(DMMeiZiClassCell*)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dic = @{
                          @"MeiZiUrl":[self getMeiZiUrlWithIndex:indexPath],
                          @"theClasses":[cell getTheCellTitle]
                          };
    [self.delegate meiZiView:self shouldLoadMeiZiClasses:dic];

}
#pragma mark----others
-(NSString *)getMeiZiUrlWithIndex:(NSIndexPath*)indexPath
{
    NSString *theUrl = @"";
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
                theUrl = MEIZI_ALL;
                break;
            case 1:
                theUrl = MEIZI_FRESH;
                break;
            case 2:
                theUrl = MEIZI_LITERATURE;
                break;
            case 3:
                theUrl = MEIZI_LEGS;
                break;
            case 4:
                theUrl = MEIZI_FUNNY;
                break;
            case 5:
                theUrl = MEIZI_CALLIPYGE;
                break;
            case 6:
                theUrl = MEIZI_CLEAVAGE;
                break;
            case 7:
                theUrl = MEIZI_RATING;
                break;

            default:
                break;
        }
    }
    return theUrl;
}

@end
