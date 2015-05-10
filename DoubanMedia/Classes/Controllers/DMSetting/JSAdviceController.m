//
//  JSAdviceController.m
//  DoubanMini
//
//  Created by Json on 14-10-7.
//  Copyright (c) 2014年 jsonmess. All rights reserved.
//

#import "JSAdviceController.h"
#import "TabViewManager.h"
#import <MessageUI/MessageUI.h>
#import "MBProgressHUD+DMProgressHUD.h"
@interface JSAdviceController ()<MFMailComposeViewControllerDelegate,UITextViewDelegate>
{
    MFMailComposeViewController *mailPicker;
}
@end

@implementation JSAdviceController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetUpView];
    // Do any additional setup after loading the view from its nib.
}

-(void)SetUpView
{
    self.title=@"用户吐槽";
    [self.AdviceFiled setText:@"有好的建议和想法？"];
    [self.userAddress setPlaceholder:@"  联系方式"];
    //设置返回按钮
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(BackToSetting) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;
    //隐藏底部DOCK
    [[TabViewManager sharedTabViewManager].getTabView setHidden:YES];
    [self.AdviceFiled setDelegate:self];

}

-(void)BackToSetting
{
    [[TabViewManager sharedTabViewManager].getTabView setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)SendAdvice:(id)sender
{
    if ([self.userAddress.text isEqualToString:@""] || [self.userAddress.text isEqualToString:@" "])
    {
        //提示内容不为空
        [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"请输入您的联系方式"
                                                Font:DMFont(15.0f) Margin:14.0f
                                             offsetY:ScreenBounds.size.height*0.3f
                                            showTime:1.0f];
        return;
    }

    if ([self.AdviceFiled.text isEqualToString:@""] || [self.AdviceFiled.text isEqualToString:@" "])
    {
        UIAlertView *alt=[[UIAlertView alloc]initWithTitle:@"提示" message:@"别吝啬您的建议"
                                                  delegate:self cancelButtonTitle:@"好么"
                                         otherButtonTitles: nil];
        [alt show];
        return;
    }
    //解锁1024
    if ([self.userAddress.text isEqualToString:@"1024"] || [self.AdviceFiled.text isEqualToString:@"1024"])
    {
        [self unlock1024];
        return;
    }
    [self sendMailInApp];

}
//激活邮件功能
- (void)sendMailInApp
{
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    if (![mailClass canSendMail]) {
        [self alertWithMessage:@"您没有设置邮件账户"];
        return;
    }
    [self displayMailPicker];
}

//调出邮件发送窗口
- (void)displayMailPicker
{
 mailPicker = [[MFMailComposeViewController alloc] init];
    mailPicker.mailComposeDelegate = self;
    
    //设置主题
    [mailPicker setSubject: @"迷你豆瓣意见反馈"];
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"jsonmess@gmail.com"];
    [mailPicker setToRecipients: toRecipients];
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"646147651@qq.com", nil];
    [mailPicker setCcRecipients:ccRecipients];
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"", nil];
    [mailPicker setBccRecipients:bccRecipients];

    
    NSString *emailBody =[NSString stringWithFormat:@"%@\n当前用户：%@",self.AdviceFiled.text,self.userAddress.text];
    [mailPicker setMessageBody:emailBody isHTML:YES];
    [self presentViewController:mailPicker animated:YES completion:nil];
}

#pragma mark ---实现 代理
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    NSString *msg;
    switch (result) {
        case MFMailComposeResultCancelled:
            msg = @"您已取消编辑邮件！";
            break;
        case MFMailComposeResultFailed:
            msg = @"抱歉，试图保存或者发送邮件失败！";
            break;
        default:
            msg = @"";
            break;
    }
    [self alertWithMessage:msg];
}
-(void)alertWithMessage:(NSString *)msg
{
    if(msg!=nil||![msg isEqual:@""])
    {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
    [alert show];
    }
}
//解锁豆瓣妹纸---宅男福利
-(void)unlock1024
{
    BOOL isUnlock = [[NSUserDefaults standardUserDefaults] boolForKey:@"ZhaiNanUser"];
    if (!isUnlock)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZhaiNanUser"];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示" message:@"福利已解锁，请前往豆瓣妹纸"
                                                    delegate:self cancelButtonTitle:@"确认"
                                           otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        //提示内容不为空
        [MBProgressHUD showTextOnlyIndicatorWithView:self.view Text:@"您已解锁过了喔"
                                                Font:DMFont(15.0f) Margin:11.0f
                                             offsetY:ScreenBounds.size.height*0.3f
                                            showTime:1.0f];
    }

}
//代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.AdviceFiled resignFirstResponder];
    [self.userAddress resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
