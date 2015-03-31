//
//  DBLoginViewController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/24.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMLoginViewController.h"
#import "PureLayout.h"
#import "DMGlobal.h"
#import "DMLoginManager.h"
#import <UIKit+AFNetworking.h>
#import <ReactiveCocoa.h>
#import "AccountInfo.h"
@interface DMLoginViewController ()<DMLoginManagerDelegate,UITextFieldDelegate>
{
    DMLoginManager *loginManager;
}
@property(nonatomic)    UIImageView *cancelImageView;//返回
@property(nonatomic)    UIImageView *logo1ImageView;//logo1
@property(nonatomic)    UILabel *loginLabel;//登录提示框
@property(nonatomic)    UITextField *userName;//用户名
@property(nonatomic)    UILabel *nameError;//不合法提示
@property(nonatomic)    UITextField *password;//密码
@property(nonatomic)    UIButton *registerBtn;//跳转注册
@property(nonatomic)    UITextField *authCode;//验证码
@property(nonatomic)    UIImageView *authImageView;//验证码图片

@property(nonatomic)    UIButton *commitLogin;//提交登录
@property(nonatomic)    UILabel *loginPrompt;//提示登录
@property(nonatomic)    UIImageView *logo2ImageView;//logo2


@end

@implementation DMLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self commonInit];
    [self setUpView];
    // Do any additional setup after loading the view.
}
-(void)commonInit
{
    loginManager = [[DMLoginManager alloc]init];
    [loginManager setLoginDelegate:self];
    //预加载验证码
    [loginManager getCaptchaImageFromDM];

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
    [_userName setTag:1];
    [_userName setDelegate:self];
    _nameError = [[UILabel alloc] initWithFrame:CGRectZero];
    _password = [[UITextField alloc] initWithFrame:CGRectZero];
    [_password setSecureTextEntry:YES];
    [_password setDelegate:self];
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn addTarget:self action:@selector(gotoRegisterAccount)
           forControlEvents:UIControlEventTouchUpInside];
    _authCode = [[UITextField alloc] initWithFrame:CGRectZero];
    [_authCode setDelegate:self];
   	_authImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self action:@selector(reloadAuthImage)];
    [_authImageView setUserInteractionEnabled:YES];
    [_authImageView setBackgroundColor:DMColor(195, 218, 105, 0.3f)];
    [_authImageView.layer setCornerRadius:3.0f];
    [_authImageView addGestureRecognizer:tap];
	_commitLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitLogin addTarget:self action:@selector(beginToLogin)
           forControlEvents:UIControlEventTouchUpInside];
    _loginPrompt = [[UILabel alloc] initWithFrame:CGRectZero];
    _logo2ImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_logo2ImageView setImage:[UIImage imageNamed:@"splash_screen_wave.png"]];


    [self.view addSubview:_cancelImageView];
	[self.view addSubview:_logo1ImageView];
    [self.view addSubview:_userName];
    [self.view addSubview:_nameError];
    [self.view addSubview:_password];
    [self.view addSubview:_registerBtn];
    [self.view addSubview:_authCode];
    [self.view addSubview:_authImageView];
    [self.view addSubview:_commitLogin];
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
    [self.userName setFont:DMFont(12.0f)];
    [self.userName setBorderStyle:UITextBorderStyleRoundedRect];
    [self.userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.userName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.userName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginLabel withOffset:5.0f];
    [self.userName autoSetDimension:ALDimensionHeight toSize:30.0f];
	//错误提示框
    [self.nameError setFont:DMFont(12.0f)];
    [self.nameError setText:@"    "];
    [self.nameError setTextColor:[UIColor redColor]];
    [self.nameError autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-50.0f];
    [self.nameError setTextAlignment:NSTextAlignmentLeft];
    [self.nameError autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userName withOffset:3.0f];
    //密码
    [self.password setPlaceholder:@"密码"];
    [self.password setFont:DMFont(12.0f)];
    [self.password setBorderStyle:UITextBorderStyleRoundedRect];
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.password autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameError withOffset:10.0f];
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
    [self.authImageView autoPinEdge:ALEdgeLeading toEdge:ALEdgeRight ofView:self.authCode withOffset:15.0f];
    [self.authImageView autoSetDimension:ALDimensionWidth toSize:90.0f];
    [self.authImageView autoSetDimension:ALDimensionHeight toSize:30.0f];
    //登录按钮
    [self.commitLogin autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.authCode withOffset:23.0f];
    [self.commitLogin setTintColor:[UIColor whiteColor]];
    [self.commitLogin setTitle:@"登录" forState:UIControlStateNormal];
    [self.commitLogin setTitle:@"登录" forState:UIControlStateHighlighted];
    [self.commitLogin autoSetDimension:ALDimensionHeight toSize:35.0f];
    [self.commitLogin setBackgroundColor:DMColor(35, 131, 50, 0.8f)];
    [self.commitLogin autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.password];
    [self.commitLogin autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.password];

    //提示登录
    [self.loginPrompt autoSetDimension:ALDimensionHeight toSize:20.0f];
    [self.loginPrompt setFont:DMFont(11.0f)];
    [self.loginPrompt setText:@"登录后可以将喜欢的歌曲同步到豆瓣"];
    [self.loginPrompt setTextColor:DMColor(173, 175, 176, 1.0f)];
    [self.loginPrompt autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.commitLogin withOffset:5.0f];
    [self.loginPrompt autoAlignAxis:ALAxisVertical toSameAxisOfView:self.commitLogin];
    [self.loginPrompt autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.commitLogin];
    [self.loginPrompt autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.commitLogin];
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

#pragma mark -- action
-(void)reloadAuthImage
{
    [loginManager getCaptchaImageFromDM];
}
//前往注册新账户
-(void)gotoRegisterAccount
{
    [loginManager logout];
}
//开始登录
-(void)beginToLogin
{
    [_nameError setText:@"     "];
    NSString *userName = _userName.text;
    NSString *passWord = _password.text;
    NSString *authCode = _authCode.text;
    //除去空字符

    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    passWord = [passWord stringByReplacingOccurrencesOfString:@" " withString:@""];
    authCode = [authCode stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (![self checkMobileNumberOrEmail:_userName.text])
    {  //提示
        return;
    }
    if ([_password.text isEqualToString:@""]||_password.text == nil)
    {
        [_password setPlaceholder:@"密码不可为空"];
        [_password setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        return;
    }
    if ([_authCode.text isEqualToString:@""]||_authCode.text == nil)
    {
        [_authCode setPlaceholder:@"输入验证码"];
        [_authCode setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        return;
    }
    [loginManager LoginwithUsername:userName Password:passWord Captcha:authCode RememberOnorOff:@"On"];
    [_commitLogin setEnabled:NO];

}

#pragma mark ---DMLoginManagerDelegate
-(void)setCaptchaImageUrl:(NSString *)url
{
    [self.authImageView setImageWithURL:[NSURL URLWithString:url]];
}
-(void)loginState:(kLoginState)state
{
    [_commitLogin setEnabled:YES];
}
-(void)logoutState:(kLogoutState)state
{

}
#pragma mark ---TextFiledDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 1)
    {
        [self checkMobileNumberOrEmail:textField.text];
    }
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField.tag == 1)
    {
         [self checkMobileNumberOrEmail:textField.text];
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];

    if (textField.tag == 1)
    {
        [self checkMobileNumberOrEmail:textField.text];
    }

}
#pragma mark--Other

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_userName resignFirstResponder];
    [_password resignFirstResponder];
    [_authCode resignFirstResponder];

    [self checkMobileNumberOrEmail:_userName.text];

}

//检查手机号码和邮箱是否合法
-(BOOL)checkMobileNumberOrEmail:(NSString *)userName
{
    BOOL isRightNumber = [self isValidateMobile:userName];
    BOOL isRightEmail = [self isValidateEmail:userName];
    BOOL isValiable =   (isRightEmail || isRightNumber);
    if (!isValiable)
    {
        [self.nameError setText:@"输入邮箱或者手机号码错误"];
    }
    else
    {
        [self.nameError setText:@"       "];
    }
    return isValiable;
}
/*手机号码验证*/
-(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
/*邮箱验证 */
-(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
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
