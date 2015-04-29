//
//  ShareActionController.m
//  Camera360
//
//  Created by jsonmess on 15/2/2.
//  Copyright (c) 2015年 Pinguo. All rights reserved.
//
#import "ShareActionTool.h"
#import "PGHtmlActionSheet.h"
#import "DMShareEntity.h"
#import <PureLayout.h>
#import "DMGlobal.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface ShareActionTool()<PGHtmlActionSheetDataSource,PGHtmlActionSheetDelegate,UIAlertViewDelegate>
{
    UINavigationController *_navigationController; //基于调用页面
    DMShareEntity *_entity;//分享内容
    NSString *appUrl;//第三方分享下载地址
   TencentOAuth *_mTencent;
    NSInteger length;//用于记录压缩图片的大小
    NSArray *_titlesOfAction;
}
@property (nonatomic,strong) PGHtmlActionSheet *mShareActionSheet;
@end
@implementation ShareActionTool

-(instancetype)initWithSuperNavigationController:(UINavigationController *)naviController
{
    if (self = [super init]) {
        
        _navigationController = naviController;
        _mTencent = [[TencentOAuth alloc] initWithAppId:tencentId andDelegate:nil];
        [WXApi registerApp:weiChatId];
    }
    return self;
}

//分享到第三方应用
-(void)shareToThirdActionWithSuperView:(UIView *)view shareEntity:(DMShareEntity *)entity
{
    _entity = entity;

        if (!self.mShareActionSheet)
        {
            self.mShareActionSheet = [[PGHtmlActionSheet alloc] initPGActionSheetWithFrame:[UIScreen mainScreen].bounds
                                                                     withOnePageCellNumber:4];

            //兼容ipad
            if (view.bounds.size.width >760)
            {
                [self.mShareActionSheet setNumberOfShareActionOneScreen:4];
            }
            //根据需求（iPhone6 5个 之前设备 4个）
            else if (view.bounds.size.width>320 )
            {
                [self.mShareActionSheet setNumberOfShareActionOneScreen:5];
            }else
            {
                [self.mShareActionSheet setNumberOfShareActionOneScreen:4];
            }
            self.mShareActionSheet.dataSource = self;
            self.mShareActionSheet.delegate = self;
            [view.window addSubview:self.mShareActionSheet];
            [self.mShareActionSheet autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
            [view.window layoutIfNeeded];
        }
        [self.mShareActionSheet show];
}

- (void)setTitleOfShareAction:(NSArray *)titles
{
    _titlesOfAction = titles;
}

#pragma mark ---PGShareActionSheetDelegate
-(void)pgActionSheet:(PGHtmlActionSheet *)actionSheet didSelectedItemAtIndex:(NSInteger)index
{
    [actionSheet hide];

        switch (index)
        {
            case 0:

                [self shareToQQ:kShareMsgToQQ];
                break;
            case 1:

                 [self shareToQQ:kShareMsgToQQQZone];
                break;
            case 2:
                   [self shareToWechat:WXSceneSession];
                break;
                
            case 3:
                [self shareToWechat:WXSceneTimeline];
                break;

            default:
                break;
        }


}
/**
 *  指定要显示的分享控件标题
 *
 *  @return titles array
 */
-(NSArray*)titleOfShareAction
{
    if (_titlesOfAction)
    {
        return _titlesOfAction;
    }
    else
    {
        NSArray *titles = @[@"QQ好友",@"QQ空间",@"微信好友",@"微信朋友圈"];
        _titlesOfAction = titles;
        return titles;
    }
}
/**
 *  设置分享控件显示图片文件名
 *
 *  @return image file name array
 */
-(NSArray *)imageFileNameOfShareAction
{
    NSArray *names = @[@"share_site_qq_on.png",
                 		 @"share_site_qzone_on.png",
                       	@"intro_share_wechat.png",
                        @"intro_share_circle.png"
                       ];

    return names;
}
-(NSInteger)numberOfShareAction
{
    return _titlesOfAction.count;
}
#pragma mark ---PGShareActionSheetDelegate end!
- (void)shareToWechat:(int)scene
{
    
    if ([WXApi isWXAppInstalled])
    {
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = scene;
        
        id shareObj = nil;
        WXMediaMessage *message = [WXMediaMessage message];
        /**
         *  如果分享的是图片
         */
        if (_entity.shareImageData)
        {
            shareObj = [WXImageObject object];
            [shareObj setImageData:_entity.shareImageData];
            //此处顺着Entity定义---用于下载分享缩略图 ----对应处理控制在32k以内
            message.thumbData = [self solveWeiXinThumbData:_entity.shareImageData
                                             withImageType:_entity.thumbnailType];
        }
         if (_entity.urlString)
        {
            shareObj = [WXWebpageObject object];
            [shareObj setWebpageUrl:_entity.urlString];
            message.thumbData = [self solveWeiXinThumbData:_entity.shareImageData
                                             withImageType:_entity.thumbnailType];
        }
        message.title = _entity.theTitle;
        message.description = _entity.detailText;
        message.mediaObject = shareObj;
        req.message = message;
        [WXApi sendReq:req];
    }
    else
    {
        
        NSString *message = @"检测到您没有安装微信";
        [self alertViewFowShareWithNoRoad:message AppUrl:WEIXINAPPSTROE_URL];
    }
}
-(void)shareToQQ:(QQShareType)sharetype
{
    
    if ([QQApiInterface isQQInstalled]) {
        //检查是否支持API
        if ([QQApiInterface isQQSupportApi]) {
            
            NSURL *url = [NSURL URLWithString: _entity.urlString];
            NSString *title = _entity.theTitle;
            NSData *imageData = _entity.shareImageData;
            NSString * description = _entity.detailText;
            
            QQApiNewsObject *shareObject = [QQApiNewsObject  objectWithURL:url
                                                                     title:title
                                                               description:description
                                                          previewImageData:imageData];
            
            SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:shareObject];
            QQApiSendResultCode sent = 0;
            //分享到qq
            switch (sharetype) {
                case kShareMsgToQQ:
                    sent = [QQApiInterface sendReq:req];
                    break;
                case kShareMsgToQQQZone:
                    sent = [QQApiInterface SendReqToQZone:req];
                    break;
                default:
                    break;
            }
            
        }
    }
    else
    {
        NSString *message =@"检测到您未安装QQ客户端";
        [self alertViewFowShareWithNoRoad:message AppUrl:QQAPPSTORE_URL];
    }
}
//处理成32k以下的图片数据
-(NSData*)solveWeiXinThumbData:(NSData *)data withImageType:(enum ThumbnailType)type
{
    NSData *imageData = data;
   
   
    if ([imageData length] > 32 * 1024)
    {
        UIImage *image = [UIImage imageWithData:imageData];
        do
        {
       	 
            //根据图片类型对应压缩
            switch (type) {
                case kThumbnailTypeJPEG:
                case kThumbnailTypeJPG:
                    imageData = UIImageJPEGRepresentation(image, 0.55f);
                    break;
                case kThumbnailTypePNG:

                     imageData = UIImagePNGRepresentation(image);
                //无法压缩，防止死循环
                    if (imageData.length == length) {
                        break;
                    }
                    length = imageData.length;
                    break;
                default:
                    break;
            }
   
        } while ([imageData length] > 32 * 1024);
    
        
    }

    return imageData;
}

-(void)alertViewFowShareWithNoRoad:(NSString*)message AppUrl:(NSString *)url
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:@"安装", nil];
    appUrl = url;
    [alertView show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSAssert(appUrl != nil, @"提示分享第三方应用url不可为空");
        //[[UIApplication sharedApplication] openURLInApp:[NSURL URLWithString:appUrl]];

    }
}
@end
