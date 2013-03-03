//
//  TrainNoSelectController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-23.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "TrainNoSelectController.h"
@interface TrainNoSelectController ()

@end

@implementation TrainNoSelectController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"选择车次";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.trainNoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TrainNoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //G101（北京南07:00→上海虹桥12:23）
    TrainNoInfo *trainNoInfo = [self.trainNoArray objectAtIndex:indexPath.row];
    //NSDictionary *trainNo = [self.trainNoArray objectAtIndex:indexPath.row];
    NSString *trainNoDesc = [NSString stringWithFormat:@"%@ (%@%@->%@%@)",trainNoInfo.trainNo,trainNoInfo.startStationName,trainNoInfo.startTime,trainNoInfo.endStationName,trainNoInfo.endTime];
    cell.textLabel.text = trainNoDesc;    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainNoInfo *trainNoInfo = [self.trainNoArray objectAtIndex:indexPath.row];
   /* NSDictionary *trainNoDic = [self.trainNoArray objectAtIndex:indexPath.row];
    NSString *trainNoString = [trainNoDic objectForKey:@"value"];
    NSString *trainNoDesc = [NSString stringWithFormat:@"%@ (%@%@->%@%@)",[trainNoDic objectForKey:@"value"],[trainNoDic objectForKey:@"start_station_name"],[trainNoDic objectForKey:@"start_time"],[trainNoDic objectForKey:@"end_station_name"],[trainNoDic objectForKey:@"end_time"]];
   // [self.delegate performSelector:@selector(selectTrainNo:desc:) withObject:trainNoString withObject:trainNoDesc];*/
    [self.delegate performSelector:@selector(selectTrainNo:) withObject:trainNoInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
