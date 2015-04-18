//
//  DMFilmListView.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/16.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmListView.h"
#import "DMFilmCell.h"
#import "DMDeviceManager.h"
#define CellSpacingWidth
@interface DMFilmListView()<UICollectionViewDataSource,
                            UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *filmCollectionView;
@property (nonatomic) UIView *advertiseView;//广告位--预留
@end
@implementation DMFilmListView
-(instancetype)initWithFrame:(CGRect)frame
{
     self =[super initWithFrame:frame];
    if (self)
    {
        [self setUpView];
    }
    return self;
}

-(void)setUpView
{
    [self setBackgroundColor:DMColor(250,250,248,1.0f)];
    //广告位----ipad 不展示广告 、iphone展示
    if ([DMDeviceManager getCurrentDeviceType] != kiPad)
    {
        _advertiseView = [[UIView alloc] initWithFrame:CGRectZero];
        [_advertiseView setBackgroundColor:DMColor(244, 244, 244, 1.0f)];
        [self addSubview:_advertiseView];
        [_advertiseView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                 excludingEdge:ALEdgeBottom];
        [_advertiseView autoSetDimension:ALDimensionHeight toSize:40.0f];
    }
    //
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _filmCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    [_filmCollectionView setBackgroundColor:DMColor(250,250,248,1.0f)];
    [_filmCollectionView setDataSource:self];
    [_filmCollectionView setDelegate:self];
    CGFloat spacing ;
    switch ([DMDeviceManager getCurrentDeviceType])
    {
        case kiPad:
            spacing = 15.0f;
            break;

        default:
            spacing = 10.0f;
            break;
    }
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];

    [flowLayout setSectionInset:UIEdgeInsetsMake(10.0f, spacing, 10.0f, spacing)];
    CGFloat spaceWidth = 20.0f;
    CGFloat cellWidth = (ScreenBounds.size.width-spaceWidth*2-10*2.0f)/3;
    CGFloat cellHeight = cellWidth *5/3;
    [flowLayout setItemSize:CGSizeMake(cellWidth, cellHeight)];
    [flowLayout setMinimumLineSpacing:25.0f];
    [_filmCollectionView registerClass:[DMFilmCell class] forCellWithReuseIdentifier:@"filmCell"];

    [self addSubview:_filmCollectionView];
    if ([DMDeviceManager getCurrentDeviceType] != kiPad)
    {
        [_filmCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_advertiseView];
        [_filmCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0,kTabbarHeight,0)
                                                      excludingEdge:ALEdgeTop];
    }
    else
    {
        [_filmCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0,kTabbarHeight,0)];
    }
    [self layoutSubviews];
}

-(void)layoutSubviews
{
    [super layoutSubviews];

    NSLog(@"------------------%@",NSStringFromCGRect(_filmCollectionView.frame));
}
#pragma mark ------ UICollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 30;
}
-(DMFilmCell*)collectionView:(UICollectionView *)collectionView
              							  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMFilmCell *cell = [ collectionView dequeueReusableCellWithReuseIdentifier:@"filmCell" forIndexPath:indexPath];
    return cell;

}



@end
