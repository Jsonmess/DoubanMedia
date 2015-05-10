//
//  DMCreateQRCodeController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/9.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMCreateQRCodeController.h"
#import <ZBarSDK.h>
#import "QRCodeGenerator.h"
#import "DMDeviceManager.h"
#import "ShareActionTool.h"
#import "DMShareEntity.h"
#import "TabViewManager.h"
#import "PhotoTool.h"
@interface DMCreateQRCodeController ()
@property (nonatomic)  UITextField *theTextView;
@property (nonatomic)  UIImageView *showQRCodeView;
@property (nonatomic)  UIButton *saveBtn;
@property (nonatomic)  UIButton *shareBtn;
@property (nonatomic)  UIButton *createBtn;

@end

@implementation DMCreateQRCodeController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[[TabViewManager sharedTabViewManager] getTabView] setHidden:YES];
}
-(void)setUpView
{
    [self setTitle:@"生成二维码"];
    [self.view setBackgroundColor:DMColor(235, 235, 241, 1.0f)];
    //设置左边状态栏
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(backToMenu) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;

    _theTextView = [[UITextField alloc] init];
    [_theTextView setBorderStyle:UITextBorderStyleRoundedRect];
    [_theTextView setFont:DMBoldFont(14.0f)];
    [_theTextView setText:@"迷你豆瓣"];
    [_theTextView setBackgroundColor:DMColor(200, 200, 200, 0.1f)];
    _showQRCodeView = [[UIImageView alloc]init];
    _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saveBtn setTitle:@"保存到相册" forState:DMUIControlStateAll];
    [_saveBtn setTitleColor:[UIColor grayColor] forState:DMUIControlStateAll];
    [_saveBtn addTarget:self action:@selector(saveToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setTitleColor:[UIColor grayColor] forState:DMUIControlStateAll];
    [_shareBtn setTitle:@"分享一下" forState:DMUIControlStateAll];
    [_shareBtn addTarget:self action:@selector(shareToOthers:) forControlEvents:UIControlEventTouchUpInside];
    _createBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_createBtn setTitleColor:[UIColor grayColor] forState:DMUIControlStateAll];
    [_createBtn setTitle:@"生成二维码" forState:DMUIControlStateAll];
    [_createBtn addTarget:self action:@selector(createQRCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_theTextView];
    [self.view addSubview:_showQRCodeView];
    [self.view addSubview:_createBtn];
    [self.view addSubview:_saveBtn];
    [self.view addSubview:_shareBtn];
    [self setContains];

    //预生成一张二维码
    [self createQRCode:nil];
}
-(void)setContains
{

    [_theTextView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(100, 20.0f, 0, 20.0f)
                                           excludingEdge:ALEdgeBottom];
    [_theTextView autoSetDimension:ALDimensionHeight toSize:35.0f];
    CGFloat theWidth = ScreenBounds.size.width *0.6f;
    [_showQRCodeView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_theTextView withOffset:30.0f];
    [_showQRCodeView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_showQRCodeView autoSetDimension:ALDimensionWidth toSize:theWidth];
    [_showQRCodeView autoSetDimension:ALDimensionHeight toSize:theWidth];
    //按钮
    [_createBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:_theTextView];
    CGFloat fontValue = 14.0f;
    if ([DMDeviceManager getCurrentDeviceType] == kiPad )
    {
        fontValue = 16.0f;
    }
    [_createBtn.titleLabel setFont:DMFont(fontValue)];
    [_createBtn autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width*1/4];
    [_createBtn autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_createBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_showQRCodeView withOffset:40.0f];

     [_saveBtn.titleLabel setFont:DMFont(fontValue)];
    [_saveBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_createBtn];
    [_saveBtn autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [_saveBtn autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width*1/4];
    [_saveBtn autoSetDimension:ALDimensionHeight toSize:40.0f];

    [_shareBtn.titleLabel setFont:DMFont(fontValue)];
    [_shareBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:_theTextView];
    [_shareBtn autoSetDimension:ALDimensionWidth toSize:ScreenBounds.size.width*1/4];
    [_shareBtn autoSetDimension:ALDimensionHeight toSize:40.0f];
    [_shareBtn autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_saveBtn];

    [self.view layoutIfNeeded];
}

-(void)backToMenu
{
    [[TabViewManager sharedTabViewManager].getTabView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

//保存到系统相册
- (void)saveToAlbum:(id)sender
{
    [[PhotoTool SharePhotoTool]
     SavePhotoToAlAssetsLibraryWithImageData:UIImageJPEGRepresentation(_showQRCodeView.image, 1.0f)];
}
//分享
- (void)shareToOthers:(id)sender
{
    DMShareEntity *entity = [[DMShareEntity alloc] init];
    entity.theTitle = @"分享二维码";
    entity.detailText = @"来自迷你豆瓣";
    entity.thumbnailType = kThumbnailTypeJPG;
    entity.shareImageData = UIImageJPEGRepresentation(_showQRCodeView.image, 1.0f);
   ShareActionTool *shareTool = [[ShareActionTool alloc] initWithSuperNavigationController:nil];
    [shareTool shareToThirdActionWithSuperView:self.view shareEntity:entity];
}
//生成二维码
- (void)createQRCode:(id)sender
{
    NSString *contents = _theTextView.text;
    if (contents == nil || [contents isEqualToString:@" "])
    {
        //提示内容不为空
        return;
    }
    //开始生成
    _showQRCodeView.image = [QRCodeGenerator qrImageForString:contents
                                                    imageSize:_showQRCodeView.bounds.size.width];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_theTextView resignFirstResponder];
}
@end
