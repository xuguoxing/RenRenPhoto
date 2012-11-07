//
//  MineTrainController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-11-7.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "MineTrainController.h"
#import "QueryViewController.h"
@interface MineTrainController ()

@end

@implementation MineTrainController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else if(section == 1){
        return 3;
    }else if(section == 2){
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section =indexPath.section;
    NSInteger row = indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (section == 0) {
        cell.textLabel.text = @"修改联系人";
    }else if(section == 1){
        if (row == 0) {
            cell.textLabel.text = @"车票预定";
        }else if(row == 1){
            cell.textLabel.text = @"未完成订单";
        }else if(row == 2){
            cell.textLabel.text = @"我的订单";
            cell.detailTextLabel.text = @"退票、改签";
        }
    }else if(section == 2){
        cell.textLabel.text = @"联系人管理";
    }
    cell.accessoryType = UITableViewCellStyleValue1;    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 1 && row == 0) {
        QueryViewController *controller = [[QueryViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
