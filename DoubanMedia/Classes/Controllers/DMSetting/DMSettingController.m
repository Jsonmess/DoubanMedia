//
//  DMSettingController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/5/3.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMSettingController.h"
#import "BaseTableView.h"
#import "BaseTableViewCell.h"
#import "DMUserInfoCell.h"
#import "DMDeviceManager.h"
@interface DMSettingController ()<UITableViewDelegate,UITableViewDataSource>
{
    BaseTableView *baseTableView;
}
@end

@implementation DMSettingController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

-(void)setUpView
{
    [self setTitle:@"应用设置"];
    CGFloat btSpacing = 10.0f;
    CGFloat btWidth = self.view.bounds.size.width -btSpacing*2;
    baseTableView = [[BaseTableView alloc]initWithFrame:CGRectMake(btSpacing, 0, btWidth,
                                                                   self.view.bounds.size.height-kTabbarHeight)
                                                  style:UITableViewStyleGrouped];
    [self.view addSubview:baseTableView];
    [self.view setBackgroundColor:baseTableView.backgroundColor];
    [baseTableView setContentInset:UIEdgeInsetsMake(5.0f, 0, 0, 0)];
    [baseTableView setDelegate:self];
    [baseTableView setDataSource:self];

}



#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0)
    {
        cell = [[DMUserInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
    }else
    {
        static NSString *reUseStr = @"settingCell";
        cell = [tableView dequeueReusableCellWithIdentifier:reUseStr];
        if (cell == nil)
        {
            cell = [[BaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reUseStr];
        }
    }
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
    return label;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat theHeight = 0.0f;
	if([DMDeviceManager getCurrentDeviceType] == kiPad)
    {
        if (indexPath.section == 0)
        {
            theHeight = 290.0f;
        }
        else
            theHeight = 80.0f;
    }
    else
    {
        if (indexPath.section == 0)
        {
            theHeight = 180.0f;
        }
        else
            theHeight = 60.0f;

    }
    return theHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0.1f;
    }
    else
    return 30.0f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    //设置底部视图
    if (section == 3)
    {
         return 10.f;
    }
    else
        return 20.0f;

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
