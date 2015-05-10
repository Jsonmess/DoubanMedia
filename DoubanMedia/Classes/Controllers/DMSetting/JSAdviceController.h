//
//  JSAdviceController.h
//  DoubanMini
//
//  Created by Json on 14-10-7.
//  Copyright (c) 2014年 jsonmess. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSAdviceController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *AdviceFiled;//输入区域
@property (weak, nonatomic) IBOutlet UITextField *userAddress;

- (IBAction)SendAdvice:(id)sender;//提交给作者

@end
