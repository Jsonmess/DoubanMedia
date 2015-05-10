//
//  DMZBarReaderController.m
//  erWeiMaDemo
//
//  Created by jsonmess on 15/5/7.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMZBarReaderController.h"
#import "DMDeviceManager.h"
#import "TabViewManager.h"
@interface DMZBarReaderController ()<ZBarReaderViewDelegate>
{
    UIButton *flashLight;//闪光灯----预留控制
    UIImageView *scanBox;//扫描框
    UIImageView *scanBar;//扫描条
    UIView *contentView;//容器视图
    ZBarReaderView *scanView;//扫描预览
    //遮罩视图
    UIView *marsk0,*marsk1,*marsk2,*marsk3;
    UILabel *infoLabel;//提示
    //约束--用于动画
    NSLayoutConstraint *scanBarTopContain;//top
    NSTimer *animationTimer;
    CGFloat theBarBoxHeight;
}
@end

@implementation DMZBarReaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    //隐藏工具栏
    [[TabViewManager sharedTabViewManager].getTabView setHidden:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [scanView start];
    [self startAminimation];
    [MobClick beginLogPageView:@"扫一扫二维码"];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"扫一扫二维码"];
}
//设置视图
-(void)setUpView
{
    [self setTitle:@"扫一扫"];
    //设置左边状态栏
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;
    //扫描视图
    scanView = [[ZBarReaderView alloc]init];
    [self.view addSubview:scanView];
    scanView.trackingColor = [UIColor clearColor];
    [scanView setTorchMode:0];//关闭闪关灯
    [scanView setReaderDelegate:self];
    //容器
    contentView = [[UIView alloc] initWithFrame:CGRectZero];
    //扫描框
    scanBox = [[UIImageView alloc] initWithFrame:CGRectZero];
    [scanBox setImage:[UIImage imageNamed:@"scan"]];
    //扫描条
    scanBar = [[UIImageView alloc] initWithFrame:CGRectZero];
    [scanBar setImage:[UIImage imageNamed:@"scan_animation"]];
    [contentView addSubview:scanBox];
    [contentView addSubview:scanBar];
    //遮罩
    marsk0 = [[UIView alloc]initWithFrame:CGRectZero];
    [marsk0 setBackgroundColor:DMColor(200, 200, 200, 0.2f)];
    marsk1 = [[UIView alloc]initWithFrame:CGRectZero];
    [marsk1 setBackgroundColor:DMColor(200, 200, 200, 0.2f)];
    marsk2 = [[UIView alloc]initWithFrame:CGRectZero];
    [marsk2 setBackgroundColor:DMColor(200, 200, 200, 0.2f)];
    marsk3 = [[UIView alloc]initWithFrame:CGRectZero];
    [marsk3 setBackgroundColor:DMColor(200, 200, 200, 0.2f)];
    [self.view addSubview:marsk0];
    [self.view addSubview:marsk1];
    [self.view addSubview:marsk2];
    [self.view addSubview:marsk3];
    [self.view addSubview:contentView];
    //提示
    infoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    CGFloat fontValue = 13.0f;
    if ([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        fontValue = 16.0f;
    }
    [infoLabel setFont:DMFont(fontValue)];
    [infoLabel setTextColor:[UIColor whiteColor]];
    [infoLabel setText: @"将二维码/条形码放入框中，应用将自动扫描"];
    [self.view addSubview:infoLabel];
    [self setContains];
}

//设置内容
-(void)setContains
{
    [scanView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [scanView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [contentView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [contentView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    CGFloat theHeight = ScreenBounds.size.width * 0.7f;
    if ([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        theHeight = ScreenBounds.size.width * 0.5f;
    }
    [contentView autoSetDimension:ALDimensionHeight toSize:theHeight];
    [contentView autoSetDimension:ALDimensionWidth toSize:theHeight];
    theBarBoxHeight = theHeight;
    //扫描框
    [scanBox autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, -2.0f)];
    //扫描条
    scanBarTopContain = [scanBar autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:scanBox];
    [scanBar autoSetDimension:ALDimensionHeight toSize:scanBar.image.size.height *0.5f];
    [scanBar autoSetDimension:ALDimensionWidth toSize:theHeight-10.0f];
    [scanBar autoAlignAxisToSuperviewAxis:ALAxisVertical];
    //遮罩层
    //1.top
    [marsk0 autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [marsk0 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:contentView withOffset:4.0f];
    //2.left
    [marsk1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:marsk0];
    [marsk1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view];
    [marsk1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [marsk1 autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:contentView withOffset:4.0f];
    //3.bottom
    [marsk2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentView withOffset:-4.0f];
    [marsk2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:marsk1];
    [marsk2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.view];
    [marsk2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    //4.right
    [marsk3 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:contentView withOffset:-2.0f];
    [marsk3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:marsk0];
    [marsk3 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:marsk2];
    [marsk3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view];
    //提示
    [infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:contentView withOffset:35.0f];
    [infoLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.view layoutIfNeeded];
}

-(void)reSetDefault
{
    //删除动画
    animationTimer = nil;
    //恢复扫描bar初始位置
    [scanBarTopContain setConstant:0];
    [scanBar layoutIfNeeded];

}

//动画
-(void)startAminimation
{
    //启动动画
    //开始循环动画
    [scanBarTopContain setConstant:theBarBoxHeight-scanBar.bounds.size.height];
    [UIView animateWithDuration:0.75f animations:^{
        [scanBar layoutIfNeeded];
    } completion:^(BOOL finished) {
        [scanBarTopContain setConstant:0];
        [UIView animateWithDuration:0.75f animations:^{
            [scanBar layoutIfNeeded];
        }];
    }];
   animationTimer = [NSTimer scheduledTimerWithTimeInterval:1.5f target:self
                                   selector:@selector(repeatAnimation)
                                   userInfo:nil repeats:YES];

}
-(void)repeatAnimation
{
     //开始循环动画
    [scanBarTopContain setConstant:theBarBoxHeight-scanBar.bounds.size.height];
    [UIView animateWithDuration:0.75f animations:^{
        [scanBar layoutIfNeeded];
    } completion:^(BOOL finished) {
        [scanBarTopContain setConstant:0];
        [UIView animateWithDuration:0.75f animations:^{
            [scanBar layoutIfNeeded];
        }];
    }];
}
-(void)backToMenu
{
    [[TabViewManager sharedTabViewManager].getTabView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --ZBarDelegate
-(void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    //播放个音效
    //处理结果--跳转到浏览器或者粘贴板---暂时不实现
    NSString *result;
    for (ZBarSymbol *symbol in symbols)
    {
        result = symbol.data;
    }
    if (result != nil)
    {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = result;
        //提示：内容已经复制
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"扫描成功，内容已复制到设备粘贴板" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}


@end
