//
//  DMFMChannelController.m
//  DoubanMedia
//
//  Created by jsonmess on 15/3/23.
//  Copyright (c) 2015年 jsonmess. All rights reserved.
//

#import "DMFMChannelController.h"
#import "BaseTableView.h"
#import "DMFMTableViewCell.h"
@interface DMFMChannelController ()<UITableViewDataSource,UITableViewDelegate>

@end
static NSString *reuseCell = @"FMChannelCell";

@implementation DMFMChannelController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)setUpView
{
    [self setTitle:@"豆瓣FM"];
    CGRect frame = (CGRect){{0,0},{self.view.bounds.size.width,self.view.bounds.size.height -kTabbarHeight}};
    BaseTableView *fmTableView = [[BaseTableView alloc] initWithFrame:frame
                                                    style:UITableViewStylePlain ];

    [fmTableView setDataSource:self];
    [fmTableView setDelegate:self];
	[self.view addSubview: fmTableView];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    return 5;
}


- (DMFMTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    DMFMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseCell];
    if (cell == nil)
    {
        cell = [[DMFMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:reuseCell];
    }

    [cell setCellContent:@"频道兆赫" isCurrentPlay:YES isDouBanRed:YES];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
