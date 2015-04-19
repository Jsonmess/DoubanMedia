//
//  DMFilmDetailController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/4/19.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFilmDetailController.h"
#import "TabViewManager.h"
#import "BaseTableView.h"
#import "DMFilmInfoCell.h"
//本次视图暂只支持iphone ，ipad 自动跳转到网页视图
@interface DMFilmDetailController ()<UITableViewDataSource,
							UITableViewDelegate>
{
    BaseTableView *filmDetailView;
}

@end

@implementation DMFilmDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
}

-(void)setUpView
{
    self.title = @"速度与激情7";
    UIButton *leftbtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [leftbtn setBackgroundImage:[UIImage imageNamed:@"Back_Setting.png"] forState:UIControlStateNormal];
    [leftbtn setBackgroundImage:[UIImage imageNamed: @"Back_Setting.png"] forState:UIControlStateHighlighted];
    [leftbtn addTarget:self action:@selector(backToList) forControlEvents:UIControlEventTouchUpInside];
    [leftbtn setFrame:CGRectMake(0, 0, 28.0f, 28.0f)];
    UIBarButtonItem *backitem=[[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    self.navigationItem.leftBarButtonItem=backitem;
   [[self.navigationController.navigationBar viewWithTag:100] setHidden:YES];
    filmDetailView = [[BaseTableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStylePlain];
    [filmDetailView setBackgroundColor:[UIColor blackColor]];
    [filmDetailView setDataSource:self];
    [filmDetailView setDelegate:self];
    [self.view addSubview:filmDetailView];
}
#pragma mark---actions
-(void)backToList
{
    [self.navigationController popViewControllerAnimated:YES];
    [[[TabViewManager sharedTabViewManager] getTabView] setHidden:NO];
   [[self.navigationController.navigationBar viewWithTag:100] setHidden:NO];
}


#pragma mark---tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.row == 0 )
    {
        DMFilmInfoCell * cell = [[DMFilmInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        return cell;
    }
    else
    {
        static NSString *reuseStr = @"theCell";
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseStr];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseStr];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 240;
    }
    else
    {
        return 30.0f;
    }
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
