//
//  QueryResultController.m
//  RenrenPhoto
//
//  Created by xuguoxing on 12-10-28.
//  Copyright (c) 2012年 winddisk.com. All rights reserved.
//

#import "QueryResultController.h"
#import "TrainTicketInfo.h"
#import "AFNetworking.h"
#import "Constants.h"
#import "AFURLConnectionOperation+HTTPS.h"
#import "RegexKitLite.h"
#import "ConfirmOrderController.h"
#import "TrainSession.h"
@interface QueryResultController ()

@end

@implementation QueryResultController

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
    return [self.queryResultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    TrainTicketInfo *ticketInfo = [self.queryResultArray objectAtIndex:indexPath.row];
    NSString *title = [NSString stringWithFormat:@"%@ %@(%@)-%@(%@)",ticketInfo.trainCode,ticketInfo.fromStationName,ticketInfo.startTime,ticketInfo.toStationName,ticketInfo.arriveTime];
    NSString *ticket = [ticketInfo ticketInfo];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = ticket;
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrainTicketInfo *trainTicketInfo = [self.queryResultArray objectAtIndex:indexPath.row];
    [TrainSession sharedSession].selectTrainTicketInfo = trainTicketInfo;
    [[TrainSession sharedSession]submitOrderRequestWithCompletion:^(NSString *responseString, NSError *error) {
        if (responseString) {
            NSString *leftTicket = [responseString stringByMatching:@"\"left_ticket\"(\\s*)value=\"(.*)\"" capture:2];
            NSLog(@"leftTicket:%@",leftTicket);
            ConfirmOrderController *controller = [[ConfirmOrderController alloc]initWithStyle:UITableViewStyleGrouped];
            controller.leftTicket = leftTicket;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            NSLog(@"submit Error :%@",error);
        }

    }];
    
}

@end
