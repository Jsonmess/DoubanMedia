//
//  DBLoginViewController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/24.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DBLoginViewController.h"
#import "PureLayout.h"
@interface DBLoginViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *cancelImageView;//返回
@property (weak, nonatomic) IBOutlet UIImageView *logo1ImageView;//logo1
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;//登录提示框
@property (weak, nonatomic) IBOutlet UITextField *userName;//用户名
@property (weak, nonatomic) IBOutlet UITextField *password;//密码
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//跳转注册
@property (weak, nonatomic) IBOutlet UITextField *authCode;//验证码
@property (weak, nonatomic) IBOutlet UIImageView *authImageView;//验证码图片

@property (weak, nonatomic) IBOutlet UIButton *commmitLogin;//提交登录
@property (weak, nonatomic) IBOutlet UILabel *loginPrompt;//提示登录
@property (weak, nonatomic) IBOutlet UIImageView *logo2ImageView;//logo2


@end

@implementation DBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
//设置视图
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
    [self.logo1ImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64.0f];
    [self.logo1ImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.logo1ImageView autoSetDimension:ALDimensionHeight toSize:logo1Size.height];
    [self.logo1ImageView autoSetDimension:ALDimensionWidth toSize:logo1Size.width];
    //登录提示框
    [self.loginLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.logo1ImageView withOffset:20.0f];
    [self.loginLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f];
    [self.loginLabel autoSetDimension:ALDimensionWidth toSize:100.0f];
    [self.loginLabel autoSetDimension:ALDimensionHeight toSize:20.0f];
    //用户名
    [self.userName autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.userName autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.userName autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginLabel withOffset:5.0f];
    [self.userName autoSetDimension:ALDimensionHeight toSize:30.0f];
    //密码
    [self.password autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.view withOffset:40.0f];
    [self.password autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-40.0f];
    [self.password autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.userName withOffset:15.0f];
    [self.password autoSetDimension:ALDimensionHeight toSize:30.0f];
    //没有账号
    [self.registerBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.view withOffset:-20.0f];
    [self.registerBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:5.0f];
    //验证码
	[self.authCode autoSetDimension:ALDimensionHeight toSize:30.0f];
    [self.authCode autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:self.password];
    [self.authCode autoSetDimension:ALDimensionWidth toSize:100.0f];
    [self.authCode autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.password withOffset:20.0f];
    //验证码图片
    [self.authImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.authCode];
    [self.authImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeft ofView:self.authCode withOffset:15.0f];
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
