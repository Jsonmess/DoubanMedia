//
//  JSWebViewController.m
//  JSWebViewController
//
//  Created by jsonmess on 15/4/21.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "JSWebViewController.h"
#import "DMLoginManager.h"
#import "MBProgressHUD+DMProgressHUD.h"
@interface JSWebViewController ()<UIWebViewDelegate,DMLoginManagerDelegate,UIScrollViewDelegate>
{
    UIWebView *theWebView;
    UIImageView *topBarView;//顶部视图
    UIImageView *bottomBarView;//底部视图
    UIButton *backBtn;//返回按钮
    UIButton *shareBtn;//分享
    UILabel *theTitle;//标题
    NSURLRequest *mRequset;//请求
    BOOL isShouldRefresh;//是否允许刷新
    UISwipeGestureRecognizer *swipeGesture;//手势
    DMLoginManager *loginManager;
    MBProgressHUD *hud ;//指示器
    UIButton *pbackBtn;//后退
    UIButton *pforwardBtn;//前进
    int _lastPosition;//辅助判断滚动方向
}
@end

@implementation JSWebViewController
/**
 *  公共接口
 */
-(instancetype)initWithRequset:(NSURLRequest *)request
{
    if (self = [super init])
    {
        mRequset = request;
        [self commonInit];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
}
-(void)commonInit
{
    loginManager = [[DMLoginManager alloc] init];
    [loginManager setLoginDelegate:self];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    isShouldRefresh = YES;
}
/**
 *  初始化视图
 
 */
-(void)setUpView
{
    CGRect webRect = [UIScreen mainScreen].bounds;
    webRect  = (CGRect){{0,20},{webRect.size.width,webRect.size.height-20.0f-40.0f}};
    theWebView = [[UIWebView alloc] initWithFrame: webRect];
    [theWebView setDelegate:self];
    [theWebView.scrollView setDelegate:self];
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector( swipeGesture:)];
    [theWebView addGestureRecognizer:swipeGesture];
    [self.view addSubview:theWebView];
    [theWebView.scrollView setScrollsToTop:YES];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //模拟导航栏
    topBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20.0f, webRect.size.width, 44.0f)];
    [topBarView setUserInteractionEnabled:YES];
    [topBarView setBackgroundColor:[UIColor whiteColor]];
    //回退
    backBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(15, 8, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:backBtn];
    theTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backBtn.frame), 8.0f, self.view.bounds.size.width - 2*(backBtn.bounds.size.width+15.0f), 28.0f)];
    [theTitle setTextAlignment:NSTextAlignmentCenter];
    [theTitle setText:@"豆瓣电影"];
    [theTitle setFont:DMBoldFont(15.0f)];
    [topBarView addSubview:theTitle];
	//分享
    shareBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(self.view.bounds.size.width -25.0f-15.0f, 8, 25, 25)];
    [shareBtn setImage:[UIImage imageNamed:@"top_menu_share.png"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"top_menu_share.png"] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [topBarView addSubview:shareBtn];
    [self.view addSubview:topBarView];
    //底部视图
    bottomBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-40.0f, self.view.bounds.size.width, 40.0f)];
    [bottomBarView setUserInteractionEnabled:YES];
    [bottomBarView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomBarView];
	//后退
    pbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pbackBtn setEnabled:NO];
    [pbackBtn setImage:[UIImage imageNamed:@"SVWebViewControllerBack"] forState:UIControlStateNormal];
	  [pbackBtn setImage:[UIImage imageNamed:@"SVWebViewControllerBack"] forState:UIControlStateHighlighted];
     [pbackBtn setImage:[UIImage imageNamed:@"SVWebViewControllerBackDisable"] forState:UIControlStateDisabled];
    [pbackBtn addTarget:self action:@selector(goBackThePage) forControlEvents:UIControlEventTouchUpInside];
    [pbackBtn setContentMode:UIViewContentModeScaleAspectFit];
    [pbackBtn setFrame:CGRectMake(20, 5, 40, 30)];
    [bottomBarView addSubview:pbackBtn];
	//前进
    pforwardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pforwardBtn setImage:[UIImage imageNamed:@"SVWebViewControllerNext"] forState:UIControlStateNormal];
    [pforwardBtn setImage:[UIImage imageNamed:@"SVWebViewControllerNext"] forState:UIControlStateHighlighted];
        [pforwardBtn setImage:[UIImage imageNamed:@"SVWebViewControllerNextDisable"] forState:UIControlStateDisabled];
    [pforwardBtn addTarget:self action:@selector(goForWardPage) forControlEvents:UIControlEventTouchUpInside];
    [pforwardBtn setContentMode:UIViewContentModeScaleAspectFit];
    [pforwardBtn setFrame:CGRectMake(0.5*(self.view.bounds.size.width-40), 5, 40, 30)];
    [bottomBarView addSubview:pforwardBtn];
    //刷新

    UIButton *pfreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [pfreshBtn setImage:[UIImage imageNamed:@"RefreshBtn"] forState:UIControlStateNormal];
    [pfreshBtn setImage:[UIImage imageNamed:@"RefreshBtn"] forState:UIControlStateHighlighted];
    [pfreshBtn addTarget:self action:@selector(RefreshPage) forControlEvents:UIControlEventTouchUpInside];
    [pfreshBtn setContentMode:UIViewContentModeScaleAspectFill];
    [pfreshBtn setFrame:CGRectMake(self.view.bounds.size.width-60.0f, 5, 40, 30)];
    [bottomBarView addSubview:pfreshBtn];
    //首次直接打开网页
    [self openRequrest];
}
-(void)openRequrest
{
    [theWebView loadRequest:mRequset];
}
#pragma mark ---- actions
//返回上级视图
-(void)goBack
{
	//pop
    [self dismissViewControllerAnimated:YES completion:nil];
}
//分享
-(void)share
{
	NSLog(@"点此分享");
}
//后退
-(void)goBackThePage
{
    //后退
    if ([theWebView canGoBack])
    {
        [theWebView goBack];
    }

}
//前进
-(void)goForWardPage
{
    if ([theWebView canGoForward])
    {
        [theWebView goForward];
    }
}
//刷新
-(void)RefreshPage
{
    [theWebView reload];
}
//手势
-(void)swipeGesture:(UISwipeGestureRecognizer *) recognizer
{
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight)
    {
        //后退
        if (theWebView.canGoBack)
        {
            [theWebView goBack];
        }
        //增加提示 onlytext

    }
    else if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
		//前进
        if (theWebView.canGoForward)
        {
            [theWebView goForward];
        }
        //增加提示 onlytext

    }

}
-(void)showRefreshOrJump:(BOOL)fresh
{
    isShouldRefresh = fresh;
}
#pragma mark ----UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request
	navigationType:(UIWebViewNavigationType)navigationType
{

        //1.如果是用户登录界面准备弹出
        if ([request.URL.absoluteString isEqualToString:DoubanWebLogin]&&isShouldRefresh)
        {
            //拦截用户登录
            [hud hide:YES];
            hud = [MBProgressHUD showTextAndProgressViewIndicatorWithView:self.view Text:@"正在登录豆瓣.."
                                                                     Font:DMFont(14.0f) Margin:10.0f];
            [loginManager webLoginDouban];
            [hud show:YES];
            return NO;
        }else
           return YES;


}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //设置标题
    [theTitle setText:[webView stringByEvaluatingJavaScriptFromString:@"document.title"]];
        [theWebView.scrollView setBounces:NO];
    //检查是否可以前进和后退

    [pforwardBtn setEnabled:[theWebView canGoForward]];
	[pbackBtn setEnabled:[theWebView canGoBack]];
}

#pragma mark --- loginDelegate
-(void)webLoginState:(kLoginState)state
{
       [hud hide:YES];
    if (state == kLoginSuccess)
    {
        [theWebView loadRequest:mRequset];
    }
    else
    {
        //提示手动登录
        isShouldRefresh = NO;
        [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"登录失败，请您手动登录"
                                                      Font:DMFont(13.0f)
                                         	     Margin:10.0f
       											  offsetY:0
                                                  showTime:1.2f];
        [theWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:DoubanWebLogin]]];
    }
}

@end
