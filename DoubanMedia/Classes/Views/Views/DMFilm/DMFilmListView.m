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

    
    [self setViewContains];

}

-(void)setViewContains
{

    [_filmCollectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0,kTabbarHeight,0)];
    [self layoutSubviews];
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
