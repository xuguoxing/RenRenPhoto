//
//  DateSelectController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-22.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "DateSelectController.h"
#import "DateUtils.h"

@interface DateSelectController ()

@end

@implementation DateSelectController
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:indexPath.row*(24*3600)];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@",getDateString(date),getWeekString(date)];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:indexPath.row*(24*3600)];
    NSString *dateString = getDateString(date);
    NSString *weekString = getWeekString(date);

    [delegate performSelector:@selector(selectDate:weekDay:) withObject:dateString withObject:weekString];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
