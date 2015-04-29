//
//  DMMeiZiController.m
//  ShareDemo
//
//  Created by jsonmess on 15/4/27.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMMeiZiController.h"
#import "DMMeiZiView.h"
#import "DMMeiZiDetailController.h"
@interface DMMeiZiController ()<DMMeiZiViewDelegate>

@end

@implementation DMMeiZiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"豆瓣妹纸"];
    DMMeiZiView *theView = [[DMMeiZiView alloc] initWithFrame:self.view.bounds];
    [theView setDelegate:self];
    self.view = theView;

    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)meiZiView:(DMMeiZiView *)theView shouldLoadMeiZiClasses:(NSDictionary *)source
{
    DMMeiZiDetailController *detailController = [[DMMeiZiDetailController alloc] init];
    detailController.douBanMeiZiSource = source[@"MeiZiUrl"];
    [detailController setTheTitle:source[@"theClasses"]];
    
    [self.navigationController pushViewController:detailController animated:YES];
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
