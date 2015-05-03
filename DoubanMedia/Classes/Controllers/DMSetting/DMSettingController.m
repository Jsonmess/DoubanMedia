//
//  DMSettingController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMSettingController.h"
#import "BaseTableView.h"
@interface DMSettingController ()<UITableViewDelegate,UITableViewDataSource>
{
    BaseTableView *baseTableView;
}
@end

@implementation DMSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setUpView
{
    [self setTitle:@"应用设置"];
    baseTableView = [[BaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:baseTableView];
    [baseTableView setDelegate:self];
    [baseTableView setDataSource:self];

}



#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reUseStr = @"settingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reUseStr];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseStr];
    }
    return cell;
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
