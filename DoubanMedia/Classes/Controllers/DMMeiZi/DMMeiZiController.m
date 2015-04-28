//
//  DMMeiZiController.m
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiController.h"
#import "DMMeiZiView.h"
@interface DMMeiZiController ()

@end

@implementation DMMeiZiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"豆瓣妹纸"];
    DMMeiZiView *theView = [[DMMeiZiView alloc] initWithFrame:self.view.bounds];
    self.view = theView;

    // Do any additional setup after loading the view.
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
