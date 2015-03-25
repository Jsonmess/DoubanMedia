//
//  DBLoginViewController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/24.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DBLoginViewController.h"
#import "PureLayout.h"
#import "DMGlobal.h"
@interface DBLoginViewController ()

@property(nonatomic)    UIImageView *cancelImageView;//返回
@property(nonatomic)    UIImageView *logo1ImageView;//logo1
@property(nonatomic)    UILabel *loginLabel;//登录提示框
@property(nonatomic)    UITextField *userName;//用户名
@property(nonatomic)    UITextField *password;//密码
@property(nonatomic)    UIButton *registerBtn;//跳转注册
@property(nonatomic)    UITextField *authCode;//验证码
@property(nonatomic)    UIImageView *authImageView;//验证码图片

@property(nonatomic)    UIButton *commmitLogin;//提交登录
@property(nonatomic)    UILabel *loginPrompt;//提示登录
@property(nonatomic)    UIImageView *logo2ImageView;//logo2


@end

@implementation DBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}
//设置视图
-(void)setUpView
{
    [self.view setBackgroundColor:DMColor(239,243,240,1.0f)];
    _cancelImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_cancelImageView setUserInteractionEnabled:YES];
    [_cancelImageView setImage:[UIImage imageNamed:@"push_close_normal_btn@2x.png"]];
    _logo1ImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_logo1ImageView setImage:[UIImage imageNamed:@"splash_screen_logo.png"]];
    _loginLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _userName = [[UITextField alloc] initWithFrame:CGRectZero];
    _password = [[UITextField alloc] initWithFrame:CGRectZero];
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _authCode = [[UITextField alloc] initWithFrame:CGRectZero];
   	_authImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	_commmitLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginPrompt = [[UILabel alloc] initWithFrame:CGRectZero];
    _logo2ImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_logo2ImageView setImage:[UIImage imageNamed:@"splash_screen_wave.png"]];


    [self.view addSubview:_cancelImageView];
	[self.view addSubview:_logo1ImageView];
    [self.view addSubview:_userName];
    [self.view addSubview:_password];
    [self.view addSubview:_registerBtn];
    [self.view addSubview:_authCode];
    [self.view addSubview:_authImageView];
    [self.view addSubview:_commmitLogin];
	[self.view addSubview:_loginLabel];
    [self.view addSubview:_loginPrompt];
    [self.view addSubview:_logo2ImageView];

    [self setUpViewContains];
}

-(void)setUpViewContains
{
    //返回
    CGSize cancelSize = self.cancelImageView.image.size;
    [self.cancelImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.cancelImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.cancelImageView autoSetDimension:ALDimensionHeight toSize:cancelSize.height];
    [self.cancelImageView autoSetDimension:ALDimensionWidth toSize:cancelSize.width];
    //logo1
    CGSize logo1Size = self.logo1ImageView.image.size;
    [self.logo1ImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:54.0f];
    [self.logo1ImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.logo1ImageView autoSetDimension:ALDimensionHeight toSize:logo1Size.height*0.5f];
    [self.logo1ImageView autoSetDimension:ALDimensionWidth toSize:logo1Size.width*0.5f];
    //登录提示框
    [self.loginLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logo1ImageView withOffset:30.0f];
    [self.loginLabel setFont:DMFont(11.0f)];
    [self.loginLabel setText:@"用豆瓣账户登录"];
    [self.loginLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f];
    [self.loginLabel autoSetDimension:ALDimensionWidth toSize:100.0f];
    [self.loginLabel autoSetDimension:ALDimensionHeight toSize:20.0f];
    //用户名
    [self.userName setPlaceholder:@"手机号码/邮箱"];
    [self.userName setFont:DMFont(14.0f)];
    [self.userName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.userName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.userName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginLabel withOffset:5.0f];
    [self.userName autoSetDimension:ALDimensionHeight toSize:30.0f];
    //密码
    [self.password setPlaceholder:@"密码"];
    [self.password setFont:DMFont(14.0f)];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.password autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userName withOffset:15.0f];
    [self.password autoSetDimension:ALDimensionHeight toSize:30.0f];
    //没有账号
    [self.registerBtn setTitle:@"没有账户？" forState:UIControlStateNormal];
    [self.registerBtn setTitle:@"没有账户？" forState:UIControlStateHighlighted];
    [self.registerBtn.titleLabel setFont:DMFont(12.0f)];
    [self.registerBtn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.registerBtn setTitleColor: [UIColor blackColor] forState:UIControlStateHighlighted];
    [self.registerBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-20.0f];
    [self.registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:3.0f];

    //验证码
    [self.authCode autoSetDimension:ALDimensionHeight toSize:30.0f];
    [self.authCode setPlaceholder:@"验证码"];
    [self.authCode setFont:DMFont(12.0f)];
    [self.authCode setBorderStyle:UITextBorderStyleRoundedRect];
    [self.authCode autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.password];
    [self.authCode autoSetDimension:ALDimensionWidth toSize:90.0f];
    [self.authCode autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:20.0f];
    //验证码图片
    [self.authImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.authCode];
    [self.authImageView setBackgroundColor:[UIColor redColor]];
    [self.authImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeRight ofView:self.authCode withOffset:15.0f];
    CGSize authSize = self.authImageView.image.size;
    [self.authImageView autoSetDimension:ALDimensionWidth toSize:80.0f];
    [self.authImageView autoSetDimension:ALDimensionHeight toSize:30.0f];
    //登录按钮
    [self.commmitLogin autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.authCode withOffset:23.0f];
    [self.commmitLogin setTintColor:[UIColor whiteColor]];
    [self.commmitLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.commmitLogin setTitle:@"登录" forState:UIControlStateHighlighted];
    [self.commmitLogin autoSetDimension:ALDimensionHeight toSize:35.0f];
    [self.commmitLogin setBackgroundColor:DMColor(35, 131, 50, 0.8f)];
    [self.commmitLogin autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.password];
    [self.commmitLogin autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.password];

    //提示登录
    [self.loginPrompt autoSetDimension:ALDimensionHeight toSize:20.0f];
    [self.loginPrompt setFont:DMFont(11.0f)];
    [self.loginPrompt setText:@"登录后可以将喜欢的歌曲同步到豆瓣"];
    [self.loginPrompt setTextColor:DMColor(173, 175, 176, 1.0f)];
    [self.loginPrompt autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.commmitLogin withOffset:5.0f];
    [self.loginPrompt autoAlignAxis:ALAxisVertical toSameAxisOfView:self.commmitLogin];
    [self.loginPrompt autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.commmitLogin];
    [self.loginPrompt autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.commmitLogin];
    [self.loginPrompt setTextAlignment:NSTextAlignmentCenter];
    //logo2
    [self.logo2ImageView autoAlignAxis:ALAxisVertical toSameAxisOfView:self.logo1ImageView];
    [self.logo2ImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:28.0f];
    CGSize logo2Size = self.logo2ImageView.image.size;
    //4.0寸屏幕以上
    if (ScreenBounds.size.width >320) {
        logo2Size.width *= 0.75;
        logo2Size.height*= 0.75;
    }
    else
    {
        logo2Size.width *=0.6f;
        logo2Size.height *=0.6f;
    }
    [self.logo2ImageView autoSetDimension:ALDimensionWidth toSize:logo2Size.width ];
    [self.logo2ImageView autoSetDimension:ALDimensionHeight toSize:logo2Size.height];
    [self.view setNeedsLayout];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
