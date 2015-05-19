//
//  PGHtmlActionSheet.m
//  ShareToThirdDemo
//
//  Created by jsonmess on 15/2/5.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "PGHtmlActionSheet.h"
#import "PGActionSheetCell.h"
#import "UIImage+DMImage.h"
#import "DMDeviceManager.h"
#define kActionViewHeight 150.0f
#define kCollectionCellResuse @"shareReuse"
#define kScreenBounds         [UIScreen mainScreen].bounds
#define kShareActionSize	  CGSizeMake(55.0f, 65.0f)
#define k_chancelButtonSize        CGSizeMake(self.bounds.size.width,35.0f)

@interface PGHtmlActionSheet()<UICollectionViewDataSource,UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;//排列分享控件
    
    UIView *_shadeView;//遮罩层
    UIView *_ActionView;//主功能view
    UIButton *_cancelButton;//取消返回
    UIView *_lineView;
    NSInteger _shareActionNumber;
    NSLayoutConstraint *_ActionViewConstraint;
    UICollectionViewFlowLayout *_flowLayout;
    
    //数据源
    NSArray *_titleArray;//控件标题数组
    NSArray *_iconNameArray;//控件图标文件名数组
}
@end
@implementation PGHtmlActionSheet
#pragma mark ---PGActionSheet 初始化

-(instancetype)initPGActionSheetWithFrame:(CGRect)frame withOnePageCellNumber:(NSInteger)number
{
    if (self = [super initWithFrame:frame])
    {
        
        _shareActionNumber = number;
        [self setUpView];
        [self setSubViewFrame];
        [self setAlpha:0.f];
    }
    return self;
}

-(void)setUpView
{
    //遮罩层
    if (_shadeView == nil)
    {
        _shadeView = [[UIView alloc] initWithFrame:CGRectZero];
        UITapGestureRecognizer *tapGestrue = [[UITapGestureRecognizer alloc]
                                              initWithTarget:self
                                              action:@selector(hide)];
        [_shadeView addGestureRecognizer:tapGestrue];
        [_shadeView setBackgroundColor:[UIColor darkGrayColor]];
        [_shadeView setAlpha:0.0f];
        
    }
    
    [self addSubview:_shadeView];
    //功能层
    if (_ActionView == nil)
    {
        _ActionView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    [self addSubview:_ActionView];
    
    //功能层子视图
    _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    if (_collectionView == nil)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView registerClass:[PGActionSheetCell class] forCellWithReuseIdentifier:kCollectionCellResuse];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView setBackgroundColor:DMCOLOR_WITH_HEX(0xe8e8e8, 1.0)];
    }
    [_ActionView addSubview:_collectionView];
    //线
    _lineView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [_ActionView addSubview:_lineView];
    [_lineView setBackgroundColor:DMCOLOR_WITH_HEX(0xd1d1d1, 1.0)];
    //取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_ActionView addSubview:_cancelButton];
    [_cancelButton setBackgroundImage:[UIImage imageFromColor:DMCOLOR_WITH_HEX(0xe8e8e8, 1.0)]
                             forState:UIControlStateNormal];
    [_cancelButton setBackgroundImage:[UIImage imageFromColor:DMCOLOR_WITH_HEX(0xd1d1d1, 1.0)]
                             forState:UIControlStateHighlighted];
    [_cancelButton setTitle:@"取消"
                   forState:DMUIControlStateAll];
    [_cancelButton.titleLabel setFont:DMFont(16)];
    [_cancelButton setTitleColor:DMCOLOR_WITH_HEX(0x7b8085, 1.0)forState:DMUIControlStateAll];
    [_cancelButton addTarget:self
                      action:@selector(_chancelButtonPressed)
            forControlEvents:UIControlEventTouchUpInside];
    
    
}
-(void)setSubViewFrame
{
    //遮罩
    [_shadeView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    //功能层
    _ActionViewConstraint = [_ActionView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:-kActionViewHeight];
    [_ActionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [_ActionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [_ActionView autoSetDimension:ALDimensionHeight toSize:kActionViewHeight];
    
    //布局功能子视图
    [_flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [_flowLayout  setItemSize:kShareActionSize];
    UIEdgeInsets insets;
    switch ([DMDeviceManager getCurrentDeviceType])
    {
        case kiPad:
            insets = UIEdgeInsetsMake(10, self.bounds.size.width/5, 10, self.bounds.size.width/5);
            break;
            
        default:
            insets = UIEdgeInsetsMake(10, 20, 10, 20);
            break;
    }
    [_flowLayout setSectionInset:insets];
    //动态调整Cell间距。。保留。
     CGFloat size = (self.bounds.size.width-kShareActionSize.width*_shareActionNumber-18*2)/(_shareActionNumber-1);
    [_flowLayout setMinimumLineSpacing:size];
    [_collectionView setCollectionViewLayout:_flowLayout];
    [_collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 50, 0)];
    //线
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f];
    [_lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f];
    [_lineView autoSetDimension:ALDimensionHeight toSize:1.f ];
    [_lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_collectionView withOffset:0.0f];
    //按钮
    [_cancelButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [_cancelButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lineView withOffset:0];
    
    
}
-(void)setNumberOfShareActionOneScreen:(NSInteger)number
{
    CGFloat width = self.bounds.size.width ;
    //这里固定iPhone6以上设备cell间距--以iPhone6为准
    if (width > 750 && width <760)
    {
        width = 750;
    }
    //ipad处理
    if(width > 760)
    {
        width *= 0.66f;
    }
    CGFloat size = (width-kShareActionSize.width*number-19*2)/(number-1);
     [_flowLayout setMinimumLineSpacing:size];
    [_collectionView reloadData];
    
}
#pragma mark-----UICollectionViewDataSource
//强制指定为一行
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    _titleArray = [self.dataSource titleOfShareAction];
    _iconNameArray = [self.dataSource imageFileNameOfShareAction];
    NSInteger number ;
    if (self.dataSource != nil &&[self.dataSource respondsToSelector:@selector(numberOfShareAction)])
    {
        number = [self.dataSource  numberOfShareAction];
    }
    else
    {
        number = 1;
    }
    
    return number;
}
-(PGActionSheetCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGActionSheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellResuse
                                                                        forIndexPath:indexPath];
    [cell setShareIconImageName:_iconNameArray[indexPath.row]];
    [cell setShareIconTitle:_titleArray[indexPath.row]];
    
    return cell;
}
#pragma mark-----UICollectionViewDelegate
//item select
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:didSelectedItemAtIndex:)])
    {
        [self.delegate pgActionSheet:self didSelectedItemAtIndex:indexPath.row];
    }
    
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:shouldSelectedItemAtIndex:)])
    {
        return [self.delegate pgActionSheet:self shouldSelectedItemAtIndex:indexPath.row];
    }
    else
    {
        return YES;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:didDeSelectedItemAtIndex:)])
    {
        [self.delegate pgActionSheet:self didDeSelectedItemAtIndex:indexPath.row];
    }
}
-(BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:shouldDeSelectedItemAtIndex:)])
    {
        return  [self.delegate pgActionSheet:self shouldDeSelectedItemAtIndex:indexPath.row];
    }
    else
    {
        return YES;
    }
}

//item highlight
-(BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:shouldHighlightItemAtIndex:)])
    {
        return [self.delegate pgActionSheet:self shouldHighlightItemAtIndex:indexPath.row];
    }
    else
    {
        return YES;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:didHightlightItemAtIndex:)])
    {
        [self.delegate pgActionSheet:self didHightlightItemAtIndex:indexPath.row];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate != nil && [self.delegate respondsToSelector:
                                 @selector(pgActionSheet:didUnhighlightItemAtIndex:)])
    {
        [self.delegate pgActionSheet:self didUnhighlightItemAtIndex:indexPath.row];
    }
}
#pragma mark---Delegate end

-(void)reloadShareActionData
{
    _titleArray = [self.dataSource titleOfShareAction];
    _iconNameArray = [self.dataSource imageFileNameOfShareAction];
    [_collectionView reloadData];
}

-(void)_chancelButtonPressed
{
    [self hide];
}



- (void)show
{
    __weak PGHtmlActionSheet *waekSelf = self;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         [_shadeView setAlpha: 0.4f];
                         waekSelf.alpha = 1.0;
                         _ActionViewConstraint.constant = 0;
                         [waekSelf layoutIfNeeded];
                         
                     } completion:^(BOOL finished) {
                         
                         
                     }];
}

- (void)hide
{
    __weak PGHtmlActionSheet *waekSelf = self;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         _ActionViewConstraint.constant = kActionViewHeight;
                         [waekSelf layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         [_shadeView setAlpha:0.0f];
                         [waekSelf setAlpha:0.0];
                         [waekSelf setAlpha:0.0f];
                     }];
}

@end
